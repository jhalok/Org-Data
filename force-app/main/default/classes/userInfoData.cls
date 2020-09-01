public with sharing class userInfoData {
    
    @AuraEnabled(Cacheable=true)
    public static List<User> getActiveUserList(){
        List<User> activeUsers = new List<User>();
        activeUsers = [select Id, Name , Email, LastName, FirstName, CommunityNickname, Username, Profile.Name, PortalRole, IsActive, Userrole.Name, SmallPhotoUrl, BannerPhotoUrl from User WHERE IsActive =:True ORDER BY Name ASC];
        System.debug('---active users---'+activeUsers);
        return activeUsers;
    }

    /*@AuraEnabled(Cacheable=true)
    public static List<Case> getActiveUserList(){
        List<Case> activeUsers = new List<Case>();
        activeUsers = [select Id From Case];
        System.debug('---active users---'+activeUsers);
        return activeUsers;
    }*/

    @AuraEnabled
    public static List<User> moreDataLoad(String recordId){
        List<User> activeUsers = new List<User>();
        activeUsers = [select Id, Name , Email, LastName, FirstName, CommunityNickname, Username, Profile.Name, PortalRole, IsActive, Userrole.Name, SmallPhotoUrl, BannerPhotoUrl from User WHERE IsActive =:True and ID >: recordId ORDER BY Name ASC LIMIT 50000];
        System.debug('---active users---'+activeUsers);
        return activeUsers;
    }

    @AuraEnabled(Cacheable=true)
    public static List<User> getInActiveUserList(){
        List<User> inactiveUsers = new List<User>();
        inactiveUsers = [select Id, Name , Email, LastName, FirstName, CommunityNickname, Username, Profile.Name, PortalRole, IsActive, Userrole.Name, SmallPhotoUrl, BannerPhotoUrl from User WHERE IsActive =:False];
        System.debug('---Inactive users---'+inactiveUsers);
        return inactiveUsers;
    }

    @AuraEnabled
    public static void sendResetPasswordMail(Id userId, Boolean Dataa){
        System.debug('usrID'+userId+'Dataa'+Dataa);
        List<User> users = new List<User>();
        users = [SELECT Id, Name FROM User WHERE Id  =: userId];
        System.debug('------users'+users);
        for(User u : users){
            //For reset User password
            System.resetPassword(u.Id, true);
        }
    }

    @AuraEnabled
    public static String deactivateUser(Id userId){
        System.debug('user Id'+userId);
        List<User> users = [Select IsActive, UserRoleId, UserRole.Name from User where Id =:userId];
        System.debug('users'+users);
        List<User> lstUsers = new List<User>();
        try{
            for(User u: users){
            if(u.IsActive){
                System.debug('inside active if');
                u.IsActive = false;
                lstUsers.add(u);
            }else{
                System.debug('inside inactive else');
                u.IsActive = true;
                lstUsers.add(u);
            }
        }
        update lstUsers;
        }catch(Exception ex){
            System.debug('Exception ex'+ex);
            throw new AuraHandledException(ex.getMessage());
        }
        return null;
    }
}