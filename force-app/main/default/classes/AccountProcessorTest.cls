@isTest
public class AccountProcessorTest {
    public static testmethod void TestAccountProcessorTest(){
     Account a = new Account();
        a.Name = 'Test Account';
        Insert a;
        system.debug('account a :'+a.id);
        
        Contact cont = New Contact();
        cont.FirstName ='Ankit';
        cont.LastName ='Avula';
        cont.AccountId = a.Id;
        Insert cont;
        system.debug('contact cont :' +cont.id);
        
      	Set<Id> accIds = new Set<Id>();
        accIds.add(a.Id);
        
        if (test.isRunningTest()){
            Test.setMock(HttpCalloutMock.class, new UploadFileMock());
        }
        //Test.startTest();
        AccountProcessor.countContacts(accIds);
        //Test.stopTest();
        
       // Account ACC = [select Number_of_Contacts__c from Account where id = :a.id LIMIT 1];
       // System.assertEquals(ACC.Number_of_Contacts__c, 1);
        
    }
}