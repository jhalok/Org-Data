global with sharing class BatchProcessor implements Database.Batchable<sObject>, Database.Stateful{
    global List<sObject> myList;
    
    global BatchProcessor(List<sObject> myList){
        this.myList = myList;
    }
    
    global List<sObject> start(Database.BatchableContext BC){
        System.debug('myList-->' + myList);
        return myList;
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('==========check string====='); 
        List<sObject> sObjectList = new List<sObject> ();
        System.debug('scope ==> ' + scope);
        insert scope;
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}