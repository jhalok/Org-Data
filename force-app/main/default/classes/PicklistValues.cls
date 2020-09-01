public with sharing class PicklistValues {
    @AuraEnabled(cacheable = true)
    public static List < FatchValueWrapper > fatchPickListValue(sObject objInfo, string picklistFieldApi) {
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objInfo.getSObjectType().getDescribe();
 
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
 
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values = fieldMap.get(picklistFieldApi).getDescribe().getPickListValues();
 
        // Create a list of wrapper to store picklist value/lable
        list < FatchValueWrapper > objWrapper = new list < FatchValueWrapper > ();
 
        for (Schema.PicklistEntry a: values) {
            FatchValueWrapper oFatchValueWrapper = new FatchValueWrapper();
            oFatchValueWrapper.slabel = a.getLabel();
            oFatchValueWrapper.svalue = a.getValue();
            objWrapper.add(oFatchValueWrapper);
        }
        return objWrapper;
 
    }
 // wrapper class 
    public with sharing class FatchValueWrapper {
        @auraEnabled public string slabel {get;set;}
        @auraEnabled public string svalue {get;set;}
    }
}