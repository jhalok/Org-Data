/**
* 
* Description   - This class is used to perform the various DML operation. 
* 
* Created By    - Alok kumar
* 
* Created Date  - 10/07/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/
public class DMLOperations {
    
    public void insertRecords() {
        
        //Variable declaration & initilization
        Integer numOfTimes = 5;
        
        //Array declaration & Intilization
        Account [] accRef =  new Account[numOfTimes];
        
        //For loop to iterate till the value stored in num variable
        For(Integer i = 0; i < numOfTimes ; i++){
            
            //Storing values 
            accRef[i] = new Account(Name = 'Rohit Sharma'+i, phone ='983279'+i);
        }
        
        //Inserting the data in Account object 
        insert accRef;
    }
    
    /**
* 
* @description - updateName() is used to perform the update operation.
*
* @args        - 
* 
* @return 	   - void 
* 
*/
    public static void updateRecords(String strName){
        
        //List to fetch the records
        List<Account> listToFetch = [Select Name from Account where Name =: strName];
        
        //List to update the records
        List<Account> listToUpdate = new List<Account>();
        
        //For each loop to iterate the fetchedData 
        for(Account acc :listToFetch){
            
            //After updation the name displayed
            acc.Name ='Ankur';
            
            //To add the acc data in List
            listToUpdate.add(acc);           
        }
        //update operation to update the object field
        update listToUpdate;   
        
        System.debug(listToUpdate);
    }
    
    /**
* 
* @description - deleteExisRecord() is used to delete the existing record .
* 
* @args        - String nameStr
*
* @return 	   - void 
* 
*/
    public static void delExisRecord(String nameStr){
        
        //List to store the reterive data from query
        List <Account> listOfAccount = [Select Name from Account where Name =: nameStr];
        
        //To delete the fetchedData in listOfAccount
        delete listOfAccount;
        
    }
    
    
    /**
* 
* @description - upsertRecord() is used to insert the record if it doesn't exist or if the record 
* exist then it updates the record .
* 
* @args        - null
*
* @return 	   - void 
* 
*/
    public static void upsertRecord(String name,String city){
        
        //Initlization of Account 
        Account accDetailsRef = new Account();
        
        //Assigning the entered value by user to accDetailsRef.Name
        accDetailsRef.Name = name;
        
        //Assigning the entered value by user to accDetailsRef.BillingCity
        accDetailsRef.BillingCity = city;
        
        //upsert Operation
        upsert accDetailsRef;
        
    }
}