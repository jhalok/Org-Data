public class PaginationDyn {
    
    public static List<ObjectWrapper> selectedObj(){
        List<ObjectWrapper> objectList = new List<ObjectWrapper>();
        for ( Schema.SObjectType sObjType : Schema.getGlobalDescribe().values() ) {
            Schema.DescribeSObjectResult objResult = sObjType.getDescribe();
            objectList.add(new ObjectWrapper(objResult.getName()));
        } 
        return objectList;
    }
    
    public class ObjectWrapper{
        @AuraEnabled 
        public String objName;
        
        objectWrapper(String ObjName){
            this.objName = objName;
        }
    }
}