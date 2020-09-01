public class WrapperData {
	
  
    @AuraEnabled 
    public static WrapperToStoreData AccountDetails(String RecordId){
        WrapperToStoreData wrapperObj = new WrapperToStoreData();
        List<String> addNames = new List<String>();
        List<String> addBillingCity = new List<String>();
        List<Account> fetchData =[select id,Name,BillingCity from Account where Id =:RecordId];
        
        for(Account itData:fetchData){
            if(fetchData !=NULL){
                addNames.add(itData.Name);
            }
            wrapperObj.StoreName = addNames;
        }
        
        for(Account itData:fetchData){
            if(fetchData !=NULL){
                addBillingCity.add(itData.BillingCity);
            }
            wrapperObj.StoreCompany = addBillingCity;
            System.debug('wrapperObj Data'+ wrapperObj);
            return wrapperObj;
        }
        
        return null;
    }
    
    
    public class WrapperToStoreData{
       @AuraEnabled
       public List<String> StoreName;
       @AuraEnabled
       public List<String> StoreCompany;
        
        public WrapperToStoreData(){
           StoreName = new List<String>();
           StoreCompany = new List<String>();
        }
    }
}