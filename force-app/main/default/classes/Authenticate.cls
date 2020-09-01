public class Authenticate {
    
    public class WrapperData{
        @AuraEnabled
        public String clientId;
        @AuraEnabled
        public String clientSecret;
        
        public WrapperData(String clientId,String clientSecret){
            this.clientId = clientId;
            this.clientSecret = clientSecret;
        }
    }
     @AuraEnabled
     public Static List<WrapperData> CallApi(){
         system.debug('CallApi() called');
        List<WrapperData> lstWrpr = new List<WrapperData>(); 
        string clientId='3MVG9YDQS5WtC11pCLE4N3VQDCoiwqWv68CrmoBBdj4QdQOvv1wYOZR65b3_WdVLexqJfeSaXwRr7UrmV8Eey';
        String clientSecret='981119BA162601016F9BAF8D0B13FDC59DB30C6854D384B2D4259080C275B086'; 
        lstWrpr.add(new WrapperData('3MVG9YDQS5WtC11pCLE4N3VQDCoiwqWv68CrmoBBdj4QdQOvv1wYOZR65b3_WdVLexqJfeSaXwRr7UrmV8Eey','981119BA162601016F9BAF8D0B13FDC59DB30C6854D384B2D4259080C275B086'));
        system.debug('lstWrpr------'+lstWrpr);
        return lstWrpr;
        //return new pagereference('https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=' + clientId + '&redirect_uri=https://alokdevorg-developer-edition.ap15.force.com/CallBackURL&prompt=login&display=popup&state=state');
    }
}