public with sharing class fetchUserData {
@AuraEnabled(cacheable = true)
public static List<User> fetchUsers(){
    System.debug('------------'+[select Name, Email, profile.name, userrole.name FROM user]);
       return [select Name, Email, profile.name, userrole.name FROM user];
    }
}