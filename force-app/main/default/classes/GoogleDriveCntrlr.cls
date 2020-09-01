public class GoogleDriveCntrlr { 
    GoogleDriveCntrlrHelper obj = new GoogleDriveCntrlrHelper();
   
    public String accessToken;
    public String FolderName;  
    public String refresh_token;    
    public String code ;  
    public string key ;  
    public string secret ;  
    public string redirect_uri ;  
    GoogleDrive__c googleCusSetting = new GoogleDrive__c();  
    
    public void saveToken(){  
        System.debug('inside SaveToken method');
        getToken() ; 
    }  
    
    public PageReference init(){ 
        //Authenticating  
        System.debug('inside init');
        googleCusSetting = [Select id,Client_Id__c,Client_secret__c,Refresh_Token__c,Access_token__c,GoogleAccountDomain__c,Redirect_Url__c from GoogleDrive__c limit 1];  
        if(googleCusSetting != NULL){
        	key = googleCusSetting.Client_Id__c; 
        	secret = googleCusSetting.Client_secret__c;  
        	redirect_uri = googleCusSetting.Redirect_Url__c;     
        }
         
        code = ApexPages.currentPage().getParameters().get('code') ;  
        
        //Get the access token once we have code  
        PageReference pg;  
        if(code == '' || code == null){  
            pg = new PageReference(GoogleDriveAuthUri (key , redirect_uri)) ;  
        }
        return pg ;  
    }  
    
    public String GoogleDriveAuthUri(String Clientkey,String redirect_uri)  {  
        System.debug('Inside GoogleDriveAuthUri'+Clientkey+'redirectURi'+redirect_uri); 
        String key = EncodingUtil.urlEncode(Clientkey,'UTF-8');  
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');  
        String authuri = '';  
        authuri = 'https://accounts.google.com/o/oauth2/auth?'+  
            'client_id='+key+  
            '&response_type=code'+  
            '&scope=https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/drive.appdata https://www.googleapis.com/auth/drive.file'+  
            '&redirect_uri='+uri+  
            '&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome&'+  
            '&login_hint=jsmith@example.com&'+  
            'access_type=offline'; 
        return authuri;  
    }  
    
    public String getAccessTokenFromRefreshToken(String key, String secret, String refresh_token){
        System.debug('----------getAccessTokenFromRefreshToken----------');
        if(refresh_token != null && refresh_token != ''){
            HttpRequest req = new HttpRequest();  
            req.setMethod('POST');  
            req.setEndpoint('https://accounts.google.com/o/oauth2/token');  
            req.setHeader('content-type', 'application/x-www-form-urlencoded');  
            String messageBody = '&client_id='+key+
                '&client_secret='+secret+
                '&grant_type=refresh_token' +
                '&refresh_token=' + refresh_token;
            req.setBody(messageBody);  
            //req.setTimeout(60*1000);  
            Http h = new Http();  
            
            HttpResponse res = h.send(req);  
            String resp = res.getBody(); 
            System.debug('resp ==> '+resp);
            if(resp.containsIgnoreCase('error')){
                return 'ERROR';
            }else{
                Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(resp);
                System.debug('res.getBody() == ' + JSON.deserializeUntyped(resp));
                String access_token =  String.valueOf(responseMap.get('access_token'));
                
                return access_token;
            }            
        }
        return 'ERROR';
    }
    
    public void getToken(){  
        System.debug('inside getToken method');
        //Getting access token from google  
        HttpRequest req = new HttpRequest();  
        req.setMethod('POST');  
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');  
        req.setHeader('content-type', 'application/x-www-form-urlencoded');  
        String messageBody = 'code='+code+'&client_id='+key+'&client_secret='+secret+'&redirect_uri='+redirect_uri+'&grant_type=authorization_code';  
        req.setHeader('Content-length', String.valueOf(messageBody.length()));  
        req.setBody(messageBody);  
        //req.setTimeout(60*1000);  
        Http h = new Http();  
        String resp;  
        HttpResponse res = h.send(req);  
        resp = res.getBody();  
        if(res.getBody() != null && res.getStatusCode()==200){  
            //You can parse the response to get the Access token and Refresh token  
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());  
            System.debug('---Response data------'+results);
            //Access Token   
            
            if(results.get('access_token') != null){ 
                accessToken=string.valueOf(results.get('access_token'));  
                System.debug('access token'+accessToken);
                googleCusSetting.Access_token__c = accessToken;  
                update googleCusSetting;
                System.debug('googleCustom Setting Data in access token'+googleCusSetting);
                //  }else if(results.get('access_token').contains('invalid_access_token') || results.get('access_token').contains('access token is malformed')){           
            }
            if(results.get('refresh_token') != null){                 
                refresh_token = string.valueOf(results.get('refresh_token'));  
                System.debug('refreshToken if'+refresh_token);
                googleCusSetting.Refresh_Token__c = refresh_token;  
                update googleCusSetting;
                System.debug('googleCustom Setting Data in refresh token'+googleCusSetting);
            }  
        }
    }
}