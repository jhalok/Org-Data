public class GoogleDriveControllerHelper {
    
    
    public List<Files> Fldrs {get;set;}
    public List<Files> filesonly {get;set;}  
    public JSON2Apex jsn {get;set;}
    public List<brdCrumbWrapper> brdCrumbName {get;set;}
    public boolean flag =true;
    
    public GoogleDriveControllerHelper(){
        Fldrs = new List<Files>();
        filesonly = new List<Files>();
        brdCrumbName = new List<brdCrumbWrapper>();
    }
    
   public class brdCrumbWrapper{
        public String id {get;set;}
        public String name {get;set;}
    }
    
    public class JSON2Apex {
        //on succesfull rspns for files
        public String kind;
        public String nextPageToken;
        public Boolean incompleteSearch;
        public List<Files> files {get;set;}  
    } 
    public class Files {
        public String kind {get;set;}
        public String id {get;set;}
        public String name {get;set;}
        public String mimeType {get;set;}
    }
    
    public PageReference FileID(String AcsToken,String fldrId,String fldrName,Integer Index) {
        System.debug('Index'+Index);
        brdCrumbWrapper bcw = new brdCrumbWrapper();
        bcw.id = fldrId;
        bcw.name = fldrName;
        brdCrumbName.add(bcw);
        System.debug('bcwwwwwwwwwwww'+bcw);
        for(Integer i=Index; i <= brdCrumbName.size(); i++ ){
            System.debug('Index           '+Index);
            try{
                brdCrumbName.remove(Index+1);
            }
            catch(Exception ex){
                
            }
        }
        System.debug('brdCrumbName        '+brdCrumbName);
        
        String accessTkn =AcsToken;
        String foldrid =fldrId;
        System.debug('in FileID mthd');
        System.debug('fldrIddddddddddddddddddddddddddddddddd'+foldrid);
        HttpRequest httpReq = new HttpRequest();                                               
        if(foldrid != null && foldrid != ''){
            httpReq.setEndpoint('https://www.googleapis.com/drive/v3/files?q=%27'+foldrid+'%27%20in%20parents%20and%20trashed=false&orderBy=folder');
        }else{
            httpReq.setEndpoint('https://www.googleapis.com/drive/v3/files?corpora=user&includeTeamDriveItems=false&q='+EncodingUtil.urlEncode('\'root\' in parents', 'utf-8'));
        }
        httpReq.setHeader('content-type','application/x-www-form-urlencoded');
        httpReq.setHeader('Authorization', 'Bearer ' +AcsToken);
        httpReq.setMethod('GET');
        Http http = new Http();         
        String resp;
        HttpResponse httpRes = http.send( httpReq );
        resp = httpRes.getBody();
        // System.debug('resp'+resp);
        
        Fldrs = new List<Files>();
        filesonly = new List<Files>();
        
        jsn = (JSON2Apex) JSON.deserialize(resp, JSON2Apex.class);
        System.debug('jsn'+jsn);
        System.debug('list'+jsn.files);
        
        for(Files fl:jsn.files){
            if(fl.mimeType.equals('application/vnd.google-apps.folder')){
                Fldrs.add(fl);
            }else{
                filesonly.add(fl);
            }
        }
        System.debug('files----------only'+filesonly);
        System.debug('folderssssss----------only'+Fldrs);
        return null;
    }
    
    public void dltData(String AcsToken,String idtoDlt){
        System.debug('in delete file method');
        HttpRequest httpReq = new HttpRequest();                                               
        httpReq.setEndpoint( 'https://www.googleapis.com/drive/v3/files/'+idtoDlt); 
        httpReq.setHeader('content-type','application/x-www-form-urlencoded');
        httpReq.setHeader('Authorization', 'Bearer ' +AcsToken);
        httpReq.setMethod('DELETE');
        Http http = new Http();         
        String resp;
        HttpResponse httpRes = http.send( httpReq );
        resp = httpRes.getBody();
        //System.debug('resp'+resp);
        // System.debug('idtoDltttttttttt'+idtoDlt);
    }
    
    public void downloadFile(String AcsToken,String idtoDwnld){
        System.debug('in downloadFile mthd');
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('GET');//https://www.googleapis.com/drive/v3/files/'+idtoDwnld+'?alt=media   'https://www.googleapis.com/drive/v3/files/'+idtoDwnld
        httpReq.setEndpoint('https://drive.google.com/uc?id='+idtoDwnld+'&export=download');
        httpReq.setHeader('content-type', 'application/vnd.google-apps.document');
        httpReq.setHeader('Authorization','Bearer '+AcsToken);
        httpReq.setTimeout(60*1000);
        String resp;
        HttpResponse httpRes = http.send(httpReq);
        resp = httpRes.getBody();
        System.debug('resp'+resp);
    }
    
    public void upldFile(String AcsToken,String filetype,String filename,blob file){
        System.debug('in upldFile mthd');
        /*String boundary = '--9889464542212';
        String delimiter = '\r\n--' + boundary + '\r\n';
        String close_delim = '\r\n--' + boundary + '--';
        String bodyEncoded = EncodingUtil.base64Encode(file);
        String body = delimiter + 'Content-Type: application/json\r\n\r\n' + 
            '{ "title" : "' + filename + '",' + ' "mimeType" : "' + filetype + '" }' + 
            delimiter + 'Content-Type: ' + filetype + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');
        req.setHeader('Authorization', 'Bearer ' + AcsToken);
        req.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
        req.setHeader('Content-length', String.valueOf(body.length()));
        req.setBody(body);
        req.setMethod('POST');
        req.setTimeout(60 * 1000);
        HttpResponse resp = http.send(req);
        System.debug('upload response'+resp);
        file = null;
        filetype = '';
        filename = '';*/ 
       
       
        String boundary = '----------9889464542212';
        String delimiter = '\r\n--' + boundary + '\r\n';
        String close_delim = '\r\n--' + boundary + '--';
        String bodyEncoded = EncodingUtil.base64Encode(file);
        String body = delimiter + 'Content-Type: application/json\r\n\r\n' + 
            '{ "title" : "' + filename + '",' + ' "mimeType" : "' + filetype + '" }' 
            + delimiter + 'Content-Type: ' + filetype + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');
        req.setHeader('Authorization', 'Bearer ' + AcsToken);
        req.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
        req.setHeader('Content-length', String.valueOf(body.length()));
        system.debug('body.length()'+body.length());
        system.debug('body>>'+body);
        req.setBody(body);
        req.setMethod('POST');
        req.setTimeout(60 * 1000);
        HttpResponse resp = http.send(req);
        system.debug('resp of upld'+resp);
        file = null;
        filetype = '';
        filename = '';
        
      /* List<ContentVersion> cvFile = [SELECT VersionData,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: '0016F00003d6xoJ'];
       Blob myBlob = cvFile[0].VersionData;
       String url = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=media';
       string authorizationHeader = 'Bearer ' + AcsToken; 
       Integer contentSize = myBlob.size();
       HttpRequest req = new HttpRequest();
       req.setheader('Authorization',authorizationHeader);
       req.setheader('Content-Length',String.valueOf(contentSize));
       req.setheader('Content-Type','image/'+cvFile[0].FileType);
       req.setMethod('POST'); 
       req.setEndpoint(url); 
       req.setBodyAsBlob(myBlob); 
       Http h = new Http(); 
      
       Httpresponse resp = h.send(req);
       System.debug('response-------'+resp); */
    }
    
    @Future(callout = true)
    public static void createFolder(String accessToken,String FolderName){ //Id accountId,String FolderName,String accessToken
        System.debug('inside createFolder');
        System.debug('inside'+accessToken);
        System.debug('FolderName'+FolderName);
        HttpRequest req = new HttpRequest();   
        req.setMethod('POST');  
        req.setEndpoint('https://www.googleapis.com/drive/v3/files');   
        req.setHeader('Authorization', 'Bearer '+accessToken);  
        req.setHeader('content-type', 'application/json');  
        String body = '{"name" : "'+FolderName+'","mimeType" : "application/vnd.google-apps.folder"}';  
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
    	GoogleDrive__c googleCus = new GoogleDrive__c();  
        googleCus = [Select id,Client_Id__c,FolderId__c,Client_secret__c,Refresh_Token__c,Access_token__c,GoogleAccountDomain__c,Redirect_Url__c from GoogleDrive__c limit 1];  

        Map<String, Object> jsn = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        System.debug('jsn'+jsn);
        String ParentfldrId = (String)jsn.get('id');
        System.debug('parentFldrId'+ParentfldrId);
        googleCus.FolderId__c = ParentfldrId;
        update googleCus;
        //createSubFolder(parentFldrId);
    }
	
    @Future(callout = true)    
    public static void createSubFolder(String ParentFolderId,String ChildfolderName){
        System.debug('inside createSubFolder');
        //Id ParentFolderId ='1nqkzZaQ6kac9EbsLvHsXLAEy1JdRO-we';
        GoogleDrive__c CS = GoogleDrive__c.getInstance();
        String accessToken = CS.Access_token__c;
        System.debug('prntfldr in create subfldr'+ParentFolderId);
        HttpRequest req = new HttpRequest();   
        req.setMethod('POST');   
        
        req.setEndpoint('https://www.googleapis.com/drive/v2/files');   
        
        req.setHeader('Authorization', 'Bearer '+accessToken);   
        
        req.setHeader('content-type', 'application/json');   
        String body = '{"title":"'+ChildfolderName+'","mimeType":"application/vnd.google-apps.folder","parents": [{"kind": "drive#file","id": "'+ParentFolderId+'"}]}';  
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
        System.debug('=====the resp==='+ res.getBody());  
    }
}