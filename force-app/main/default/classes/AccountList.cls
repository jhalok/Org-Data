public class AccountList {

    @AuraEnabled
    public static List<Account> getAcc(){
       List<Account> accList =[SELECT id,Name,AccountNumber,BillingAddress FROM Account];
        
       return accList;
    }
}