trigger PrimaryContact on Contact (before insert,after insert) {
    if(trigger.isUpdate || trigger.isInsert){
        Trigger_PrimaryContact.checkContData( trigger.new, trigger.old);
    }       
}