@istest
public class Books4EveryoneSampleDataControllerTest {
    
    static testMethod void testController(){
        Test.startTest();
        Books4EveryoneSampleDataController.deleteAll();
        System.assertEquals(0, [select count() from book__c]);
        System.assertEquals(0, [select count() from author__c]);
        System.assertEquals(0, [select count() from recommendation__c]);
        Test.stopTest();
    }
    
}