public class AccountProcessor {

    @future
    public static void countContacts(Set<Id> accountId){
        List<Account> accountData = [Select id, Number_of_Contacts__c,(Select Id from Contacts) from Account Where Id IN : accountId];
        
        for(Account acc : accountData){
            if(acc != NULL){
                acc.Number_of_Contacts__c = acc.Contacts.size();
            }
        }
        update accountData;
    }
}