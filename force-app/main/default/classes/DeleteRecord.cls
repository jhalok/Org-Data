/**
* 
* Description   - This class is used to delete the record in the object. 
* 
* Created By    - Alok kumar
* 
* Created Date  - 10/07/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/
public class DeleteRecord {
    
/**
* 
* @description - deleteExisRecord() is used to delete the existing record .
* 
* @args        - String nameStr
*
* @return 	   - void 
* 
*/
    public static void delUndExisRecord(String nameStr){
        
        //List to store the reterive data from query
        List <Account> listOfAccount = [Select Name from Account where Name =: nameStr];
        
        //To delete the fetchedData in listOfAccount
        delete listOfAccount;
        
        //List to store the data from query
        List <Account> listOfUndeleted = [Select Name from Account where Name =: nameStr];
        
        //To undelete the Existing record
        undelete listOfAccount;
    }
}