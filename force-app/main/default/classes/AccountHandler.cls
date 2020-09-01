public class AccountHandler {
    
    public static Account insertNewAccount(String AccountName){
        Account acc = new Account(name = AccountName);
        try{    
            insert acc;
            return acc;
        }
        catch(DMLException e){
            return null;
        }
    }
}