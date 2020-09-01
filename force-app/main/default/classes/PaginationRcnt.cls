public class PaginationRcnt {
    @AuraEnabled
    public static List<Contact> getContacts(){
        List<Contact> contactList = new List<Contact>();
        contactList = [SELECT Id, Name, Email, Phone From Contact LIMIT 50];
        return contactList;
    }
}