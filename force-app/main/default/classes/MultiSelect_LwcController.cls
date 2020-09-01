public with sharing class MultiSelect_LwcController {
   
    @AuraEnabled(cacheable=true)
    public static List<sObject> getResults(String value, String ObjectName, List<String> selectedRecId) {
        String searchKey = '%' + value + '%';
        List < sObject > returnList = new List < sObject > ();
 
        List<string> lstExcludeitems = new List<string>();
        /*for(sObject item : selectedRecId ){
            lstExcludeitems.add(item.id);
        }*/
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
        String sQuery =  'select id, CleanStatus, Phone, OwnerId, AccountNumber, Name from ' +ObjectName + ' where (Name LIKE: searchKey OR Phone LIKE: searchKey) AND Id NOT IN : selectedRecId order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        System.debug('lstOfRecords------'+lstOfRecords);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        System.debug('returnlist--------'+returnList);
        return returnList;
    }

    /*@AuraEnabled(cacheable=true)
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value, List<String> selectedRecId) {
        fieldName = 'Name';
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        system.debug(fieldName+'-------------'+ObjectName+'---++----------'+value+'====='+selectedRecId);
        if(selectedRecId == null)
            selectedRecId = new List<String>();

        if(String.isNotEmpty(value)) {
            // splittedValues = fieldvalue.split(',');
            String query = 'Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value.trim() + '%\' and ID NOT IN: selectedRecId';
            system.debug(query);
            for(sObject so : Database.Query(query)) {
                String fieldvalue = (String)so.get(fieldName);
                //List<String> splittedValues = fieldvalue.split(',');
                //System.debug('splittedValues-----'+splittedValues);
                sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
            }
        }
        return sObjectResultList;
    }*/
    
    public class SObjectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        
        public SObJectResult(String recNameTemp, Id recIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
        }
        public SObJectResult() {
          
        }
    }
}