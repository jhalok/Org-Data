global class ContactApprovalStatus_Scheduler implements Schedulable {
	
    global void execute(SchedulableContext sc){
         
        String scheduledTime = '0 15 * * * ? *';
        
        ContactApprovalStatus_Scheduler cntAppSch = new ContactApprovalStatus_Scheduler();
            
  		String jobID = system.schedule('contacts ready for approval', scheduledTime, cntAppSch);
     
    }
}