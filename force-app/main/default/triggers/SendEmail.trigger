trigger SendEmail on EmailMessage (after insert) {
    if(Recursive.runOnce()){
    	sendEmail.sendNotification(trigger.new);
    }
}