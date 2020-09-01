/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

 
 /**
 *  Purpose         :   This class is used to test the functionality of insertion & updation 
 *
 *  Create By       :   Alok Kumar
 *
 *  Created Date    :   20/07/2018
 *
 *  Revision Logs   :   V_1.0 - Created
 **/
 
@IsTest(SeeAllData=False)
private class DisplayAccountControllerTest {
    
/**
* 
* @description -  InsertRecords_Test() is used to test insert function of class DisplayAccountController working or not
* 
* @return 	   -  Null
* 
*/
    static testMethod void InsertRecords_Test(){
        
        //Intilization of DisplayAccountController class to store data
        DisplayAccountController dispRecords = new DisplayAccountController();
        
        //Storing Name in Account Object 
        dispRecords.accountRec.name='sachin';
        
        //Storing Phone in Account Object 
        dispRecords.accountRec.Phone = '9837050932';
 
        //Calling the save() of DisplayAccountController class to save record
        dispRecords.save();
        
        //Fetching records from the account object  
        Account fetchRec = [select name,phone from Account limit 1];
        
        //Checking the fetchRec is having sachin name or not
        system.assertEquals('sachin', fetchRec.Name);
    }
    
/**
* 
* @description -  UpdateRecords_Test() is used to test update function is working or not
* 
* @return 		- NULL
* 
*/
    static testMethod void UpdateRecords_Test(){
        
        //Calling InsertRecords_Test() to get the inserted data 
        InsertRecords_Test();
        
        //Intilization of DisplayAccountController class to store data
        DisplayAccountController dispUpdRecords = new DisplayAccountController();
        
        //Storing existing Name in Account Object 
        dispUpdRecords.accountRec.Name = 'Sachin';
		
        //Storing the new phone to the existing name sachin
        dispUpdRecords.accountRec.Phone ='8058327903';
        
        //Calling updateData() of DisplayAccountController class
        dispUpdRecords.updateData();
        
        //Fetching records from the account object  
        Account fetchRec = [select name,phone from Account limit 1];
        
        //Condition to check that name exists or not in fetchRec retrived data
        System.assertEquals('sachin', fetchRec.Name);
        
        //Condition to check that updated no exist in database or not 
        System.assertEquals('8058327903', fetchRec.Phone);
    }
}