public with sharing class AccountListControllerLwc {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> queryAccountsByRevenue(Decimal annualRevenue){
        return [Select id, Name From Account WHERE AnnualRevenue >=: annualRevenue];
    }
}