@isTest
public  class MaintenanceRequestTest {
    static  List<Case> caseList1 = new List<Case>();
    static List<Product2> prodList = new List<Product2>();
    static List<Work_Part__c> wpList = new List<Work_Part__c>();
    @testSetup
    static void getData(){
        caseList1= CreateData( 300,3,3,'Repair');
    }
    
    public static List<Case>   CreateData( Integer numOfcase, Integer numofProd, Integer numofVehicle,
                                          String type){
                                              List<Case> caseList = new List<Case>();
                                              //Create Vehicle
                                              Vehicle__c vc = new Vehicle__c();
                                              vc.name='Test Vehicle';
                                              upsert vc;
                                              //Create Equiment
                                              for(Integer i=0;i<numofProd;i++){
                                                  Product2 prod = new Product2();
                                                  prod.Name='Test Product'+i;
                                                  if(i!=0)
                                                      prod.Maintenance_Cycle__c=i;
                                                  prod.Replacement_Part__c=true;
                                                  prodList.add(prod);
                                              }
                                              upsert  prodlist;
                                              //Create Case
                                              for(Integer i=0;i< numOfcase;i++){
                                                  Case newCase = new Case();
                                                  newCase.Status='New';
                                                  newCase.Origin='web';
                                                  if( math.mod(i, 2) ==0)
                                                      newCase.Type='Routine Maintenance';
                                                  else
                                                      newCase.Type='Repair';
                                                  newCase.Subject='Routine Maintenance of Vehicle' +i;
                                                  newCase.Vehicle__c=vc.Id;
                                                  if(i<numofProd)
                                                      newCase.Equipment__c=prodList.get(i).ID;
                                                  else
                                                      newCase.Equipment__c=prodList.get(0).ID;
                                                  caseList.add(newCase);
                                              }
                                              upsert caseList;
                                              for(Integer i=0;i<numofProd;i++){
                                                  Work_Part__c wp = new Work_Part__c();
                                                  wp.Equipment__c   =prodlist.get(i).Id   ;
                                                  wp.Maintenance_Request__c=caseList.get(i).id;
                                                  wplist.add(wp) ;
                                              }
                                              upsert wplist;
                                              return caseList;
                                          }
    
    public static testmethod void testMaintenanceHelper(){
        Test.startTest();
        getData();
        for(Case cas: caseList1)
            cas.Status ='Closed';
        update caseList1;
        Test.stopTest();
    }
    
}