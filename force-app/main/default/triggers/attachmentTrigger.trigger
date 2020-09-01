trigger attachmentTrigger on Attachment (after insert) {
    if(Trigger.isinsert && Trigger.isafter){
        for(Attachment att : Trigger.new){
			 GoogleDriveCntrlrHelper.checkAccessTokenAndCreateFolder(att.Name,att.Id);            
            //GoogleDriveCntrlrHelper.upldFile(att.ParentId,att.Name,att.Id,att.Body,att.ContentType);
        }
    }
}