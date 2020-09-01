public class DropBoxController {
    //Fetched from URL
    String code ;
    
    public DropboxController()
    {
        code = ApexPages.currentPage().getParameters().get('code') ;
        //Get the access token once we have code
        if(code != '' && code != null)
        {
            AccessToken() ;
        }
    }
    
    public PageReference DropAuth()
    {
        //Authenticating
        PageReference pg = new PageReference('https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id=chgeumd6ir77ujv&redirect_uri=https://lightdevlopment-dev-ed--c.ap4.visual.force.com/apex/DropBoxVFP') ;
        return pg ;
    }
    
    public void AccessToken()
    {
        //Getting access token from dropbox
        String tokenuri = 'https://api.dropbox.com/1/oauth2/token?grant_type=authorization_code&code='+code+'&redirect_uri=https://lightdevlopment-dev-ed--c.ap4.visual.force.com/apex/DropBoxVFP'; 
        HttpRequest req = new HttpRequest();
        req.setEndpoint(tokenuri);
        req.setMethod('POST');
        req.setTimeout(60*1000);
          
        Blob headerValue = Blob.valueOf('chgeumd6ir77ujv' + ':' + 'dpxny7voqwt7a8u');
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        
        System.debug(' You can parse the response to get the access token ::: ' + resp);
   }
}