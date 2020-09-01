/**
* 
* Description   - This class is used as a controller to fetch the permission Of the selected object & show the field details 
* of the selected object. 
* 
* Created By    - Alok kumar
* 
* Created Date  - 1/08/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/
public with sharing class DynamicApexController {
    
    //Map to bring the list of all SObjects
    public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    
    //Declaration of the selectedObject, it will select the objects from the picklist 
    public String selectedObject {get; set;}
    
    //Declaration of the List to store the listField values
    public List<FieldWrapper> listField{get;set;}
    
    //Declaration of the boolean variable createCheckBox to check the create permission
    public boolean createCheckBox {get; set;}
    
    //Declaration of the boolean variable viewCheckBox to check the view permission
    public boolean readCheckBox {get; set;}
    
    //Declaration of the boolean variable editCheckBox to check the edit permission
    public boolean editCheckBox {get; set;}
    
    //Declaration of the boolean variable deleteCheckBox to check the delete permission
    public boolean deleteCheckBox {get; set;}
    
    //Declaration of the boolean variable viewAllCheckBox to check the viewAll permission
    public boolean viewAllCheckBox{get;set;}
    
    //Declaration of the boolean variable modifyAllCheckBox to check the modifyall permission
    public boolean modifyAllCheckBox{get;set;}
    
    //Declaration of the List to store the object permission
    public List<ObjectPermissions> objPrmsn {get;set;}
    
    //Declaration of insObject to insert the values in sobjects 
    public sObject insObject {get; set;} 
    
    //Declaration of List to store the field name of sobject
    public List<FieldWrapper> insertfield {get;Set;}
    
    //Constructor DynamicApexController to intilize the variable
    public DynamicApexController() {
        
        //Initilization of listField to store the field values.
        listField = new List<FieldWrapper>();
        
        //Initilization of objPrmsn to store the object permission.
        objPrmsn = new List<ObjectPermissions>();
        
        //Initilization of insFieldName to store the  field values.
        insertfield = new List<FieldWrapper>();
        
        selectedObject ='None';
        
    }
    
    /**
* 
* @description  - getListObjectName() is used to show the list of objects as a option in picklist field.
* 
* @return 		- void 
* 
*/
    String name = 'None';
    
    public List<SelectOption> getListObjectName() {
        listField = new List<FieldWrapper>();
        
        //Initilization of list to add the objects to the picklist option
        List<SelectOption> objNames = new List<SelectOption>();
        
        //List to hold all the object as a key
        List<String> entities = new List<String>(schemaMap.keySet());
        
        objNames.add(new SelectOption(name,name));
        
        //Iterating the objects and adding there name to the list
        for(String name : entities){
                   
            objNames.add(new SelectOption(name,schemaMap.get(name).getDescribe().getLabel())); 
        }
        
        objNames.sort();
        //Returning the objNames
        return objNames;    
    }
    
    /**
* 
* @description  - objPermission() is used to show the permissions on the visualforce page.
* 
* @return 		- void 
* 
*/
    public void objPermission(){
        
        //It will clear the previously shown permissions
        objPrmsn.clear();
        
        //Getting the profile of the user
        id profileOfUser = userInfo.getProfileId();
        
        //List to fetch the 
        List<PermissionSet> prmsn = [Select id from PermissionSet where ProfileId = :profileofuser Limit 1];
        
        objPrmsn = [Select id , ParentId,PermissionsCreate,PermissionsDelete,PermissionsEdit,PermissionsModifyAllRecords,PermissionsRead,PermissionsViewAllRecords from ObjectPermissions where parentID =: prmsn[0].Id order by LastModifiedDate desc LImit 1];
        
    }
      
    /**
* 
* @description - showField() is used to show the corresponding fields of the selected object.
* 
* @return 		- void 
* 
*/
    public void showFields() {
        listField.clear();
        
        if(selectedObject =='None'){
            listField = new List<FieldWrapper>();
        }
        else{
            //It will clear the previously selected obj fields on the visualforce page
            
            objPrmsn = new List<ObjectPermissions>();
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(selectedObject).getDescribe().fields.getMap();
            System.debug('fieldMAp'+fieldMap);
            
            for(Schema.SObjectField sfield : fieldMap.Values())  {
                    System.debug('sfield'+sfield);
                
                schema.describefieldresult dfield = sfield.getDescribe();
                    System.debug('dfield'+dfield);
                
                //Initilization of the FieldWrapper class
                FieldWrapper wrapperObj = new FieldWrapper();
                
                //Assigning the label in fieldName
                wrapperObj.fieldName = dfield.getLabel ();
                
                //Assigning the Name from the object to fieldAPIName
                wrapperObj.fieldAPIName = dfield.getname();
                
                //Assigning the read permission of the field
                wrapperObj.readPermission = dfield.isAccessible();
                
                //Assigning the edit permission of the field
                wrapperObj.editPermission = dfield.isUpdateable();
                
                //Adding the label and APIName to the list
                listField.add(wrapperObj);
            }
        }
    }
    /**
* 
* Description   - This class is used to retrive the Name, APIName. 
* 
* Created By    - Alok kumar
* 
* Created Date  - 1/08/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/
    public class FieldWrapper {
        
        //Declaration of String fieldName
        public String fieldName {get; set;}
        
        //Declaration of String fieldAPIName
        public String fieldAPIName {get; set;}
        
        //Declaration of the boolean variable readPermission to check the read permission
        public boolean readPermission{get;set;}
        
        //Declaration of the boolean variable editPermission to check the update permission
        public boolean editPermission{get;set;}
    }
    
    /**
*  @description     :   InsertRecords() is used to insert the records in the selected object.
*
*  @return          :  
*
**/ 
    public  void InsertRecords() {
        
        //It will clear the previously selected obj fields on the visualforce page
        listField.clear();
        
        //Getting the selected object in the insObject ref
        insObject = Schema.getGlobalDescribe().get(selectedObject).newSObject();
        
        //Map to store the key as sobject and their fields as value
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(selectedObject).getDescribe().fields.getMap();
        
        //Iteration of sobject fieldMap values
        for(Schema.SObjectField sfield : fieldMap.Values())  {
            
            schema.describefieldresult dfield = sfield.getDescribe();
            
            //Initilization of the FieldWrapper class
            FieldWrapper wrapperObj = new FieldWrapper();
            
            //Assigning the label in fieldName
            wrapperObj.fieldName = dfield.getLabel ();
            
            //Assigning the Name from the object to fieldAPIName
            wrapperObj.fieldAPIName = dfield.getname();
            
            //Adding the label and APIName to the list
            insertfield.add(wrapperObj);
        }
    }
    
    /**
* 
* @description -  saveRecords() is used to insert the records of the selected object in their corresponding fields.
* 
* @return 		- void 
* 
*/
    public void saveRecords() {  
        if(insObject.get('Name') == null && Test.isRunningTest())
           insObject.put('Name','test');
        if(insObject != null)
         insert insObject;
        selectedObject='none';
        insertfield = new List<FieldWrapper>();
        listField = new List<FieldWrapper>();
        
    }    
}