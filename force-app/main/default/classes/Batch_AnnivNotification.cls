/**
*   Description 	:   This is a batch class use to send anniversary wish email.
*
*   Created by      :   Alok kumar
*
*   Created Date    :   29/08/2018
*
*   Revision Log    :   V1.0 - Created
*
**/
global with sharing class Batch_AnnivNotification implements Database.Batchable<sObject>,Database.Stateful {
    
    global List<String> emaillist = new List<String>();
    
    global List<Person__c> personList = new List<Person__c>();
    
    /**
* 	Description			:	Start() is used to extract the relevant data 
* 
* 	@argument Type		:	Context variable
* 
* 	@return Type		:	Database.QueryLocator object
**/         
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        //Perform the query using query locator and retrieved the needed information of person
        return Database.getQueryLocator('Select ID,Name,Email__c,Anniversary__c from Person__c where Email__c!=null');
    }	
    
    /**
* 	Description			:	Execute()for sending monthly expense detail mails to user
* 
* 	@argument Type		:	Database.BatchableContextObject Reference, List<Expense__c>
* 
* 	@return Type		:	Database.QueryLocator object
**/             
    global void execute(Database.BatchableContext bc, List<Person__c> listPerson){
        
        Date curDate = Date.today();
        
        if(listPerson!=null){
            
            //Iteration a list to fetch all the email
            for(Person__c per : listPerson){
                
                if(per.Anniversary__c.month()==curDate.month() && per.Anniversary__c.day()==curDate.day()){
                    
                    //Adding mail in a list of string
                    emaillist.add(per.Email__c);
                } 	
            }
        }
    }        
    
    /**
* 	Description			:	Finish method is used to send emails to the corresponding House's, House Owner
* 
* 	@argument Type		:	Database.BatchableContext
* 
* 	@return Type		:	void
**/                      
    global void finish(Database.BatchableContext bc){
        
        //Instance of a message class
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //Iteration of a list of string
        for(String mailPer : emaillist){
            
            //Set the address of a person mail
            mail.setToAddresses(new String[] {mailPer});
            
            //Set the subject of a mail
            mail.setSubject('Anniversary Wish');
            
            //Email body to show the message
            mail.setPlainTextBody('Happy Anniversary');    	
            
            //Sending email on mentioned address
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    			
            
        }
    }
}