public class LeadCreation {
    
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
        List<Lead> leadDataList = new List<Lead>();
        List<WrapperClass> wprObj = (List<WrapperClass>)JSON.deserialize(JsonData, List<WrapperClass>.class);
        System.debug('--------wprObj'+wprObj);
        Map<String,Map<String,Map<String,List<String>>>> wrapperDataMap = new Map<String,Map<String,Map<String,List<String>>>>();
        Set<Id> productInterestIdSet = new Set<Id>();
        List<SourceTracker__c> sourceTrackList = new List<SourceTracker__c>();
        Set<String> mobileNumberSet = new Set<String>();
        
        for(WrapperClass leadData : wprObj){
            mobileNumberSet.add(leadData.leadClassObj.mobile);
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
            System.debug('-----leadObj'+leadObj);
            if(!mobileList.contains(leadObj.leadClassObj.mobile)){
                System.debug('-----inside mobilelist--------');
                Map<String,Map<String,List<String>>> productList = new Map<String,Map<String,List<String>>>();
                for(ProductIntrests ProductIntrestsObj : leadObj.productIntrestList){
                    Map<String,List<String>> productSourceMap = new Map<String,List<String>>();
                    List<String> sourceNameList = new List<String>();
                    for(Source sourceObj : ProductIntrestsObj.sourceList){
                        sourceNameList.add(sourceObj.sourceListName);
                    }
                    for(Source sourceObj : ProductIntrestsObj.sourceList){
                        productSourceMap.put(sourceObj.subsourceList, sourceNameList);
                    }
                    System.debug('----productSourceMap'+productSourceMap);
                    //productSourceMap.put(ProductIntrestsObj., subSourceTempList);
                    productList.put(ProductIntrestsObj.productName,productSourceMap);
                    System.debug('----productList'+productList);
                }               
                wrapperDataMap.put(leadObj.leadClassObj.mobile, productList);
            }
        }
        
        List<Lead> ldataList = new List<Lead>();
        System.debug('wrapperDataMap.keySet() ==> ' + wrapperDataMap.keySet());
        for (String l : wrapperDataMap.keySet()) {
            System.debug('l ==>' + l);
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
                    System.debug('wrapperDataMap.get(l) ==>' + wrapperDataMap.get(l));
                    System.debug('wrapperDataMap.values() ==>' + wrapperDataMap.values());
                    for(String prodName : wrapperDataMap.get(l).keySet()){
                        ProductIntrest__c productInterestData = new ProductIntrest__c();
                        productInterestData.Name = prodName;
                        productInterestData.ProductName__c = prodName;
                        productInterestData.RltdLead__c = leadData.Id;
                        productInterestListData.add(productInterestData);
                    }
                }
            }
        }
        System.debug('productInterestListData ==>' + productInterestListData);
        insert productInterestListData;
        
        List<SourceTracker__c> sourceTrackerListData = new List<SourceTracker__c>();
        for(String l : wrapperDataMap.keySet()){
            for(Lead leadData : ldataList){
                System.debug('leadData ==> ' + leadData);
                if(l==leadData.MobilePhone){
                    for(ProductIntrest__c prodDataVal : productInterestListData){
                        if(leadData.Id==prodDataVal.RltdLead__c){
                            List<List<String>> sourceListList = wrapperDataMap.get(l).get(prodDataVal.Name).values();
                            System.debug('--sourceListList--'+sourceListList);
                            for(List<String> sourceObjList : sourceListList){
                                for(String sourceObj : sourceObjList){
                                    SourceTracker__c sourceTrackerData = new SourceTracker__c();
                                    sourceTrackerData.Name = 'Source' + sourceObj;
                                    sourceTrackerData.SubSource__c = 'SocialMedia';
                                    sourceTrackerData.Source__c = SourceObj;
                                    sourceTrackerData.RltdProductIntrest__c = prodDataVal.Id;
                                    sourceTrackerListData.add(sourceTrackerData);
                                }
                            }
                        }
                    }
                }
            }
        }
        System.debug('sourceTrackerListData ==>' + sourceTrackerListData);
        insert sourceTrackerListData;
    }   
}