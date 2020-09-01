trigger InsertNewAccount on Account(before insert) {
    
    if(trigger.isBefore){
        accCreation.createAcc(trigger.new,trigger.oldMap);
    }
}