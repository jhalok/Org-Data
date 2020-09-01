@RestResource(urlMapping='/Lead/*')
global with sharing class CreateUser {
    @HttpGet
    global static Lead getLead(){
        RestRequest request = RestContext.request;
        system.debug(RestContext.request);       
        system.debug(request.requestURI);
        String leadId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);   
        System.debug('leadId'+leadId);
        Lead result =  [SELECT Id,FirstName,Lastname,Email,Status FROM Lead WHERE Id = :leadId];        
        System.debug('result'+result);
        List<User> userList = new List<User>();
        
        User user = new User();
        user.ProfileID = '00e6F000002noxT';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'Australia/Sydney';
        user.LocaleSidKey = 'en_AU';
        user.FirstName = result.FirstName;
        user.LastName = result.LastName;
        user.Username = result.Email;
        user.CommunityNickname = result.LastName + '_'+ 1;
        user.Alias = string.valueof(result.FirstName.substring(0,1) +
                                    result.LastName.substring(0,1));
        user.Email = result.Email;
        user.IsActive = true;
        userList.add(user);
        
        try {
            if (!userList.isEmpty())           
                insert userList;           
        }
        catch(Exception ex)
        {
            System.debug('AccountCreatePortalUserTrigger: ' + ex);
        }
        return result;
    }
}