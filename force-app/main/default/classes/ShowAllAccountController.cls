public class ShowAllAccountController {
	
    @AuraEnabled
    public static List<Account> getRecords(){
        
        List<Account> acclist=[Select id,Name from Account];
        
        return acclist;
    }
}