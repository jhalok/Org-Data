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
private class Batch_SendEmailNotificationTest {
    
    @testSetup static void setup(){
        
        //This list hold houses list
        List<House__c> houses = new List<House__c>();
        
        //Add data in list 
        houses.add(new House__c(Name = 'House', Address__c = 'address'));
        
        //insert list
        insert houses;
        
        //This list hold persons
        List<Person__c> persons = new List<Person__c>();
            
        //Add data in list
        persons.add(new Person__c(Name = 'Alok', Gender__c = 'Male', Email__c = 'alok.kumar@briskminds.com'));
       
        //insert person list
        insert persons;
        
        //This list hold member list
        List<Member__c> members = new List<Member__c>();
        
        //Add data in list
        members.add(new Member__c(Name = 'Alok', Person__c = persons[0].Id, House__c = houses[0].Id));
        insert members;
        
        //This list hold Expense
        List<Expense__c> yearlyExpenses = new List<Expense__c>();
        
        //Add data in list yearly
        yearlyExpenses.add(new Expense__c(Client__c='Den',Name = 'Alok', Member__c = members[0].Id, Type__c = 'Yearly', Date__c = Date.today(), Total_Balance__c = 3000));
        insert yearlyExpenses;
        
        //This list to hold Expense monthly
        List<Expense__c> monthlyExpenses = new List<Expense__c>();
        
        //Add data in list 
        monthlyExpenses.add(new Expense__c(Client__c='Den',Name = 'Alok', Member__c = members[0].Id,Type__c = 'Monthly', Date__c = Date.newInstance(2018,08,23),Total_Balance__c = 10000,  Yearly_Expense__c = yearlyExpenses[0].Id, Short_Name__c='Jan'));
        monthlyExpenses.add(new Expense__c(Client__c='Den',Name = 'Alok', Member__c = members[0].Id,Type__c = 'Monthly', Date__c = Date.today(),Total_Balance__c = 12000,  Yearly_Expense__c = yearlyExpenses[0].Id,Short_Name__c='Feb' ));
        insert monthlyExpenses;
        
        //This list to hold Expense item
        List<Expense_Item__c> expenseItems = new List<Expense_Item__c>();
        
        //Add data in list
        expenseItems.add(new Expense_Item__C(Expense_Type__c = 'Food',  Expense_Amount__c = 300, Description__c = 'food expesne', Date__c = date.today() , Bill_Number__c = '100', Expense__c = monthlyExpenses[0].Id));
        expenseItems.add(new Expense_Item__C(Expense_Type__c = 'Other', Expense_Amount__c = 300, Description__c = 'food expesne', Date__c = date.today() , Bill_Number__c = '101', Expense__c = monthlyExpenses[0].Id));
        expenseItems.add(new Expense_Item__C(Expense_Type__c = 'Food',  Expense_Amount__c = 300, Description__c = 'food expesne', Date__c = date.today() , Bill_Number__c = '102', Expense__c = monthlyExpenses[0].Id));
        expenseItems.add(new Expense_Item__C(Expense_Type__c = 'Fuel',  Expense_Amount__c = 400, Description__c = 'food expesne', Date__c = date.today() , Bill_Number__c = '103', Expense__c = monthlyExpenses[0].Id));
        
        //insert expense item
        insert expenseItems;
        
        
    }
    
    public static testMethod void sendEmailNotification() {
    
        Test.startTest();
        List<House__c> houseList = new List<House__c>();
   
        List<House__c> houses1 = new List<House__c>();
        
        houseList = [Select Id,House_Owner__c from House__c];
        
        List<Member__c> members = new List<Member__c>();
        
        members = [Select Id from Member__c];
       
        houseList[0].House_Owner__c=members[0].id;
        
        Update houseList;
        
        houses1 = [Select Id,House_Owner__c from House__c];
        
        Batch_SendEmailNotification ExpenseNotif = new Batch_SendEmailNotification();
        
        Id batchId = Database.executeBatch(ExpenseNotif);
        
        Test.stopTest();
    }
}