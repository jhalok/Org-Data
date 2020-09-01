trigger AccountTrigger on Account (before insert) {
    
    if(trigger.isBefore){
        
        if(trigger.isInsert){
            AccountTriggerHelper.changeAdd(Trigger.new);
        }
    }
}