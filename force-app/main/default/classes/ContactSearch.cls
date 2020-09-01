public class ContactSearch {

    public static List<contact> searchForContacts(String lName,String posEmailCode){
        
        List<contact> mtchngData = [Select id,FirstName,LastName,MailingPostalCode from contact WHERE LastName =:lName and MailingPostalCode =:posEmailCode];

		return mtchngData;        
    }
}