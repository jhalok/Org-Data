/**
* 	Description			:	This batch class is used to send total expense notification to the house owner
* 
* 	Created By			:	Alok Kumar
* 
* 	Created Date		:	30/07/2018
* 
* 	Revision Logs		:	V_1.0 - Created
**/
global class Batch_SendEmailNotification implements Database.Batchable<sObject> ,Database.Stateful {
    
    //Map to hold the email and epenses corresponding to that
    global Map<String,List<Expense__c>> expenseMap =new Map<String,List<Expense__c>>();
    
    /**
     * 	Description			:	Start() is used to extract the relevant data 
     * 
     * 	@argument Type		:	Context variable
     * 
     * 	@return Type		:	Database.QueryLocator object
     **/
    global Database.QueryLocator start(Database.BatchableContext bc){
     	
        //Perform the query using query locator and retrieved the needed information of person name,type,total expense
       
        return Database.getQueryLocator('SELECT ID, Member__r.Person__r.Name, Type__c, Total_Expense__c, Total_Balance__c, Available_Balance__c, CreatedDate, Member__r.House__r.House_Owner__r.Person__r.Email__c, Name FROM Expense__c WHERE Type__c = \'Monthly\' ');
    }
    
    /**
     * 	Description			:	Execute()for sending monthly expense detail mails to user
     * 
     * 	@argument Type		:	Database.BatchableContextObject Reference, List<Expense__c>
     * 
     * 	@return Type		:	Database.QueryLocator object
     **/
    global void execute(Database.BatchableContext BC, List<Expense__c> expenses){
        
        //Iteration of the expenses list 
        for(Expense__c exp : expenses){
            
            //Condition to check that email id exists or not
            if(!expenseMap.containsKey(exp.Member__r.House__r.House_Owner__r.Person__r.Email__c)) {
                
                //If the mail doesn't exists then put the email and corresponding to that expenses
                expenseMap.put(exp.Member__r.House__r.House_Owner__r.Person__r.Email__c,new List<Expense__c>());
            }
           	//Adding expenses corresponding to the the existing email 
            expenseMap.get(exp.Member__r.House__r.House_Owner__r.Person__r.Email__c).add(exp);    
        }  
    }
    /**
     * 	Description			:	Finish method is used to send emails to the corresponding House's, House Owner
     * 
     * 	@argument Type		:	Database.BatchableContext
     * 
     * 	@return Type		:	void
     **/
    global void finish(Database.BatchableContext BC){
         
        //Initilization of singleemailmessage list 
        List<Messaging.SingleEmailMessage> singleEmailMessages = new List<Messaging.SingleEmailMessage>();
        
        //String to show the expenses of the house.
       	String body = '';
        
        //Iteration of the keyset exists in expenseMap 
        for(String emailKey : expenseMap.keySet()){
            
            //expDetail will hold the Expense.
            String expDetail = '';
            for(Expense__c exp :expenseMap.get(emailKey)){
                
                //Including the expense of member corresponding to the mail and assigning it to the body 
                expDetail = 'Name = '+ exp.Name +', Total Expense ='+ exp.Total_Expense__c + ', Total Balance =' +  exp.Total_Balance__c;
                
                //Adding the expDetail to the message body
             	body = expDetail;
                
                //Creating instance of Mesaaging class Mail method.
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                //Including the Email to toAddresses.
                String[] toAddresses = new String[] {'alok.akjha@gmail.com'};
                    
                //Including the mail to toAddress field
                mail.setToAddresses(toAddresses);
               
                //To include the Subject field in the mail.
                mail.setSubject('Monthly Expense Notification of Your House');
                
                //To include the body field in the mail to show the expense content.
                mail.setHtmlBody(body);
             
                //Condition to check mail exists or not
                if(mail != null){
                    
                    //if mail is not null then add it to the Emailid list
                    singleEmailMessages.add(mail);   
                } 
            }
        }
        //It will send the mail to each existing House's, House Owner 
        messaging.sendEmail(singleEmailMessages);
    }
}