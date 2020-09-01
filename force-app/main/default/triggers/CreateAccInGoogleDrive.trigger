trigger CreateAccInGoogleDrive on Account (after insert) {
    System.debug('in trigger');
    if(Trigger.isinsert && Trigger.isafter){
        for (Account a : Trigger.new) {
            GoogleDriveCntrlrHelper.checkAccessTokenAndCreateFolder(a.Name,a.Id);
            //GoogleDriveCntrlrHelper.createFolder(accessToken,a.Name,a.Id);
        }   
    }
}