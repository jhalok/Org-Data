/**
*   Description 	:   This is a batch class use to send birthday wish email.
*
*   Created by      :   Alok Kumar
*
*   Created Date    :   29/08/2018
*
*   Revision Log    :   V1.0 - Created
*
**/
global with sharing class Batch_BirthdayNotification implements Database.Batchable<sObject>,Database.Stateful {
	
	global List<String> listOfMail = new List<String>();
	global List<Person__c> personList = new List<Person__c>();
	
	//Method Name:start
    //description:Use to collect the records for sending them to execute method
    //parameter: Database.BatchableContext
    //return type:Database.QueryLocator             
    global Database.QueryLocator start(Database.BatchableContext bc){
    	
        //return the records according to query
    	return Database.getQueryLocator('Select ID,Name,Email__c,Birthday__c from Person__c where Email__c!=null');
    }
    
	//Method Name:execute
    //description:Use to perform required processing on each chunk of data
    //parameter: Database.BatchableContext and a list of person object
    //return typ:void                 
    global void execute(Database.BatchableContext bc, List<Person__c> listPerson){
    	
    	if(listPerson != null){
    		//iteration of a list for fetching all the email
    		for(Person__c perso : listPerson){
    		
    			//add those mail in a list of string
    			listOfMail.add(perso.Email__c); 
    		}	
    	}
    }
    
	//Method Name:finish
    //description:Use to send confirmation emails or execute post-processing operations
    //parameter: Database.BatchableContext
    //return typ:void                     
    global void finish(Database.BatchableContext bc){
    	
    	//instance of a message class
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    	
    	//check that size is less than 101
    	if(listOfMail.size()<=100){
    		
    		//iteration of a list of string
    		for(String mailPer : listOfMail){
    			
    			//set the address of a person mail
    			mail.setToAddresses(new String[] {mailPer});
    			
    			//set the subject of a mail
		    	mail.setSubject('Birthday Wish');
		    	
		    	//body of a mail user see
				mail.setPlainTextBody('Wish you a very Happy Birthday');    	

				//send the email on defined address
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    			
    		}
    	}
    }
}