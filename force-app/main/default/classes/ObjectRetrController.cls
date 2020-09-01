public with sharing class ObjectRetrController {
    
    
    public List<selectOption> listOfObjects{get;set;} 
    public String curruntObject {get;set;}
    public Boolean createCheckBox{get;set;}
    public Boolean viewCheckBox{get;set;}
    public Boolean deleteCheckBox{get;set;}
    public  ObjectRetrController(){
        listOfObjects = new list<SelectOption>();
  
        Map<String,Schema.SObjectType> mapSObjectDescribe = Schema.getGlobalDescribe();
        
        curruntObject='None';       
        listOfObjects.add(new selectOption(curruntObject,curruntObject));
        for(String objectName : mapSObjectDescribe.keySet()) {
            listOfObjects.add(new SelectOption(objectName,objectName));
        }   
    }
    
    public void ObjectInformation(){
         createCheckBox = False;
              viewCheckBox=False;
              deleteCheckBox=False;     
        Map<String, Schema.SObjectType> mapSObjectDescribe = Schema.getGlobalDescribe();
        sObjectType obj = mapSObjectDescribe.get(curruntObject);
        system.debug(obj);
        Schema.DescribeSObjectResult objDesDetails = obj.getDescribe();
    
     createCheckBox =objDesDetails.isCreateable();
        viewCheckBox =objDesDetails.isAccessible(); 
            deleteCheckBox=objDesDetails.isDeletable();
        system.debug(createCheckBox);
     
    } 
    public void showObjectField(){
        
    }  
}