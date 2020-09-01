public class TreeHirerachy {
    
    @AuraEnabled
    public static List<TreeWrpClass> ObjectNames() {
        
        List<TreeWrpClass> objNames = new List<TreeWrpClass>();
        List<String> tempList = new List<String>();
        Map<String,String> objectstodisplay = new Map<String,String>();
        
        for(Schema.SObjectType objectType : Schema.getGlobalDescribe().Values()) {
            Schema.DescribeSObjectResult SObjectObj = objectType.getDescribe();
            String name = objectType.getDescribe().getName();
            tempList.add(objectType.getDescribe().getLabel()+'/'+objectType.getDescribe().getName());     
        }
        System.debug('-----tempList------'+JSON.serializePretty(tempList));
        
        tempList.sort();
        for(String str : tempList) {
            TreeWrpClass obj = new TreeWrpClass();
            List<String> splitList = str.split('/');
            obj.APIName = splitList[1];
            obj.LabelName = splitList[0];
            objNames.add(obj);
        }
        System.debug('objNames ---- '+JSON.serializePretty(objNames));
        return objNames;
    }

    @AuraEnabled
    public static TreeWrpClass parentSObjectRecords(String objectAPI) {
        List<SObject> lstofSObjectRecords = new List<SObject>();
        Map<String,List<String>> selectedChild = new Map<String,List<String>>();
        
        SObjectType objAPIName = Schema.getGlobalDescribe().get(objectAPI);
        DescribeSObjectResult objDescribe = objAPIName.getDescribe();
        String objectLabel = objDescribe.getLabel();
        System.debug('objAPIName -------'+objAPIName);
        System.debug('objDescribe -------'+objDescribe);
        System.debug('objectLabel -------'+objectLabel);
        Map<String, SObjectField> fields = objDescribe.fields.getMap();
        System.debug('fields *****'+fields);
      

        for (Schema.ChildRelationship childRelation: objDescribe.getChildRelationships()) {
            System.debug('name '+ childRelation.getChildSObject());
            if(childRelation.getChildSObject() == objAPIName) {
                if(!selectedChild.containsKey(String.valueof(childRelation.getChildSObject()))) {
                    selectedChild.put(String.valueof(childRelation.getChildSObject()), new List< String >());
                }
                selectedChild.get(String.valueof(childRelation.getChildSObject())).add(String.valueof(childRelation.getRelationshipName()));
            }
        }
        return null;
    }
    
    public class TreeWrpClass{
    @AuraEnabled
    public String APIName;
    @AuraEnabled
    public String LabelName;
    }
}