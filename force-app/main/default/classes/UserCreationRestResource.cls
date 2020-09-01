@RestResource(urlMapping='/AccountUserCreation/*')
global with sharing class UserCreationRestResource {
    
    @HttpPost
    global static Lead CreateUserViaAccount(Id leadId) {
        Lead result =  [SELECT Id,FirstName,Lastname,Email,Status FROM Lead WHERE Id = :leadId];        
        
        String ProfileId = [Select Id From Profile Where Name='Customer Community Plus User'].id;
        
        List<User> userList = new List<User>();    
        User user = new User();
        user.ProfileID = ProfileId;
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'Australia/Sydney';
        user.LocaleSidKey = 'en_AU';
        user.FirstName = result.FirstName;
        user.LastName = result.LastName;
        user.Username = 'dpk.joshi21@gmail.com';
        user.CommunityNickname = result.LastName + '_'+ 1;
        user.Alias = string.valueof(result.FirstName.substring(0,1) + result.LastName.substring(0,1));
        user.Email = 'dpk.joshi21@gmail.com';
        user.IsActive = true;
        userList.add(user);  
        try {
            if (!userList.isEmpty()) 
                insert userList;
        }
        catch(Exception ex)
        {
            System.debug('UserCreationRestResource: ' + ex);
        }
        return result;
    }
}