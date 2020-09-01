public class Pagination {
    @AuraEnabled
    public static List<Account> getLimitedAccounts(){
        List<Account> accounts = [SELECT Id, Name, Phone, Website FROM Account ORDER BY CreatedDate LIMIT 50000];
        return accounts;
    }
}