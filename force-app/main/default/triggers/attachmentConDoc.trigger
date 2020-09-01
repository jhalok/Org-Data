trigger attachmentConDoc on ContentDocumentLink (after insert) {
    /*Attachment at = [Select Body,ContentType, Id, Name, OwnerId,ParentId From Attachment LIMIT 1];
ContentVersion cv = new ContentVersion(); 
cv.ContentLocation = 'S'; 
cv.PathOnClient = at.Name; 
cv.Origin = 'H'; 
cv.OwnerId = at.OwnerId; 
cv.Title = at.Name; 
cv.VersionData = at.Body; 

for(ContentDocumentLink cdl: Trigger.new){
GoogleDriveCntrlrHelper.upldFile(cdl.Id,cv.VersionData,at.ContentType);
}*/
    
    GoogleDrive__c CS = GoogleDrive__c.getInstance();
    String folderId = CS.FolderId__c;
    
    String idTest;  
    Opportunity opp =[Select id,Name from Opportunity where id =: '0066F000015iGJD'];  
    
    List<ContentDocumentLink> conlink = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: opp.Id];  
    
    for(ContentDocumentLink conids : conlink){  
        
        //idset.add(conids.ContentDocumentId);  
        if(conids != NULL){
            idTest = conids.ContentDocumentId;  
            //GoogleDriveCntrlrHelper.fileUpldNew(idTest,folderId);
        }
        
    }
}