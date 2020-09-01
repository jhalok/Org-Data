@isTest
public class ExpenseTriggerTest {

    public static List<Expense__c> createExpenseWithExpenseItem() {
        
        List<Expense__c> expenses = new List<Expense__c>();
             expenses.add( new Expense__c( Name = '2018-October', Client__c = 'Dan', Type__c = 'Monthly'));
             expenses.add( new Expense__c( Name = '2018-November', Client__c = 'Nick', Type__c = 'Monthly'));
             expenses.add( new Expense__c( Name = '2018-December', Client__c = 'Tom', Type__c = 'Monthly'));
        insert expenses; 
        
        List<Expense_Item__c> expenseItem = new List<Expense_Item__c>();
             expenseItem.add(new Expense_Item__c(Name = 'Food',Bill_Number__c = '5678',Expense_Type__c='Food', Expense__c = expenses[0].Id,Date__c = system.today(),Description__c = 'food',Expense_Amount__c = 0.00));
             expenseItem.add(new Expense_Item__c(Name = 'Fuel',Bill_Number__c = '5674',Expense_Type__c='Fuel', Expense__c = expenses[1].Id,Date__c = system.today(),Description__c = 'fuel',Expense_Amount__c = 0.00));
             expenseItem.add(new Expense_Item__c(Name = 'Other',Bill_Number__c = '4534',Expense_Type__c='Other', Expense__c = expenses[2].Id,Date__c = system.today(),Description__c = 'other',Expense_Amount__c = 0.00));
       insert expenseItem;
       return expenses; 
        
    }
    
    public static List<Expense__c> createExpenseWithoutExpenseItem() {
        
        List<Expense__c> expenses = new List<Expense__c>();
             expenses.add( new Expense__c( Name = '2018-October', Client__c = 'Dan', Type__c = 'Monthly'));
             expenses.add( new Expense__c( Name = '2018-November', Client__c = 'Nick', Type__c = 'Monthly'));
             expenses.add( new Expense__c( Name = '2018-December', Client__c = 'Tom', Type__c = 'Monthly'));
        insert expenses; 
        return expenses;
    }
    
    @isTest static void TestDeleteExpenseWithExpenseItem() {
        // Test data setup
        // Create an expense with an ExpenseItem, and then try to delete it
        Expense__c[] expense = createExpenseWithExpenseItem();
        // Perform test
        Test.startTest();
        Database.DeleteResult[] results = Database.delete(expense, false);
        Test.stopTest();
         
        // Verify in this case the deletion should have been stopped by the trigger,
        for(Database.DeleteResult result : results) {
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        //Verify that we got back an error.
        System.assertEquals('Expense cant be deleted, because Expense is having sub Expenses',
                             result.getErrors()[0].getMessage());
    }
    }
    
    @isTest static void TestDeleteExpenseWithoutExpenseItem() {
        // Test data setup
        // Create an expense with an ExpenseItem, and then try to delete it
        Expense__c[] expense = createExpenseWithoutExpenseItem();
        
        // Perform test
        Test.startTest();
        Database.DeleteResult[] results = Database.delete(expense, false);
        Test.stopTest();
         
        // Verify in this case the deletion is performed by the trigger,
        for(Database.DeleteResult result : results) {
        System.assert(result.isSuccess());
    }
    }
}