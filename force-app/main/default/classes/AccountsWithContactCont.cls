public class AccountsWithContactCont {
	
    @auraEnabled
	public static list<account> getAllAccounts() {
         list<account> accs =[select id,name,phone,industry,(select lastName,firstName from contacts) from account limit 20];
         return accs;
     }
}