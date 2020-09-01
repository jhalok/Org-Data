/*
 * @Created Date:- 21th APRIL 2018
 * @Author : AMIT SINGH
 * @Description : Class used for the lightning component which illustrate how to use Field Set in 
 *              : Salesforce Lightning Component
 * @Company : sfdcpanther
 * @Name : FieldSetComponentController
 */ 
public class FieldSetComponentController {
    
    /*
     * @Created Date:- 21th APRIL 2018
     * @Author : AMIT SINGH
     * @Name : getsObjects
     * @ReturnType : List<String>
     * @param : none
     * @Description : List all the Objects that have atlead one fieldSet 
     */ 
    @AuraEnabled 
    public static List<String> getsObjects(){
        List<String> sObjectList = new List<String>();
        FOR(Schema.SObjectType sObj : Schema.getGlobalDescribe().values()){
            // Show only those objects which have atleast one Field Set
            Map<String, Schema.FieldSet> FieldSetMap = sObj.getDescribe().fieldSets.getMap();
            if(FieldSetMap!=null && FieldSetMap.keySet().size() > 0){
                sObjectList.add(sObj.getDescribe().getName() +'####'+sObj.getDescribe().getLabel());
            }
        }
        return sObjectList;
    }
    
    /*
     * @Created Date:- 21th APRIL 2018
     * @Author : AMIT SINGH
     * @Name : getFieldSet
     * @ReturnType : List<String>
     * @param : String sObjectName
     * @Description : List all the Fiels Sets of a particular Object 
     */ 
    @AuraEnabled 
    public static List<String> getFieldSet(String sObjectName){
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(sObjectName);
        List<String> fieldSetList = new List<String>();
        FOR(Schema.FieldSet FS : sObj.getDescribe().fieldSets.getMap().values()){
            fieldSetList.add(fs.getName() +'####'+fs.getLabel());
        }
        return fieldSetList;
    }
    
    /*
     * @Created Date:- 21th APRIL 2018
     * @Author : AMIT SINGH
     * @Name : getFieldSetMember
     * @ReturnType : String
     * @param : String objectName , String fieldSetName
     * @Description : List all the Fields that are added into the FielsSet
     */
    @AuraEnabled //@future
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
        //System.debug('#### wrapperList '+wrapperList);
        
        return JSON.serialize(wrapperList);
    }
    
    /*
     * @Created Date:- 21th APRIL 2018
     * @Author : AMIT SINGH
     * @Name : doUpsertObjects
     * @ReturnType : String
     * @param : sObject objectData
     * @Description : Upsert the Data into the Database and return the upserted record.
     */
    @AuraEnabled
    public static String doUpsertObjects(sObject objectData){
        upsert objectData;
        return JSON.serialize(objectData);
    }
    
    /*
     * @Description : Wrapper class contains the information about all the fields of a FieldSet
     */ 
    public class FieldSetMemberWrapperClass{
        
        @AuraEnabled
        public Boolean isDBRequired                      { get; set; }
        @AuraEnabled
        public Boolean isRequired                        { get; set; }
        @AuraEnabled
        public String fieldType                          { get; set; }
        @AuraEnabled
        public String fieldLabel                         { get; set; }
        @AuraEnabled
        public String fieldAPIName                       { get; set; }
        @AuraEnabled 
        public List<Schema.PicklistEntry> pickListValues { get; set; }
        
    }
}