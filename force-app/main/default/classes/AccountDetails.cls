public class AccountDetails {
	
    @AuraEnabled
    public static List<Contact> AccountData(){
        List<Contact> accData = [Select Id, FirstName, LastName, OtherStreet From Contact LIMIT 10];
       	
       /* List<AccountWrapper> listOfAccWrp = new List<AccountWrapper>();
        for(Contact accIt : accData){
            AccountWrapper accWrp = new AccountWrapper();
            accWrp.FirstName = accIt.FirstName;
            accWrp.LastName = accIt.LastName;
            accWrp.OtherStreet = accIt.OtherStreet;
            //accWrp.Name = accIt.Name;
            listOfAccWrp.add(accWrp);
        }
        System.debug('Account Wrapper'+listOfAccWrp);
        */return accData;
    }
    
    public class AccountWrapper{
        @AuraEnabled
        public String FirstName;
        @AuraEnabled
        public String LastName;
        @AuraEnabled
        public String OtherStreet;
    }
}