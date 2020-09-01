public class ShowContact {
	
    @AuraEnabled
    public static List<Contact> contData(){
        List<Contact> listOFContact = [Select Name, LastName From Contact LIMIT 10];
        return listOFContact;
    }
}