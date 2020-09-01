public class GoogleDriveController
{
    public String accessTkn;
    private String code ;
    private string key = '217480542790-gm36ghbfu4l2g69en30a44kbvau5edi7.apps.googleusercontent.com';
    private string secret = 'fSE-umYtF-1KcNeVn0Wfhwcr' ;
    private string redirect_uri = 'https://lightdevlopment-dev-ed--c.ap4.visual.force.com/apex/GoogleDriveVFP' ;
    public List<GoogleDriveControllerHelper.Files> fldrsdata{get;set;}
    public List<GoogleDriveControllerHelper.Files> filesdata{get;set;}
    public List<GoogleDriveControllerHelper.brdCrumbWrapper> brdcrmbdata{get;set;}
   
    public String idtoDlt {get;set;}
    public String idtoDwnld {get;set;}
    public String filetype {get;set;}
    public String filename {get;set;}
    public blob file {get;set;}
    public boolean isVisible{get;set;}
    public String fldrId {get;set;}
    public String fldrName {get;set;}
    public Integer Index {get;set;}
    public boolean flag {get;set;}
    
    GoogleDriveControllerHelper obj = new GoogleDriveControllerHelper();
    
      // public GoogleDriveControllerHelper JSON2Apexfiles{get;set;}
    //public GoogleDriveControllerHelper.JSON2Apex JSON2Apexfolders{get;set;}
    // public GoogleDriveControllerHelper.JSON2Apex JSON2ApexCrtfiles{get;set;}
  
    public GoogleDriveController()
    {
        System.debug('in constructor');    
        obj = new GoogleDriveControllerHelper();
        code = ApexPages.currentPage().getParameters().get('code') ;
        System.debug('code'+code);
        if(code != '' && code != null)
        {
            AccessToken();
        }
    }
    
    public PageReference DriveAuth()
    {
        System.debug('inside PageRefrence mthd');
        //Authenticating
        PageReference pg = new PageReference(GoogleDriveAuthUri (key , redirect_uri));
        System.debug('pg'+pg);
        return pg ;       
    }
    
    public String GoogleDriveAuthUri(String Clientkey,String redirect_uri)
    {
        System.debug('in GoogleDriveAuthUri method');
        String key = EncodingUtil.urlEncode(Clientkey,'UTF-8');
        System.debug('key'+key);
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        System.debug('uri'+uri);
        String authuri = '';
        authuri = 'https://accounts.google.com/o/oauth2/auth?'+
            'client_id='+key+
            '&response_type=code'+
            '&scope=https://www.googleapis.com/auth/drive'+
            '&redirect_uri='+uri+
            '&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome&'+
            '&login_hint=jsmith@example.com&'+
            'access_type=offline';
        System.debug('authuri'+authuri);
        return authuri;
    }
    
    public void callingDlt(){
        System.debug('idtoDlt'+idtoDlt);
        obj.dltData(accessTkn,idtoDlt);
        obj.FileID(accessTkn,fldrId,fldrName,Index);
        fldrsdata = obj.Fldrs;
        filesdata = obj.filesonly;
    }
    
    public PageReference callingDwnld(){
        System.debug('idtoDwnld'+idtoDwnld);
        obj.downloadFile(accessTkn,idtoDwnld);
        PageReference curPage = new PageReference('https://drive.google.com/uc?id='+idtoDwnld+'&export=download');
		curPage.setRedirect(true);
		return curPage;     
    }
    
    /*public void callingUpld(){
        try{
            System.debug('inside upload mthod');
            System.debug('fileType'+filetype);
            System.debug('filename'+filename);
            System.debug('file'+file);
            obj.upldFile(accessTkn,filetype,filename,file);
            obj.FileID(accessTkn,fldrId,fldrName,Index);
            fldrsdata = obj.Fldrs;
            filesdata = obj.filesonly;
        }catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a file to upload');
			ApexPages.addMessage(myMsg);
        }
    }*/
    
    public PageReference callbrdcrumb(){
        obj.FileID(accessTkn,fldrId,fldrName,Index);
       		System.debug('brdcrmbdataaaaaa     ' +brdcrmbdata);
        	brdcrmbdata =obj.brdCrumbName;
            fldrsdata = obj.Fldrs;
            filesdata = obj.filesonly;    	
        return null;
    }
    
    
    public void AccessToken()
    {
        System.debug('in AccessToken mthd');
        //Getting access token from google
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'code='+code+'&client_id='+key+'&client_secret='+secret+'&redirect_uri='+redirect_uri+'&grant_type=authorization_code';
        System.debug('messageBody'+messageBody);
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);
        
        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        System.debug('respRprsntn'+resp);
        Map<String, Object> m =(Map<String, Object>)JSON.deserializeUntyped(resp);
        System.debug('mmm'+m);
        accessTkn = String.valueOf(m.get('access_token'));
        isVisible =true;
        System.debug(' You can parse the response to get the access token : ' + accessTkn);
        
        obj.FileID(accessTkn,fldrId,fldrName,Index);
        fldrsdata = obj.Fldrs;
        filesdata = obj.filesonly;
        System.debug(obj.Fldrs);
        
        //obj.downloadFile(accessTkn);
        //idtoDlt = obj.slctdId;
        //JSON2Apexfolders = obj.Folder(accessTkn);
        //JSON2Apexfiles = GoogleDriveControllerHelper.FileID(accessTkn);
        //JSON2Apexfolders = GoogleDriveControllerHelper.Folders(accessTkn);
        //JSON2ApexCrtfiles = GoogleDriveControllerHelper.CrtFiles(accessTkn);
    }
}