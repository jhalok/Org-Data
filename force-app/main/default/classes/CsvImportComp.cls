public class CsvImportComp {
    
    @AuraEnabled
    public Static List<String> getObjectName(){
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();     
        List<String> objNames = new List<String>();
        for(SObjectType f : gd){
            if(f.getDescribe().isUpdateable()){
                objNames.add(f.getDescribe().getName());
                objNames.sort();
            }
        }
        System.debug('--objects--'+objNames);
        return objNames;
    }
    
    @AuraEnabled
    public static Map<String, String> getFieldName(String selectedObj) {
        Map<String, String> retVal = new Map<String, String>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(selectedObj).getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()) {  
            retVal.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
        }
        System.debug('return selected fields ---'+retVal);
        return retVal;
    }
    
    @AuraEnabled
    public static void processData(String fileData,String sobjectName,List<String> fields) {    
        System.debug('fileData---'+filedata);
        System.debug('sobjectName---'+sobjectName);
        System.debug('fields---'+fields);
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sobjectName);
        System.debug('--targetType'+targetType);
        try{
            if(fileData!=null){ 
                String[] fileLines = new String[]{};
                    fileLines = fileData.split('\n');
                System.debug('--fileLines---'+fileLines);
                //for content
                List<sObject> myList = new List<sObject>();
                System.debug('--fileline size--'+fileLines.size());
                for (Integer i=1,j=fileLines.size();i<j;i++){
                    String[] inputvalues = new String[]{};
                        inputvalues = fileLines[i].split(',');
                    System.debug('--inputValues--'+inputValues);
                    sObject obj = targetType.newSObject();
                    //System.debug('--obj--'+obj);
                    integer rowsize = inputvalues.size();
                    System.debug('rowsize::'+rowsize);
                    System.debug('fields size'+fields.size());
                    //Iterate all data till row size
                    for(integer l=0;l<rowsize;l++){
                        system.debug('fields.get(l)'+fields.get(l)); 
                        if(String.isNotBlank(inputvalues[l]) )
                        {
                            String value= inputvalues[l].length()>255 ? inputvalues[l].substring(0,254) : inputvalues[l];
                            obj.put(fields.get(l),value);
                        }else{
                            obj.put(fields.get(l),'');
                        }
                    }
                    System.debug('Obj::::'+obj);
                    myList.add(obj);
                }
                System.debug('--mylist insert'+myList);
             
            }
        }catch(Exception e){
            System.debug('exception'+e);   
        }  
    }
}