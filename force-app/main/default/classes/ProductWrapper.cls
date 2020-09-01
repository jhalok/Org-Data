public class ProductWrapper {
    
    public class WrapperClass{
        public LeadClass leadClassObj;
        public List<ProductIntrests> productIntrestList;
    }
    
    public class LeadClass{
        public String name;
        public String mobile;
    }
    
    public class ProductIntrests {
        public String productName;
        public List<Source> sourceList;
    }
    
    public class Source {
        public String sourceListName;
        public String subsourceList;
    }
    
    public static void jsonString(String JsonData){
        ProductWrapper pw = new ProductWrapper();
        List<WrapperClass> wprObj = (List<WrapperClass>)JSON.deserialize(JsonData, List<WrapperClass>.class);
        
        Set<String> mobileNumberSet = new Set<String>();
        Set<Id> productInterestIdSet = new Set<Id>();
        List<SourceTracker__c> sourceTrackList = new List<SourceTracker__c>();
        List<Lead> leadDataList = new List<Lead>();
        Map<String,List<Map<String,List<String>>>> wrapperDataMap = new Map<String,List<Map<String,List<String>>>>(); 
        
        for(WrapperClass leadObj : wprObj){
            mobileNumberSet.add(leadObj.leadClassObj.mobile);
        }
        if(mobileNumberSet != null && mobileNumberSet.size()>0){
            leadDataList = [Select MobilePhone,(Select Id,ProductName__c From ProductIntrests__r) From Lead Where MobilePhone In: mobileNumberSet];
            for(Lead leadData : leadDataList){
                for(ProductIntrest__c productInterestData : leadData.ProductIntrests__r)
                    productInterestIdSet.add(productInterestData.Id);
            }   
            if(productInterestIdSet != null && productInterestIdSet.size()>0)
                sourceTrackList = [Select Source__c From SourceTracker__c Where RltdProductIntrest__c In: productInterestIdSet];
        }
        List<String> mobileList = new List<String>();       
        for(Lead LeadObj : leadDataList){
            mobileList.add(LeadObj.mobilePhone);
        }
        for(WrapperClass leadObj : wprObj){
            if(!mobileList.contains(leadObj.leadClassObj.mobile)){
                List<Map<String,List<String>>> productList = new List<Map<String,List<String>>>();
                for(ProductIntrests ProductIntrestsObj : leadObj.productIntrestList){
                    Map<String,List<String>> productSourceMap = new Map<String,List<String>>();
                    List<String> sourceTempList = new List<String>();
                    for(Source sourceObj : ProductIntrestsObj.sourceList){
                        sourceTempList.add(sourceObj.sourceListName);
                    }
                    productSourceMap.put(ProductIntrestsObj.productName, sourceTempList);
                    productList.add(productSourceMap);
                }               
                wrapperDataMap.put(leadObj.leadClassObj.mobile, productList);
                List<Lead> ldataList = new List<Lead>();
                for (String l : wrapperDataMap.keySet()) {
                    Lead ldata = new Lead();
                    ldata.MobilePhone = l;
                    ldata.LastName = 'Ak'+l;
                    ldata.Company = 'BM';
                    ldataList.add(ldata);
                }
                insert ldataList;
                
                List<ProductIntrest__c> productInterestListData = new List<ProductIntrest__c>();
                for(String l : wrapperDataMap.keySet()){
                    for(Lead leadData : ldataList){
                        if(l==leadData.MobilePhone){
                            for(Map<String,List<String>> prodMap : wrapperDataMap.get(l)){
                                for(String prodName : prodMap.keySet()){
                                    ProductIntrest__c productInterestData = new ProductIntrest__c();
                                    productInterestData.Name = prodName;
                                    productInterestData.ProductName__c = 'Thar';
                                    productInterestData.RltdLead__c = leadData.Id;
                                    productInterestListData.add(productInterestData);
                                }
                            }
                        }
                    }
                }
                insert productInterestListData;
                
                List<SourceTracker__c> sourceTrackerListData = new List<SourceTracker__c>();
                for(String l : wrapperDataMap.keySet()){
                    for(Lead leadData : ldataList){
                        if(l==leadData.MobilePhone){
                            for(Map<String,List<String>> prodMap : wrapperDataMap.get(l)){
                                for(String prodName : prodMap.keySet()){
                                    for(ProductIntrest__c prodDataVal : productInterestListData){
                                        if(prodName==prodDataVal.ProductName__c){
                                            for(String sourceDataVal : prodMap.get(prodName)){
                                                SourceTracker__c sourceTrackerData = new SourceTracker__c();
                                                sourceTrackerData.Name = 'Test';
                                                sourceTrackerData.Source__c = sourceDataVal;
                                                sourceTrackerData.RltdProductIntrest__c = prodDataVal.Id;
                                                sourceTrackerListData.add(sourceTrackerData);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }    
}


/*
for(WrapperClass leadObj : wprObj){
            System.debug('-----leadObj'+leadObj);
            if(!mobileList.contains(leadObj.leadClassObj.mobile)){
                System.debug('-----inside mobilelist--------');
                Map<String,Map<String,List<String>>> productList = new Map<String,Map<String,List<String>>>();
                set<String> productNameList = new set<String>();
                
                for(ProductIntrests ProductIntrestsObj : leadObj.productIntrestList){
                    System.debug('ProductIntrestsObj ==> ' + ProductIntrestsObj);
                    Map<String,List<String>> productSourceMap = new Map<String,List<String>>();
                    List<String> sourceNameList = new List<String>();
                    // Check for empty product in List
                    if(productNameList.isEmpty() || !productNameList.contains(ProductIntrestsObj.productName)){
                        productNameList.add(ProductIntrestsObj.productName);
                        
                        //List<String> subSourceTempList = new List<String>();
                        for(Source sourceObj : ProductIntrestsObj.sourceList){
                            sourceNameList.add(sourceObj.sourceListName);
                        }
                        System.debug('sourceNameList ==>' + sourceNameList);
                        for(Source sourceObj : ProductIntrestsObj.sourceList){
                            productSourceMap.put(sourceObj.subsourceList, sourceNameList);
                        }
                        System.debug('----productSourceMap ==> '+productSourceMap);
                        //productSourceMap.put(ProductIntrestsObj., subSourceTempList);
                        productList.put(ProductIntrestsObj.productName,productSourceMap);
                        System.debug('----productList'+productList);
                    }else if(productNameList.contains(ProductIntrestsObj.productName)){
                        productNameList.add(ProductIntrestsObj.productName);
                        List<String> subSourceTempList = new List<String>();
                        
                        for(Source sourceObj : ProductIntrestsObj.sourceList){
                            if(!sourceNameList.contains(sourceObj.sourceListName)){
                                sourceNameList.add(sourceObj.sourceListName);// List cotains all the Source for condition checking
                                subSourceTempList.add(sourceObj.sourceListName); // contains temp list to store in Map
                            }
                        }
                        System.debug('subSourceTempList ==>' + subSourceTempList);
                        for(Source sourceObj : ProductIntrestsObj.sourceList){
                            productSourceMap.put(sourceObj.subsourceList, subSourceTempList);
                        }
                        System.debug('----productSourceMap ==> '+productSourceMap);
                        //productSourceMap.put(ProductIntrestsObj., subSourceTempList);
                        productList.put(ProductIntrestsObj.productName,productSourceMap);
                        System.debug('----productList'+productList);
                    }
                    
                }               
                wrapperDataMap.put(leadObj.leadClassObj.mobile, productList);
            }
        }
*/


/*

    for(Lead leadObj : [SELECT Id FROM LEAD]){
        DELETE leadObj;
    }
    List<ProductIntrest__c> l = new List<ProductIntrest__c>();
    for(ProductIntrest__c productObj : [SELECT Id FROM ProductIntrest__c]){
        l.add(productObj);
    }
    DELETE l;
    
    List<SourceTracker__c> s = new List<SourceTracker__c>();
    for(SourceTracker__c sourceObj : [SELECT Id FROM SourceTracker__c]){
        s.add(sourceObj);
    }
    DELETE s;
    
String jsonStr =  '[ { "productIntrestList": [ { "ProductName": "XUV 500", "sourceList": [ { "sourceListName": "Facebook", "subsourceList": "SocialMedia" } ] }, { "ProductName": "XUV 500", "sourceList": [ { "sourceListName": "Insta", "subsourceList": "SocialMedia" } ] } ], "leadClassObj": { "name": "Akj", "mobile": "6748" } }, { "productIntrestList": [ { "ProductName": "XUV 500", "sourceList": [ { "sourceListName": "Insta", "subsourceList": "Social" } ] }, { "ProductName": "Thar", "sourceList": [ { "sourceListName": "Facebook", "subsourceList": "Social" }, { "sourceListName": "Insta", "subsourceList": "Social" } ] } ], "leadClassObj": { "name": "Alok", "mobile": "8875" } } ]';
LeadCreation.jsonString(jsonStr);    
*/