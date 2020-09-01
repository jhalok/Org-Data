/**
* 
* Description   - This class is used as a controller to display the Account Field.
*
* Created By    - Alok kumar
* 
* Created Date  - 23/08/2018
* 
* Revision Logs - V_1.0 - Created
*       
*/
public class ValidAccountInfo {
    
    //Getter Setter
    public Account acc { get; set; }
    public List<Account> result { get; set; }
    
    //Controller to intilize the variable
    public ValidAccountInfo (){
        acc = new Account();
    }
    
    
    public PageReference save() {
        insert acc;  
        result = [select id,Name,BillingCity,BillingState,Phone from Account where id =:acc.id];
        
        return null;
    } 
}