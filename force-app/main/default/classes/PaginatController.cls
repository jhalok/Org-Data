public class PaginatController {
	
    @AuraEnabled
    public static AccountDataTableWrapper getAccountData(Decimal pageNumber, Decimal pageSize){
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        System.debug('offset'+offset);
        Integer totalRecords = [SELECT COUNT() FROM Account];
        
        AccountDataTableWrapper objDT =  new AccountDataTableWrapper();  
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.totalRecords = totalRecords;
        objDT.accountList = [SELECT Id, Name,AccountNumber, Phone, Website,Industry FROM Account ORDER BY Name LIMIT :pSize OFFSET :offset];
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
        public List<Account> accountList {get;set;}
    }
}