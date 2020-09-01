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

@isTest
private class TriggerExpenseItemTest  {
    
     @testSetup static void setup(){
         List<Expense_Item__c> newItem = new List<Expense_Item__c>();
         newItem.add(new Expense_Item__c(Description__c='Fuel',Expense_Type__c='Fuel',Date__c=Date.valueOf('2018-07-31'),Bill_Number__c='0001',Expense_Amount__c=200,Expense__c='a036F0000130JUZ'));
         newItem.add(new Expense_Item__c(Description__c='Food',Expense_Type__c='Food',Date__c=Date.valueOf('2018-07-31'),Bill_Number__c='0002',Expense_Amount__c=200,Expense__c='a036F0000130JUZ'));
         newItem.add(new Expense_Item__c(Description__c='Other',Expense_Type__c='Other',Date__c=Date.valueOf('2018-07-31'),Bill_Number__c='0003',Expense_Amount__c=200,Expense__c='a036F0000130JUZ'));
         insert newItem;
     }
	 public static testMethod void DuplicateBillNoParentUpdate_Test(){
         List<Expense_Item__c> newItem = new List<Expense_Item__c>();
         List<Expense_Item__c> errorItem = new List<Expense_Item__c>();
         List<Expense_Item__c> updateItem = new List<Expense_Item__c>();
         
         newItem = [select Bill_Number__c from Expense_Item__c ];
         System.assertEquals('0001',newItem[0].Bill_Number__c);
    
         System.assertEquals('0002',newItem[1].Bill_Number__c);
        
         System.assertEquals('0003',newItem[2].Bill_Number__c);
         
         
         try{
         errorItem.add(new Expense_Item__c(Description__c='Fuel',Expense_Type__c='Fuel',Date__c=Date.valueOf('2018-07-31'),Bill_Number__c='0001',Expense_Amount__c=200,Expense__c='a036F0000130JUZ'));
         errorItem.add(new Expense_Item__c(Description__c='Fuel',Expense_Type__c='Fuel',Date__c=Date.valueOf('2018-07-31'),Bill_Number__c='0001',Expense_Amount__c=200,Expense__c='a036F0000130JUZ'));
         insert errorItem;
        
         //throw new Exception('An exception should have been thrown by the trigger but was not.'); 
         }
         catch(Exception e){
        
             Boolean expectedExceptionThrown =  e.getMessage().contains('This bill number already exist with associated expense') ? true : false;
            
             System.AssertEquals(expectedExceptionThrown, true);
        
        } 
        
         updateItem.add(new Expense_Item__c(Id=newItem[0].Id,Description__c='Fuel',Expense_Type__c='Fuel',Date__c=Date.valueOf('2018-07-31'),Bill_Number__c='0001',Expense_Amount__c=201,Expense__c='a036F0000130JUZ'));
         updateItem.add(new Expense_Item__c(Id=newItem[1].Id,Description__c='Food',Expense_Type__c='Food',Date__c=Date.valueOf('2018-07-31'),Bill_Number__c='0002',Expense_Amount__c=202,Expense__c='a036F0000130JUZ'));
         updateItem.add(new Expense_Item__c(Id=newItem[2].Id,Description__c='Other',Expense_Type__c='Other',Date__c=Date.valueOf('2018-07-31'),Bill_Number__c='0003',Expense_Amount__c=203,Expense__c='a036F0000130JUZ'));
         update updateItem;
         
         System.assertEquals(201,updateItem[0].Expense_Amount__c);
         System.assertEquals(202,updateItem[1].Expense_Amount__c);
         System.assertEquals(203,updateItem[2].Expense_Amount__c);
                
        
         System.assertEquals(3,newItem.Size());
       
         //Expense_Item__c[] deleteCase = [Select Id from Expense_Item__c];
         delete newItem[0];
         System.assertEquals(2,[Select Id from Expense_Item__c].Size());
         
         delete newItem[1];
         System.assertEquals(1,[Select Id from Expense_Item__c].Size());
         
         delete newItem[2];
         System.assertEquals(0,[Select Id from Expense_Item__c].Size());
          
     }
}