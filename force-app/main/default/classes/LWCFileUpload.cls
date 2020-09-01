public with sharing class LWCFileUpload {
    
   /* @AuraEnabled
    public static void saveFile(Id idParent, String strFileName, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment attach = new Attachment();
        attach.parentId = idParent;
        attach.Body = EncodingUtil.base64Decode(base64Data);
        attach.Name = strFileName;
        System.debug('insert-----'+attach);
        Insert attach;
    }

    @AuraEnabled
    public static list<Attachment> releatedFiles(Id idParent){
        list<id> lstAttachment = new list<id>();
        for(Attachment cntLink : [SELECT Id, ContentType, BodyLength, Body FROM Attachment WHERE Id =:idParent]) {
            lstAttachment.add(cntLink.Id);
        }
        if(!lstAttachment.isEmpty()) {
            System.debug('inside if---'+[SELECT Id, ContentType, BodyLength, Body FROM Attachment WHERE Id IN :lstAttachment]);
            return [SELECT Id, ContentType, BodyLength, Body FROM Attachment WHERE Id IN :lstAttachment];
        }
        else {
            return null;
        }
    }*/
     @AuraEnabled
    public static ContentVersion saveFile(Id idParent, String strFileName, String base64Data) {
        System.debug('--parentId--'+idParent);
        // Decoding base64Data
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        // inserting file
        transient ContentVersion cv = new ContentVersion();
        cv.Title = strFileName;
        cv.PathOnClient = '/' + strFileName;
        cv.FirstPublishLocationId = idParent;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.IsMajorVersion = true;
        Insert cv;
        return cv;
    }

    @AuraEnabled
    public static list<contentversion> releatedFiles(Id idParent){
        list<id> lstConDocs = new list<id>();
        for(ContentDocumentLink cntLink : [Select Id, ContentDocumentId From ContentDocumentLink Where LinkedEntityId =:idParent]) {
            lstConDocs.add(cntLink.ContentDocumentId);
        }
        if(!lstConDocs.isEmpty()) {
            return [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :lstConDocs];
        }
        else {
            return null;
        }
     
    }
      
}