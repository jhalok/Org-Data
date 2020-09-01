public class popUpContr {

    @AuraEnabled
    public static Account saveAccount (Account acc) {
        System.debug('hhii'+acc);
        upsert acc;
        return acc;
    }
    
     @AuraEnabled
     public static List<String> getIndustry(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Industry.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
         System.debug(options);
        return options;
     }
}