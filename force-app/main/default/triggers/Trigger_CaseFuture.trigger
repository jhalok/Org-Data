/**
*   Description     :  This is a after trigger to check the subject.
*
*   Created by      :   Alok Kumar
*
*   Created Date    :   31/07/2018
*
*   Revision Log    :   V1.0 - Created
*
**/
trigger Trigger_CaseFuture on Case (after insert) {
    
    //Trigger condition to get executed
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            
            //Calling static method of  SendEmailNotificationHelper class having new data
            Case_FutureTriggerHelper.deleteCase(Trigger.new);   
        }
    }
}