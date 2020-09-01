public with sharing class JsFileUpload_AcsToken {
    
    @AuraEnabled(Cacheable=true)
    public Static String accessToken(){
        //Blob payloadBlob = EncodingUtil.base64Decode(base64Data);
        //String payload = payloadBlob.toString();
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
        System.debug('aces token-----'+acsToken);
        return acsToken;
        /*String sessionId = UserInfo.getSessionId();
        System.debug('sessionId'+sessionId);
        return sessionId;*/
    }
}