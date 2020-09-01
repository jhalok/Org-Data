public class GoogleDriveCntrlrHelper {
    public static final String GET_ACCESS_TOKEN_FROM_REFRESH_TOKEN= 'GET ACCESS TOKEN FROM REFRESH TOKEN';
    
    public static String upldFile(String accessToken,String Name,String attId){ //String attachmentId,Blob VersionData,String ContentType
        System.debug('inside upldFile');
        Id Prnt;
        String cntntType;
        Blob VersionData;
        List<Attachment> attData = [Select id, ParentId, ContentType, Body from Attachment where Id = :attId];
        System.debug('attData---'+attData);
        for(Attachment acc: attData){
            Prnt = acc.ParentId;
            cntntType = acc.ContentType;
            VersionData = acc.Body;
        }
        List<sobject> records;
        String cols = 'Id,Name,FolderGDrive__c ';
        String condition ='id =: Prnt';
        //String typeOfId = ParentId.substring(0,ParentId.length()-15);
        //System.debug('id trimd'+typeOfId);
        String folderId;
        SobjectType sobj = Prnt.getsobjecttype();
        System.debug('--sobj--'+sobj);
        string query = 'select '+cols+' from '+sobj+' where '+condition;
        System.debug('--query--'+query);
        records = Database.query(query);
        for (sObject record : records){
            folderId = (String)record.get('FolderGDrive__c');
            System.debug('inside for loop data----'+folderId);
        }
        System.debug('--folderId--> '+folderId);
        String boundary = '----------9889464542212';
        String delimiter = '\r\n--' + boundary + '\r\n';
        String close_delim = '\r\n--' + boundary + '--';
        String bodyEncoded = EncodingUtil.base64Encode(VersionData);
        System.debug('bodyEncoded == ' + bodyEncoded);
        Blob myBlob = VersionData;
        String body = delimiter + 
            'Content-Type: application/json\r\n\r\n' + 
            '{ "title" : "' + Name + '",' + 
            ' "mimeType" : "' + cntntType + '",' + 
            ' "parents": [{"kind": "drive#fileLink","id": "' + folderId + '"}]}' + 
            delimiter + 
            'Content-Type: ' + cntntType + '\r\n' + 
            'Content-Transfer-Encoding: base64\r\n' + 
            '\r\n' + 
            bodyEncoded + 
            close_delim;
        System.debug('body---------'+body);
        HttpRequest req = new HttpRequest();  
        req.setMethod('POST');           
        req.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');   
        req.setBody(body);
        req.setHeader('Authorization', 'Bearer '+accessToken);
        req.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
        req.setHeader('Content-length', String.valueOf(body.length()));
        //req.setBodyAsBlob(myBlob); 
        req.setTimeout(60*1000);   
        Http http = new Http();  
        HttpResponse res;    
        try {
            res = http.send(req);
        } 
        catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
        String responseStr = res.getBody();
        System.debug('responseStr--> '+ responseStr);
        
        if(responseStr.contains('Invalid Credentials')){
            return GET_ACCESS_TOKEN_FROM_REFRESH_TOKEN;
        }else{
            Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(responseStr);
            System.debug('responseMap--> '+responseMap);
        }
        System.debug('resp==='+ res.getBody());  
        return null;
    }
    
    @Future(callout = true)
    public static void checkAccessTokenAndCreateFolder(String FolderName,String curntId){ //Id accountId,String FolderName,String accessToken
        GoogleDrive__c CS = GoogleDrive__c.getInstance();
        System.debug('CS==>'+ CS);
        String key = CS.Client_Id__c;
        String secret = CS.Client_secret__c;
        String accessToken = CS.Access_token__c;
        String refreshToken = CS.Refresh_Token__c;
        Id Prnt = curntId;
        SobjectType sobj = Prnt.getsobjecttype();
        //String objtype = (String)sobj;
        System.debug('sobject type==========='+sobj);
        System.debug('key -->' + key);
        System.debug('secret -->' + secret);
        System.debug('accessToken -->' + accessToken);
        System.debug('refresh_token -->' + refreshToken);
        String typeOfId = curntId.substring(0,curntId.length()-15);
        System.debug('id trimd'+typeOfId);
        
        List<Attachment> attchmData = [Select Id,body,ContentType from Attachment where Id = :curntId];
        String attchmntId = '00P';
        String folderCreationStatus; 
        //String folderCreationStatus = GoogleDriveCntrlrHelper.createFolder(accessToken, FolderName, curntId);
        if(typeOfId == '001'){
            System.debug('inside if ');
            folderCreationStatus = GoogleDriveCntrlrHelper.createFolder(accessToken, FolderName, curntId);     
        }else if(typeOfId == '006'){
            System.debug('inside else of sub');
            folderCreationStatus = GoogleDriveCntrlrHelper.createSubFolder(accessToken, FolderName, curntId);    
        }else if(attchmntId == '00P'){
            System.debug('inside else of attachment');
            folderCreationStatus = GoogleDriveCntrlrHelper.upldFile(accessToken, FolderName, curntId); 
        } 
        if(folderCreationStatus == GET_ACCESS_TOKEN_FROM_REFRESH_TOKEN){
            // need callout for testing access token   
            GoogleDriveCntrlr GoogleDriveCntrlrObj = new GoogleDriveCntrlr();
            accessToken = GoogleDriveCntrlrObj.getAccessTokenFromRefreshToken(key, secret, refreshToken);
            System.debug('accessToken --->' + accessToken);
            // STORE ACCESS TOKEN IN CUSTOM SETTING
            if(accessToken == 'ERROR'){
                // PAGE MESSAGE--> REFRESH TOKEN EXPIRES PLEASE CLICK ON AUTH BUTTON AGAIN
            }else{
                if(typeOfId == '001'){
                    System.debug('inside if ');
                    GoogleDriveCntrlrHelper.createFolder(accessToken, FolderName, curntId);     
                }else if(typeOfId == '006'){
                    System.debug('inside else of sub');
                    GoogleDriveCntrlrHelper.createSubFolder(accessToken, FolderName, curntId);    
                }else if(attchmntId == '00P'){
                    System.debug('inside else of attachment');
                    GoogleDriveCntrlrHelper.upldFile(accessToken, FolderName, curntId); 
                }
            }
        }        
    }
    /**
	* Create Folder in Google Drive
	*/
    public Static String createFolder(String accessToken, String FolderName,String curntId){
        System.debug('inside createFolder');
        System.debug('curnt acc id'+curntId);
        System.debug('inside'+accessToken);
        System.debug('FolderName'+FolderName);
        HttpRequest req = new HttpRequest();   
        req.setMethod('POST');  
        req.setEndpoint('https://www.googleapis.com/drive/v2/files');       
        //String body = '{"name" : "'+FolderName+'","mimeType" : "application/vnd.google-apps.folder"}';  
        String body = '{"'+
            'mimeType": "application/vnd.google-apps.folder",'+
            '"title": "'+ FolderName +'",'+
            '"parents": [{"id": "root"}]}';
        
        req.setTimeout(60*1000);   
        req.setBody(body);
        req.setHeader('Authorization', 'Bearer '+accessToken);  
        req.setHeader('content-type', 'application/json');  
        req.setHeader('Content-length', String.valueOf(body.length()));
        Http http = new Http();  
        HttpResponse res;
        try {
            res = http.send(req);
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        } 
        String responseStr = res.getBody();
        System.debug('responseStr--> '+ responseStr);
        
        if(responseStr.contains('Invalid Credentials')){
            return GET_ACCESS_TOKEN_FROM_REFRESH_TOKEN;
        }else{
            Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(responseStr);
            System.debug('responseMap--> '+responseMap);
            String ParentfldrId = (String)responseMap.get('id');
            System.debug('parentFldrId --> '+ParentfldrId);
            List<Account> accData = [Select Id,Name,FolderGDrive__c from Account where id =: curntId];
            System.debug('accData ---'+accData);
            for(Account acc : accData){
                if(acc != NULL){
                    acc.FolderGDrive__c = ParentfldrId;
                }
            }
            update accData;
        }
        return null;
    }
    
    public static String createSubFolder(String accessToken,String ChildfolderName,String oppId){
        System.debug('inside createSubFolder');
        String folderId;
        String accntId;
        List<Opportunity> oppData = [Select Id,AccountId,Name,FolderGDrive__c from Opportunity where id =: oppId];
        for(Opportunity opp : oppData ){
            accntId = opp.AccountId;
        }
        System.debug('rtrvd accnt id from opp'+accntId);
        List<Account> accData = [Select Id,Name,FolderGDrive__c from Account where id =: accntId];
        System.debug('acc data in subfolder mthd'+accData);
        for(Account acc : accData){
            if(acc != NULL){
                folderId = acc.FolderGDrive__c; 
            }     
        }
        System.debug('folderId----'+folderId);
        //String ParentFolderId = accData.Name;
        GoogleDrive__c CS = GoogleDrive__c.getInstance();
        //String accessToken = CS.Access_token__c;
        //System.debug('prntfldr in create subfldr'+ParentFolderId);
        HttpRequest req = new HttpRequest();   
        req.setMethod('POST');     
        req.setEndpoint('https://www.googleapis.com/drive/v2/files');   
        req.setHeader('Authorization', 'Bearer '+accessToken);   
        req.setHeader('content-type', 'application/json');   
        String body = '{"title":"'+ChildfolderName+'","mimeType":"application/vnd.google-apps.folder","parents": [{"kind": "drive#file","id": "'+folderId+'"}]}';  
        req.setTimeout(60*1000);   
        req.setBody(body);  
        Http http = new Http();  
        HttpResponse res;    
        try {
            res = http.send(req);
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
        String responseStr = res.getBody();
        System.debug('responseStr--> '+ responseStr);
        
        if(responseStr.contains('Invalid Credentials')){
            return GET_ACCESS_TOKEN_FROM_REFRESH_TOKEN;
        }else{
            Map<String, Object> jsn = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            System.debug('jsn'+jsn);
            String ParentfldrId = (String)jsn.get('id');
            System.debug('rtrvd data of opp----'+oppData);
            for(Opportunity opp : oppData){
                if(opp != NULL){
                    opp.FolderGDrive__c = ParentfldrId; 
                }               
            }
            update oppData;
            System.debug('updated data of opp---'+oppData);
        }
        System.debug('resp==='+ res.getBody());
        return '';
    }
}