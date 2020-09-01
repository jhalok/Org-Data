public class LargeFileUploadLgtng {
    
    @AuraEnabled
    public Static Case insertCase(){
        List<Case> caseData = new List<Case>();
        Case c = new Case();
        c.Origin = 'Phone';
        c.Status =  'New';
        c.Subject = 'Testing';
        System.debug('inserted data'+c);
        insert c;
        return c;
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
        
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        
        insert oAttachment;
        
        return oAttachment.Id;
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        
        update a;
    }
}