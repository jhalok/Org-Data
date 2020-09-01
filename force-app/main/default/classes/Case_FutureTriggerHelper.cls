/**
*   Description     :  This is a helper class of Trigger_CaseFuture to delete if subject is 'OUT OF OFFICE'.
*
*   Created by      :   Alok Kumar
*
*   Created Date    :   31/07/2018
*
*   Revision Log    :   V1.0 - Created
*
**/
public without sharing class Case_FutureTriggerHelper {
    
    /**
* 
* @description  -  DeleteCase() is used to check the case of subject and delete it.
*
* @return       -  Null
* 
*/      
    public static void deleteCase(List<Case> newCases){
        
        List<Case> deleteCases = new List<Case>();
        
        //Set to store the id of Case
        Set<Id> setOfId = new Set<Id>();
        
        //Iteration of the new data
        for(Case cases : newcases){
            
            //Condition to check that if subject is null and sub is out of office then idwill be added to list
            if(cases.Subject != null && cases.Subject.equalsIgnorecase('OUT OF OFFICE')){
                deleteCases.add(new Case(Id=cases.Id));
            }
            //Else condition if the subject is other then OUT OF OFFICE
            else{
               setOfId.add(cases.id);
            }
        }
        updateType(setOfId);
        
        //delete condition to delete the ids
        delete deleteCases;
    }
    
    /**
* 
* @description  - updateType() is used to update the type according to the origin.
*
* @return       -  Null
* 
*/          
    @Future
    public static void updateType(set<id> setId){
        
        //List to fetch the relevent data from case
        List<Case> cases = [SELECT Id, Subject , Origin, Type FROM Case WHERE Id IN : setId ];
        
        //Iteration of the fetched data
        for(Case recordOfCase : cases) {
            
            //Assigning the Origin value to the type
            recordOfCase.Type = recordOfCase.Origin;                 
        }
        //Condition to check before the update 
        update cases;        
    }
}