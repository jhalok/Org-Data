public class test1 {

   @AuraEnabled
    public static Contact getContacts(){
        System.debug('inside apex');
        Contact listOfContact = [Select Name, OtherCity FROM Contact LIMIT 1];
        return listOfContact;
    }
}