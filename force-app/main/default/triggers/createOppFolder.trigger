trigger createOppFolder on Opportunity (after insert) {
    String sObj = 'Opportunity';
    GoogleDrive__c CS = GoogleDrive__c.getInstance();
    String accessToken = CS.Access_token__c;
    if(Trigger.isinsert && Trigger.isafter){
        for(Opportunity opp : Trigger.new){
            if(opp.AccountId != NULL){
                //GoogleDriveCntrlrHelper.createSubFolder(opp.Name,opp.Id);
                GoogleDriveCntrlrHelper.checkAccessTokenAndCreateFolder(opp.Name, opp.Id);
            }        
        }
    }
}