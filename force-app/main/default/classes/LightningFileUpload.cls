public class LightningFileUpload {   
    /*public Case caseData {get; set;}
	
    public LightningFileUpload(){
        caseData = new Case();
    }*/
    @AuraEnabled
    public Static Case insertCase(){  
        System.debug('inserCase mthd called');
        Case caseData = new Case();
        caseData.Origin = 'Phone';
        caseData.Status =  'New';
        caseData.Subject = 'Testing';
        System.debug('inserted data'+caseData);
        insert caseData;
        System.debug('inserted data---'+caseData);
        //Pagereference pr = new PageReference('/'+caseData.Id);//caseData;
        return caseData;
    }
    
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        System.debug('parentId---'+parentId);
        System.debug('fileID----'+fileId);
        System.debug('base64Data------'+base64Data);
        System.debug('contentType----'+contentType);
        if (fileId == '' || fileId == NULL) {
             fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        transient Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        insert oAttachment;
        return oAttachment.Id;
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        transient Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
        String existingBody = EncodingUtil.base64Encode(a.Body);
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        update a;
    }
}