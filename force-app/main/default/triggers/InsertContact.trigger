trigger InsertContact on Account (after insert) {
    List<Account> accList = [Select id, Name From Account Where id IN :trigger.new];
    
    for(Account acc: accList){
        if(accList.size() > 0){
            
        }
    }
    

}