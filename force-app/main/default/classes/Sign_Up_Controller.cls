public class Sign_Up_Controller {
    @AuraEnabled
    public static void registerUser(String lname, String fname,String email, String uname, String alias){
        
        Account acc = new Account(Name = fname +' '+lname);
        insert acc;
        Account parentAcc = [select id from Account where Name =: acc.Name limit 1];
        
        Contact con = new Contact(FirstName = fname, LastName = lname, AccountId = parentAcc.id );
        insert con;
        
        Contact childCon = [select id from contact where FirstName =:fname AND LastName = :lname limit 1];
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'CustomerCommunityLoginClone' LIMIT 1];
        User usr = new User(LastName = lname,
                            FirstName=fname,
                            Email = email,
                            Username = uname,
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US',
                            ContactId = childCon.id,
                            Alias = alias
                           );
        try{
            insert usr;
        }
        catch(exception e){
            system.debug('Error'+e.getMessage());
        }
    }
}