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

@IsTest
public class DMLOperationsTest {
    
    static testMethod void insertRecords_test(){
    
        List<Account> testAccounts;
      
        DMLOperations dml = new DmLOperations();
    
        dml.insertRecords();
        
        //Asserting for newly inserted records
        testAccounts =[Select name from Account]; 
        
        system.assertEquals(5,testAccounts.size());
        
}

    static testMethod void updateRecords_test(){
        
  	    DMLOperations dml = new DmLOperations();

        DMLOperations.updateRecords('Ankur');
        
       	System.assertEquals('Alok','Ankur');
      }
    
    static testMethod void delExisRecord_test(){
        
        DMLOperations dml = new DMLOperations();
        
         
        Account deletedAcc = [Select Name from Account where Name ='Neha'];
 
               DMLOperations.delExisRecord('Neha');

        System.assertEquals(deletedAcc.IsDeleted,True);
    }
    
    static testMethod void upsertRecord_test(){
     
        DMLOperations dml= new DMLOperations();
        
        DMLOperations.upsertRecord('Alok', 'Jaipur');
        
     	System.assertEquals('Alok', 'Alok');
        
        System.assertEquals('Jaipur', 'Jaipur');
    }
}