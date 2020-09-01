public class fieldSetComponentContr {
    @AuraEnabled
    public static List<String> getObjects(){
        List<String> SobjectList = new List<String>();
        for(Schema.SObjectType sObj : Schema.getGlobalDescribe().values()){
            System.debug('sObj'+sObj);
            Map<String, Schema.FieldSet> FieldSetMap = sObj.getDescribe().fieldSets.getMap();
            System.debug('FieldSetMap'+FieldSetMap);
            if(FieldSetMap!=null && FieldSetMap.size() > 0){
                sObjectList.add(sObj.getDescribe().getName() +','+sObj.getDescribe().getLabel());
            }
        }    
        return sObjectList;      
    }
    
    @AuraEnabled 
    public static List<String> getFieldSet(String sObjectName){   
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(sObjectName); 
        List<String> fieldSetList = new List<String>();
        FOR(Schema.FieldSet FS : sObj.getDescribe().fieldSets.getMap().values()){
               System.debug('FS'+FS);
            fieldSetList.add(fs.getName() +','+fs.getLabel());
        }
        return fieldSetList;
    }
    
    @AuraEnabled
    public static String getFieldSetMember(String objectName , String fieldSetName){  
        List<FieldSetMemberWrapperClass> wrapperList = new List<FieldSetMemberWrapperClass>();
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objectName);     
        for(Schema.FieldSetMember fieldMember : sObj.getDescribe().fieldSets.getMap().get(fieldSetName).getFields()){
            FieldSetMemberWrapperClass wrapper = new FieldSetMemberWrapperClass();
            wrapper.isDBRequired = fieldMember.getDbRequired();
            wrapper.isRequired = fieldMember.getRequired();
            wrapper.fieldType = String.valueOf(fieldMember.getType());
            wrapper.fieldLabel = fieldMember.getLabel();
            wrapper.fieldAPIName = fieldMember.getFieldPath();
            if(String.valueOf(fieldMember.getType()) == 'PICKLIST' || 
                            String.valueOf(fieldMember.getType()) == 'MULTIPICKLIST'){
                wrapper.pickListValues = sObj.getDescribe().fields.getMap().get(fieldMember.getFieldPath())
                                                           .getDescribe().getPicklistValues();
            }
            wrapperList.add(wrapper);
        } 
        return JSON.serialize(wrapperList);
    }
    
    @AuraEnabled
    public static String doUpsertObjects(sObject objectData){
        upsert objectData;
        return JSON.serialize(objectData);
    }
     
    public class FieldSetMemberWrapperClass{
        
        @AuraEnabled
        public Boolean isDBRequired { get; set; }
        @AuraEnabled
        public Boolean isRequired { get; set; }
        @AuraEnabled
        public String fieldType { get; set; }
        @AuraEnabled
        public String fieldLabel { get; set; }
        @AuraEnabled
        public String fieldAPIName{ get; set; }
        @AuraEnabled 
        public List<Schema.PicklistEntry> pickListValues { get; set; }        
    }
}