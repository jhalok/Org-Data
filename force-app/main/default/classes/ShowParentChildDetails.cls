public class ShowParentChildDetails {

    /*@AuraEnabled
    public static WrapperDataa getObjectOptions(){
    WrapperDataa wrpObj = new WrapperDataa();
    List<SelectOption> options = new List<SelectOption>();
    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

    for(Schema.SObjectType thisObj : gd.values()) {
        options.add(thisObj);
    }
    System.debug('options  '+options);
        return wrpObj;
    }*/

    @AuraEnabled
    public static WrapperDataa getAccountRecords() {
        WrapperDataa wrpObj = new WrapperDataa();
        wrpObj.listOfAccount = [Select id,Name,(Select id,CaseNumber from Cases),(Select id,Name from Contacts) from Account ORDER BY Name DESC LIMIT 10 ];
        wrpObj.totalSize = [Select count() from Account];
        return wrpObj;
    }
    
    @AuraEnabled
    public static WrapperDataa getContactRecords(string accId) {
        WrapperDataa wrpObj = new WrapperDataa();
       	wrpObj.listOfContact = [Select id,Name from Contact Where AccountId =: accId LIMIT 10];  
        wrpObj.listOfCase = [Select id,CaseNumber from Case Where AccountId =: accId LIMIT 10];
        System.debug('wrpObj  ' +wrpObj);

        return wrpObj;
    }
    /*@AuraEnabled
    public static List<Case> getCaseRecords(string accId){
		return new List<Case>([Select id,CaseNumber from Case Where AccountId =: accId LIMIT 10]);        
    }*/
    public class WrapperDataa{
        @AuraEnabled
        public List<Account> listOfAccount;
        @AuraEnabled
        public List<Contact> listOfContact;
        @AuraEnabled
        public List<Case> listOfCase;
        @AuraEnabled
        public Integer totalSize;
               
        public WrapperDataa(){
            listOfAccount = new List<Account>();
            listOfContact = new List<Contact>();
            listOfCase = new List<Case>();

        }
    }
}