public with sharing class UploadFile_Controller {
    public transient Attachment objAttachment;
    
    //Use getter so we can make attachment transient
    public Attachment getObjAttachment(){
        objAttachment = new Attachment();
        return objAttachment;
    }
    
    public Boolean fileUploadProcessed{get;set;}
    public String message{get;set;}
    public String messageType{get;set;}
    
    // @Aurae
    public Static Case insertCase(){       
        Case caseData = new Case();
        caseData.Origin = 'Phone';
        caseData.Status =  'New';
        caseData.Subject = 'Testing';
        System.debug('inserted data'+caseData);
        insert caseData;
        return caseData;
    }
    
    Public void uploadFile(){
        try {
            Case caseData = new Case();
            caseData.Origin = 'Phone';
            caseData.Status =  'New';
            caseData.Subject = 'Testing';
            System.debug('inserted data'+caseData);
            insert caseData;
            objAttachment.ParentId =  '5006F00002bee7VQAQ';//(Id) ApexPages.currentPage().getParameters().get('id');
            System.debug('objAttachment.ParentId ----'+objAttachment.ParentId );
            insert objAttachment;
            
            message = 'File was uploaded successfully';
            messageType = 'success';
        }catch(Exception e){
            message = e.getMessage();
            messageType = 'error';
        }
        fileUploadProcessed = true;
    }
}