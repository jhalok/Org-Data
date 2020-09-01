public class BulkApi {
    
    @AuraEnabled
    public Static List<String> getObjectName(){
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();     
        List<String> objNames = new List<String>();
        for(SObjectType f : gd){
            if(f.getDescribe().isUpdateable()){
                objNames.add(f.getDescribe().getName());
                objNames.sort();
            }
        }
        return objNames;
    }
    @AuraEnabled
    public Static WrapperData accessToken(String selectedObj,String fileName, String base64Data, String contentType){
        System.debug('selectedObj----'+selectedObj);
        System.debug('fileName-----'+fileName);
        System.debug('base64Data----'+base64Data);
         System.debug('contentType----'+contentType);
        
        Blob payloadBlob = EncodingUtil.base64Decode(base64Data);
        String payload = payloadBlob.toString();
        BulkApi__c acsTknDetails = new BulkApi__c();
        acsTknDetails = [Select Client_Id__c, Client_secret__c, Username__c, Password__c from BulkApi__c];  
        String reqbody = 'grant_type=password&client_id='+acsTknDetails.Client_Id__c+'&client_secret='+acsTknDetails.Client_secret__c+'&username='+acsTknDetails.Username__c+'&password='+acsTknDetails.Password__c;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        HttpResponse res = h.send(req);
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        String acsToken = (String)responseMap.get('access_token');
        return createJob(acsToken,selectedObj,payload);
    }
    @AuraEnabled
    public Static WrapperData createJob(String sessionId,String selectedObj,String payload){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://lightdevlopment-dev-ed.my.salesforce.com/services/data/v47.0/jobs/ingest');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + sessionId);
        req.setBody('{ "operation" : "insert", "object" : "'+selectedObj+'", "contentType" : "CSV", "lineEnding" : "CRLF" }');
        Http h = new Http();  
        HttpResponse res = h.send(req);
        Map<String, Object> responseMap = (Map<String, Object>)(JSON.deserializeUntyped(res.getBody()));
        String contentUrl = (String)responseMap.get('contentUrl');
        String jobId = (String)responseMap.get('id');
        if (res.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' + 
                         res.getStatusCode() + ' ' + res.getStatus());
        } else {
            System.debug(res.getBody());
        } 
        return insertData(contentUrl,jobId,sessionId,payload);
    }
    @AuraEnabled
    public Static WrapperData insertData(String contentUrl,String jobId,String sessionId,String payload){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://lightdevlopment-dev-ed.my.salesforce.com/'+contentUrl);
        req.setMethod('PUT');
        req.setHeader('Content-Type', 'text/csv');
        req.setHeader('Authorization', 'Bearer ' + sessionId);
        req.setBody(payload);
        Http h = new Http();  
        HttpResponse res = h.send(req);
        System.debug('The status code returned was not expected: ' + 
                     res.getStatusCode() + ' ' + res.getStatus());
        System.debug('jobId'+jobId);
        WrapperData wrpData = new WrapperData();
        wrpData.jobId = jobId;
        wrpData.accessToken = sessionId;
        System.debug('wrapper data'+wrpData);
        return wrpData;
    }
    @AuraEnabled
    public Static void changeJobStatus(String jobId,String sessionId){
        String typeOfjobId = jobId.substring(0,jobId.length()-3);
        System.debug('id trimd'+typeOfjobId);
        HttpRequest req = new HttpRequest();
        //req.setEndpoint('https://lightdevlopment-dev-ed.my.salesforce.com/services/data/v41.0/7506F00000QZkk9QAD/ingest/batches');
        //req.setEndpoint('https://lightdevlopment-dev-ed.my.salesforce.com/services/data/v47.0/jobs/ingest/'+typeOfjobId+'?_HttpMethod=PATCH');
        req.setEndpoint('https://lightdevlopment-dev-ed.my.salesforce.com/services/data/v41.0/jobs/ingest/'+jobId);      
        //String sessionId = UserInfo.getOrganizationId()+''+UserInfo.getSessionId().SubString(15);
        System.debug('sessionId'+sessionId);
        req.setBody('{"state" : "UploadComplete"}');
        req.setHeader('Authorization', 'Bearer ' + sessionId);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        Http h = new Http();  
        HttpResponse res = h.send(req);
        System.debug('status code: ' + 
                     res.getStatusCode() + ' ' + res.getStatus());
    }
    @AuraEnabled
    public Static String failedData(String jobId,String sessionId){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://lightdevlopment-dev-ed.my.salesforce.com/services/data/v47.0/jobs/ingest/'+jobId+'/failedResults');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + sessionId);
        Http h = new Http();  
        HttpResponse res = h.send(req);
        System.debug('The status code returned was not expected: ' + 
                     res.getStatusCode() + ' ' + res.getStatus());
        return res.getBody();
    }
    public class WrapperData{
        @AuraEnabled
        public String jobId;
        @AuraEnabled
        public String accessToken;
    }
}