public without sharing class CallBackURLController{
    public class wrapperOfTknLink{
        @AuraEnabled
        public String acsToken;
        @AuraEnabled
        public String link;

        public wrapperOfTknLink(String acsToken,String link){
            this.acsToken = acsToken;
            this.link = link;
        }
    }
    
    @AuraEnabled  
    public static List<wrapperOfTknLink> AccessToken(String AuthCode){
        List<wrapperOfTknLink> wrt = new List<wrapperOfTknLink>();
        string bodyCode;
		string bodyInfo;
       	string cd;
      	string hd;
        list<contact> lstCon;
        String vrsn='46.0';
        //string Accesscode=ApexPages.currentPage().getParameters().get('code');
        //Accesscode = Accesscode.replace('=','%3D').trim();
        string clientId='3MVG9YDQS5WtC11pCLE4N3VQDCoiwqWv68CrmoBBdj4QdQOvv1wYOZR65b3_WdVLexqJfeSaXwRr7UrmV8Eey';
        String clientSecret='981119BA162601016F9BAF8D0B13FDC59DB30C6854D384B2D4259080C275B086';
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        system.debug('--baseurl--'+baseUrl);
        String redireUri= 'https://jhaalok-developer-edition.ap4.force.com/MetaOrg/RetrieveXMLCmpPage';
        
        string loginUri='https://login.salesforce.com';
        string ContentType = 'application/json';
        
        //Get Access Token
        HttpRequest req = new HttpRequest();  
        req.setMethod('POST');
        string reqbody='grant_type=authorization_code' +
            '&client_id=' + clientId +
            '&client_secret=' + clientSecret +
            '&code=' + AuthCode +
            '&redirect_uri=' + redireUri;
        req.setEndpoint(loginUri+'/services/oauth2/token?'+reqbody);
        Http http = new Http();  
        HTTPResponse res = http.send(req);
        bodyCode=res.getBody();
        Map<String, object> mapReqBody=(Map<String, object>)JSON.deserializeUntyped(res.getBody());
        system.debug('------mapReqBody-------'+mapReqBody);
        String linkToFetch = string.valueOf(mapReqBody.get('id'));
        string header=string.valueOf(mapReqBody.get('token_type'))+' '+string.valueOf(mapReqBody.get('access_token'));
        string acsToken = string.valueOf(mapReqBody.get('access_token'));
        system.debug('-------header---------'+header);
        hd=header;        
        
        wrt.add(new wrapperOfTknLink(acsToken,linkToFetch));

        // Get User Info
        HttpRequest reqInfo = new HttpRequest();  
        reqInfo.setMethod('POST');
        reqInfo.setEndpoint(loginUri+'/services/oauth2/userinfo');
        reqInfo.setHeader('Content-Type','application/json');
        reqInfo.setHeader('Authorization', header);
        Http httpInfo = new Http();  
        HTTPResponse resInfo = httpInfo.send(reqInfo);
        bodyInfo = resInfo.getBody();
        system.debug('----bodyInfo-----'+bodyInfo);
        Map<String, object> mapReqInfoBody=(Map<String, object>)JSON.deserializeUntyped(resInfo.getBody());       
        system.debug('-----mapReqInfoBody-------'+mapReqInfoBody);   
        system.debug('#########wrapper data accs token and link'+wrt);
        return wrt;
    }
    
    private static final Integer METADATA_API_VERSION = 
        Integer.valueOf(new MetadataService.MetadataPort().endpoint_x.substringAfterLast('/'));
    
    public class OptionVal{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;       
        public OptionVal(String label,String value){
            this.label = label;
            this.value = value;
        }
    }
    public static List<OptionVal> MetaDataTypes;
    public static String MetaDataType;  
    public static List<OptionVal> MetaDataItems;
    public static String MetaDataFolder;
    public static String MetaDataItem;
    public static String MetadataFileName;
    public static String MetadataFileData;
    public static MetadataService.AsyncResult AsyncResult;
    public static String MetaDataRetrieveZip;
    public static List<MetadataFile> MetadataFiles;
    
    @AuraEnabled
    public static String listMetadataTypes(String AcessTkn,String endPointLink){
        String endPntLnk = endPointLink;
        // List available Metadata Types via the 'describeMetadata' API call
        MetadataService.MetadataPort service = createService(AcessTkn);                 
        MetadataService.DescribeMetadataResult describeResult = service.describeMetadata(METADATA_API_VERSION);
        List<String> metadataTypeNames = new List<String>();
        for(MetadataService.DescribeMetadataObject metadataObject : describeResult.metadataObjects)
        {
            metadataTypeNames.add(metadataObject.xmlName);
            if(metadataObject.childXmlNames!=null)
                for(String childXmlName : metadataObject.childXmlNames)
                if(childXmlName!=null)
                metadataTypeNames.add(childXmlName);
        }   
        
        // Sort Metadata Types
        metadataTypeNames.sort();
        MetaDataTypes = new List<OptionVal>();              
        for(String metadataTypeName : metadataTypeNames)
            MetaDataTypes.add(new OptionVal(metadataTypeName, metadataTypeName));
        system.debug('MetaDataTypes'+MetaDataTypes);     
        String metaDataWrap = Json.serialize(MetaDataTypes); 
        //listMetadataItems(AcessTkn,endPointLink);
        return metaDataWrap; 
    }
    
    @AuraEnabled
    public static String listMetadataItems(String slctdVal,String AcessTkn,String endPointLink){
        system.debug('inside listMetadataItems()');
        MetaDataFolder = '';
        system.debug('endPointLink-------'+endPointLink);
        system.debug('--------slectedValue-------'+slctdVal);
        system.debug('------AccessToken-------'+AcessTkn);
        MetaDataType = slctdVal;
        system.debug('------MetaDataType------'+MetaDataType);
        // List Metadata items for the selected Metadata Type
        MetaDataItems = new List<OptionVal>();      
        MetadataService.MetadataPort service = createService(AcessTkn);
        system.debug('service----'+service);             
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();        
        MetadataService.ListMetadataQuery queryLayout = new MetadataService.ListMetadataQuery();
        system.debug('++++++++++++++++++++++queryLayout-------------'+queryLayout);
        system.debug('++++++++++++++++++++++MetaDataFolder-------------'+MetaDataFolder);
       
        system.debug('++++++++++++++++++++++slctdVal-------------'+slctdVal);
        system.debug('++++++++MetaDataType--------'+MetaDataType);
        if(MetaDataFolder!=null && MetaDataFolder.length()>0)
			queryLayout.folder = MetaDataFolder;
		queryLayout.type_x = MetaDataType;
		queries.add(queryLayout);  
        system.debug('queries---'+queries);
        system.debug('METADATA_API_VERSION---'+METADATA_API_VERSION);
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 46);


        List<String> folderNames = new List<String>();
        for(MetadataService.FileProperties fileProperty : fileProperties)
        folderNames.add(fileProperty.fileName.replace('documents/', ''));
        system.debug('-----folderNames-----'+folderNames);

       /* List<MetadataService.DocumentFolder> folder = 
        (List<MetadataService.DocumentFolder>)service.readMetadata('DocumentFolder', folderNames).getRecords();
        */
        system.debug('fileProperties'+fileProperties);
        // Sort
        List<String> fullNames = new List<String>();
        if(fileProperties!=null){
            for(MetadataService.FileProperties fileProperty : fileProperties)
                fullNames.add(fileProperty.fullName);
            fullNames.sort();
            for(String fullName : fullNames)
                MetaDataItems.add(new OptionVal(fullName,EncodingUtil.urlDecode(fullName, 'UTF-8')));
        }
        String metaDataItemWrap = Json.serialize(MetaDataItems); 
        system.debug('metaDataItemWrap------'+metaDataItemWrap);
        return metaDataItemWrap; 
    }
    
    @AuraEnabled
    public static String retrieveMetadataItem(String AcessTkn){     
         system.debug('inside retrieveMetadataItem(String AcessTkn)');  
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Retrieving metadata...'));
        system.debug('AcessTkn-------'+AcessTkn);
        // Reset state from any previous requests
        MetaDataRetrieveZip = null;
        MetadataFiles = null;
        String sessionId = AcessTkn;
        system.debug('-----sessionId----'+sessionId);
        // Construct unmanaged package with list of desired components to retrieve in zip
        MetadataService.MetadataPort service = createService(AcessTkn);             
        MetadataService.RetrieveRequest retrieveRequest = new MetadataService.RetrieveRequest();
        retrieveRequest.apiVersion = METADATA_API_VERSION;
        system.debug(' retrieveRequest.apiVersion'+ retrieveRequest.apiVersion);
        retrieveRequest.packageNames = null;
        retrieveRequest.singlePackage = true;
        retrieveRequest.specificFiles = null;
        retrieveRequest.unpackaged = new MetadataService.Package_x();
        retrieveRequest.unpackaged.types = new List<MetadataService.PackageTypeMembers>();
        MetadataService.PackageTypeMembers packageType = new MetadataService.PackageTypeMembers();
        packageType.name = MetaDataType; 
        packageType.members = new String[] { MetadataFolder, MetaDataItem };
            retrieveRequest.unpackaged.types.add(packageType);
       
        string packageData = JSON.serialize(retrieveRequest.unpackaged.types);       
         AsyncResult = service.retrieve(retrieveRequest);  
         String rsltId = AsyncResult.Id; 
         system.debug('----AsyncResult Id-----'+AsyncResult.Id);
         system.debug('AsyncResult------------'+AsyncResult); 
        // checkAsyncRequest(sessionId,rsltId);    
        //system.debug('Package data'+packageData);    
        system.debug('-----rturnd rsltId ----'+rsltId);    
        return rsltId;    
    }
    
    @AuraEnabled
    public static String checkAsyncRequest(String AcessTkn,String AsyncRsltId){
        system.debug('in checkAsyncRequest()');
        system.debug('----ayncid'+AsyncRsltId);
        // Check the status of the retrieve request
        MetadataService.MetadataPort service = createService(AcessTkn);
        MetadataService.RetrieveResult retrieveResult = service.checkRetrieveStatus(AsyncRsltId, true);
        system.debug('retrieveResult------'+retrieveResult);
        if(retrieveResult.done){
            system.debug('in if');
            if(retrieveResult.status != 'Succeeded'){
                system.debug('in if error');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, retrieveResult.errorMessage));
                AsyncResult = null;             
            }
            else{
                system.debug('in extractor');
                // Place Base64 encoded zip data onto the page for the JSZip library to handle
                MetaDataRetrieveZip = retrieveResult.zipFile;
                //MetaDataFileName = retrieveResult.fileName;
                system.debug('--- MetaDataRetrieveZip---'+ MetaDataRetrieveZip);
                MetadataFiles = new List<MetadataFile>();
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Expanding...'));
                AsyncResult = null;
            }
        }
        system.debug('---lst MetaDataRetrieveZip---'+MetaDataRetrieveZip);
        return  MetaDataRetrieveZip;
    }
    
    @AuraEnabled
    public static String receiveMetadataZipFile(String AcessTkn){
        system.debug('----inside unzip method receiveMetadataZipFile()');
        // In this example the retrieved metadata is stored in viewstate in production cases you would probably use a custom object / attachment
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Expanding ' + MetaDataFileName + '...'));
        MetadataFile metaDataFile = new MetadataFile();
        system.debug('metaDataFile---'+metaDataFile);
        metaDataFile.fullName = MetaDataFileName;
        metaDataFile.content = MetaDataFileData;
        MetadataFiles.add(metaDataFile);
        system.debug('MetadataFiles-------'+MetadataFiles);
        return null;
    }
    
    @AuraEnabled
    public static String receiveComplete(){
        // Completed, cleared Base64 encoded zip data from viewstate
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Metadata retrieve completed'));
        MetaDataRetrieveZip = null;     
        return null;
    }
    
    @AuraEnabled
    public static MetadataService.MetadataPort createService(String sessionId){ 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = sessionId;
        service.endpoint_x = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/m/42.0';
        system.debug('service.endpoint_x----'+service.endpoint_x);
        system.debug('service.SessionHeader.sessionId'+ service.SessionHeader.sessionId);
        return service;     
    }   
    
    
    /**
* Simple container class for retrieve metadata file, may as well leverage the Metadata API class for this
**/
    public class MetadataFile extends MetadataService.MetadataWithContent{
        @AuraEnabled
        public String getFullname(){
            return fullName;
        }
        @AuraEnabled
        public String getContent(){
            return content;
        }
    }
}