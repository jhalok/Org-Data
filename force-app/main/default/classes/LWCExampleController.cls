public with sharing class LWCExampleController {
    
    @AuraEnabled
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
    }  
}