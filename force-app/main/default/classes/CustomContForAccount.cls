/**
* 
* Description   - This class is used as a controller to fetch the data & show on visulaforce page. 
* 
* Created By    - Alok kumar
* 
* Created Date  - 11/07/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/

public class CustomContForAccount {
    
    //List to fetch and store the data
    List<House__c> listDetAcc = [Select id,Address__c,House_Owner__r.Name from House__c where Name='Prakash city'];
    
    //Get() to get the data from Object 
    public List<House__c> getlistDetAcc(){
        
        //Returning the list having data 
        return listDetAcc;
    }
}