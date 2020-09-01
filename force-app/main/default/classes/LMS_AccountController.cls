public with sharing class LMS_AccountController {
    
    @AuraEnabled
    public static List<Account> getAccounts(){
          return [select id,name,type,phone from Account ORDER BY Name ASC limit 10 ];
    }
}