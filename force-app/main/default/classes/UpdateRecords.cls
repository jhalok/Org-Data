/**
* 
* Description   - This class is used to update the record in the object. 
* 
* Created By    - Alok kumar
* 
* Created Date  - 10/07/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/
public class UpdateRecords {
    
/**
* 
* @description - updateName() is used to perform the update operation.
*
* @args        - 
* 
* @return 	   - void 
* 
*/
    public void updateName(String strName){
        
        //List to fetch the records
        List<Account> listToFetch = [Select Name from Account where Name =: strName];
        
        //List to update the records
        List<Account> listToUpdate = new List<Account>();
        
        //For each loop to iterate the fetchedData 
        for(Account acc :listToFetch){
            
            //Condition to update the name
            if(acc.Name == strName){
                
                //After updation the name displayed
                acc.Name ='Ankur';
                
                //To add the acc data in List
               listToUpdate.add(acc);
            }           
        }
        //update operation to update the object field
        update listToUpdate;   
        
        System.debug(listToUpdate);
    }
}