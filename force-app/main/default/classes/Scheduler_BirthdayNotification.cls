global class Scheduler_BirthdayNotification implements Schedulable {
    
    public static String scheduleTime = '0 0 15 31 7 ? *';
    
    global static String scheduleMail(){
        
        Scheduler_BirthdayNotification sbn = new Scheduler_BirthdayNotification();
        
        //Returning the name of the job, time and ref or the class Scheduler_SendEmailNotification
        return System.schedule('Birthday Notification', scheduleTime, sbn );
        
    }
    
    /**
* 
* @description  -  execute() is used to Initilize & execute the batch class
*
* @return       -  Null
* 
*/    
    global void execute(SchedulableContext sc) {
        
        Batch_BirthdayNotification bdyNtf = new Batch_BirthdayNotification();
        
        //Executing the batch
        Database.executeBatch(bdyNtf);           
    }         
}