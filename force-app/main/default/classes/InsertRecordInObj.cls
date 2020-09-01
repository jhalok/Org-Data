/**
* 
* Description   - This class is used to insert record in the object.
* 
* Created By    - Alok kumar
* 
* Created Date  - 05/07/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/
public class InsertRecordInObj {
    
    //Variable declaration & initilization
    Integer numOfTimes = 5;
    
    //Array declaration & Intilization
    Account [] accRef =  new Account[numOfTimes];
    
/**
* 
* @description - value() is used to insert the record in object account.
* 
* @args        - null
* 
* @return 	   - void 
* 
*/
    public void insertRecords() {
        
        //Variable declaration & initilization
    Integer numOfTimes = 5;
    
    //Array declaration & Intilization
    Account [] accRef =  new Account[numOfTimes];
    
        
        //For loop to iterate till the value stored in num variable
        For(Integer i = 0; i < numOfTimes ; i++){
            
            //Storing values 
            accRef[i] = new Account(Name = 'Ankit'+i, phone ='983279'+i);
        }
        
        //Inserting the data in Account object 
        insert accRef;
   
        //To display the value on console
        System.debug(accRef);
    }
}