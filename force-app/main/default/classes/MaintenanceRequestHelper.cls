public with sharing class MaintenanceRequestHelper {
    public static void updateWorkOrders(List<Case> caseList) {
        List<case> newCases = new List<Case>();
        Map<String,Integer> result=getDueDate(caseList);
        for(Case c : caseList){
            if(c.status=='closed')
                if(c.type=='Repair' || c.type=='Routine Maintenance'){
                    Case newCase = new Case();
                    newCase.Status='New';
                    newCase.Origin='web';
                    newCase.Type='Routine Maintenance';
                    newCase.Subject='Routine Maintenance of Vehicle';
                    newCase.Vehicle__c=c.Vehicle__c;
                    newCase.Equipment__c=c.Equipment__c;
                    newCase.Date_Reported__c=Date.today();
                    if(result.get(c.Id)!=null)
                        newCase.Date_Due__c=Date.today()+result.get(c.Id);
                    else
                        newCase.Date_Due__c=Date.today();
                    newCases.add(newCase);
                }
        }        
        insert newCases;   
    }
    //
    public static  Map<String,Integer> getDueDate(List<case> CaseIDs){       
        Map<String,Integer> result = new Map<String,Integer>();
        Map<Id, case> caseKeys = new Map<Id, case> (CaseIDs);        
        List<AggregateResult> wpc=[select Maintenance_Request__r.ID cID,min(Equipment__r.Maintenance_Cycle__c)cycle
                                   from Work_Part__c where  Maintenance_Request__r.ID in :caseKeys.keySet() group by             Maintenance_Request__r.ID ];
        for(AggregateResult res :wpc){
            Integer addDays=0;
            if(res.get('cycle')!=null)
                addDays+=Integer.valueOf(res.get('cycle'));
            result.put((String)res.get('cID'),addDays);
        }
        return result;
    }   
}