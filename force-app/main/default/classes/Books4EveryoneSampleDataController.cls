global with sharing class Books4EveryoneSampleDataController {
    
    @RemoteAction
    global static void deleteAll() {
        DELETE [SELECT ID FROM book__c];
        DELETE [SELECT ID FROM author__c];
        DELETE [SELECT ID FROM recommendation__c];
    }
}