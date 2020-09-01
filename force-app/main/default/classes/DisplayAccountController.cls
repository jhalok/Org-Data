/**
* 
* Description   - This class is used as a controller to fetch the data Of Account & show on visulaforce page. 
* 
* Created By    - Alok kumar
* 
* Created Date  - 11/07/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/
public class DisplayAccountController {
    
    public Account accountRec{get;set;}
    
    public List<Account> listRec{get;set;}
    
    
    //Constructor 
    public DisplayAccountController(){
        
        //Intilization of Account 
        accountRec = new Account();
        
        //Intilization of List<Account> 
        listRec = new List<Account>();
        
    }
    
    
    //Save Method to save the data Stored in the corresponding field
    public void save(){
        
        //Fetching the details in listRec
        listRec = [Select Name,Phone,AccountNumber,Website from Account Order by Name Limit 10];
        
        //Inserting the Fetched data
        insert accountRec; 
        
        //To Display the Save Message after Storing Data on VisualForce Page 
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Created Successfully.Thank you!'));
        
        //To show blank Input fields after Storing data  
        accountRec = new Account();
    } 
 
    //updateData() is used to update the data if the record is existing
    public void updateData(){
        
        //Account object declaration & initilization
        Account fetchData = new Account();
        
        //It will fetch the data from the specifying query
        fetchData = [Select Id from Account where Name =:accountRec.Name];
        
        //Assigning the accountRec.Phone to fetchData.Phone
        fetchData.Phone = accountRec.Phone;
        
        //Assigning the accountRec.Website to fetchData.Website
        fetchData.Website = accountRec.Website;
        
        //Assigning the accountRec.AccountNumber to FetchData.AccountNumber
        FetchData.AccountNumber = accountRec.AccountNumber; 
        
        //updating the record
        update fetchData;
        
        //To Display the Data Updated Message  
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Updated Successfully.Thank you!'));
    }
}