/**
* 	Description			:	This Scheduler class is used to schedule the email of total expenses to the house Owner
* 
* 	Created By			:	Alok Kumar
* 
* 	Created Date		:	31/07/2018
* 
* 	Revision Logs		:	V_1.0 - Created
**/
global class Scheduler_SendEmailNotification implements Schedulable {
     
    //Time to schedule when we want batch class to send email
    public static String scheduleTime = '0 0 15 31 7 ? *';
    
    /**
* 
* @description  -  scheduleEmail() is used to Insanitate the Scheduler class and return the three parameter
*
* @return       -  String
* 
*/    
    global static String scheduleEmail() {
        
        Scheduler_SendEmailNotification schSenEmlNtf =new Scheduler_SendEmailNotification(); 
        
        //Returning the name of the job, time and ref or the class Scheduler_SendEmailNotification
        return System.schedule('Expense Notification', scheduleTime, schSenEmlNtf );
    }
        
    
/**
* 
* @description  -  execute() is used to Initilize & execute the batch class
*
* @return       -  Null
* 
*/    
        global void execute(SchedulableContext sc) {
        
        Batch_SendEmailNotification sndEmlNtf = new Batch_SendEmailNotification();
		
        //Executing the batch
        Database.executeBatch(sndEmlNtf);           
    }         
}