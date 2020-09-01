public class condt {
    @AuraEnabled
    public static List<Contact> condata(){
        List<Contact> lstData = [select id, LastName from contact];
        System.debug('lstData'+lstData);
        return lstData;
    }
}