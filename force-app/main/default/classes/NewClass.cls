public class NewClass {
    
    @AuraEnabled
    public static List<Account> getAccountData(){
        WrapperData wpData = new WrapperData();
        List<Account> accData;
        try{
            accData = [Select Id, Name, showImage__c,(Select FirstName, LastName From Contacts) From Account];
            //System.debug('wrapper of Acc'+wpdata.listOfAcc);
            
            /*if(wpdata.listOfAcc.size() > 0){
                wpdata.listOfCon = [Select Id, FirstName, LastName From Contact Where AccountId IN :wpdata.listOfAcc]; 
                System.debug('wrapper of Acc'+wpdata.listOfCon);
                wpData.message = 'Contacts reterieved';
            }*/
        }catch(Exception ex){
            
        }
        return accData;
    }
    
    public class WrapperData{
        @AuraEnabled
        public List<Account> listOfAcc;
        @AuraEnabled
        public List<Contact> listOfCon;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public String size;
    }
}