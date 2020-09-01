public class pagiSearchController {
    
    @AuraEnabled
    public static List < account > fetchAccount(String searchKeyWord){
        
        String searchKey = searchKeyWord + '%';
        List < Account > returnList = new List < Account > ();
        List < Account > lstOfAccount = [select id, Name, Type, Industry, Phone, Fax from account
                                         where Name LIKE: searchKey];  
        for (Account acc: lstOfAccount) {
            returnList.add(acc);
        }
        return returnList;
    }
    
    @AuraEnabled
    public static void deleteAccount(String accId){
        delete  [select id, Name, Type, Industry, Phone, Fax from account where id=:accId] ;
    }
    
    @AuraEnabled
    public static AccountDataTableWrapper getAccountData(Decimal pageNumber, Decimal pageSize){
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        Integer totalRecords = [SELECT COUNT() FROM Account];
        
        AccountDataTableWrapper objDT =  new AccountDataTableWrapper();  
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.totalRecords = totalRecords;
        objDT.accountList = [select Id, Name, Type, Industry, Phone, Fax, CreatedDate from account ORDER BY NAME LIMIT :pSize OFFSET:offset];
        return objDT;
    }
    
    public class AccountDataTableWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public List<Account> accountList {get;set;}
        @AuraEnabled
        public List<Account> accountList1 {get;set;}
        @AuraEnabled
        public Integer offset {get;set;}
    }
}