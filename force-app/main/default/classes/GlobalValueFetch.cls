global with sharing class GlobalValueFetch {
    
    public static String getUserSessionId(){
        String sessionId = '';
        PageReference reportPage = Page.gettingSessionId;       
        String vfContent = reportPage.getContent().toString();
        System.debug('vfContent '+vfContent);
        // Find the position of Start_Of_Session_Id and End_Of_Session_Id
        Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
            endP = vfContent.indexOf('End_Of_Session_Id');
        // Get the Session Id
        sessionId = vfContent.substring(startP, endP);
        System.debug('sessionId '+sessionId);
        // Return Session Id
        return sessionId;
    }
    
    @AuraEnabled
    public static List<customValueWrapper> fetchPicklist(String MasterLabel) {
        System.debug('in fetch');
        String sessionId = getUserSessionId();
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + sessionId);
        req.setHeader('Content-Type', 'application/json');  
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v44.0/tooling/sobjects/GlobalValueSet/0Nt6F00000007LGSAY');   
       // req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v44.0/tooling/query?q=select+id+,+FullName+,+ManageableState+from+globalValueSet+where+MasterLabel='+'\'' + MasterLabel + '\'' );
        //req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v44.0/tooling/query?q=select+id+from+globalValueSet+where+id='+'0Nt6F00000007LGSAY');
        //String targetString = '/services/data/v44.0/tooling/query?q=select+id+from+globalValueSet+where+MasterLabel='+MasterLabel;
        //String encodedString = EncodingUtil.urlEncode(targetString,'UTF-8');
        req.setMethod('GET');
        Http httpreq = new Http();
        System.debug( req.getBody() );
        HttpResponse res  = httpreq.send(req);
        System.debug(res.getBody());
        ResponseWrapper responseWrap = new ResponseWrapper();
        responseWrap = (ResponseWrapper)JSON.deserialize(res.getBody(), ResponseWrapper.class);
        System.debug(responseWrap);
        //return JSON.serialize(res.getBody());
        System.debug(responseWrap.Metadata.customValue.size());
        System.debug(responseWrap.Metadata.customValue);
        return responseWrap.Metadata.customValue;
    }
    
    public class ResponseWrapper{
        @AuraEnabled 
        public metaDataWrapper Metadata;
    }
    public class metaDataWrapper{
        @AuraEnabled 
        public List<customValueWrapper> customValue; 
    }
    public class customValueWrapper{
        @AuraEnabled 
        public String valueName; 
    }
}