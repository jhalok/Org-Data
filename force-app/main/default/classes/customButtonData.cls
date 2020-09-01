public class customButtonData {
    @AuraEnabled
    public static Profile fetchUser(){
        Profile userData = [SELECT Id, Name FROM Profile Where id =: userInfo.getProfileId()];
        System.debug('--userData'+userData);
        return userData;
    }
    
    @AuraEnabled
    public static String customSettingData(String prflName){
        List<Connect_Transition_Profile_Mapping__c> custmStngCTPMData = Connect_Transition_Profile_Mapping__c.getall().values();
        System.debug('--custmStngCTPMData--'+custmStngCTPMData);
         User userDta = [SELECT Id, ProfileId, Name FROM User Where id =: userInfo.getUserId()];
         for(Connect_Transition_Profile_Mapping__c csdata : custmStngCTPMData){
            if(csData.X10K_Connect_Profile__c == prflName){
                return 'This user is already in 10K Connect.';
            }else if(csData.Old_Community_Profile__c != prflName){
                return 'This user is not authorized to move to 10K Connect just yet.';
            }else if(csData.Old_Community_Profile__c == prflName){
                userDta.ProfileId = '00e6F000001d3nP';
                //'00e6F000002nowsQAA';
                update userDta;
                return 'Profile updated.';
            }
        }
        return '';
    } 
}