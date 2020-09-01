/**
* 
* Description   - This class is used to update the bill according to the type selected  
*
* Created By    - Alok kumar
* 
* Created Date  - 24/07/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/
public class ExpenseCalcHelper {
    
    /**
* 
* @description  -  this UpdateExpense() is used to update the expenses amount according to the type selected
*
* @return       -  Void
* 
*/

    public static void UpdateExpense(List<Expense_Item__c> newexpItems, Map<id,Expense_Item__c> oldMapExpenseItems) {
        
        //Add id of the record enterd 
        set<Id> setExpenseIds = new set<Id>();
        
        //Iterating the new entered records
        for(Expense_Item__c expItr : newexpItems) {
            
            //Condition to check for Insert and Update
            if ((expItr.Expense_Type__c != null && expItr.Expense_Amount__c != null) &&  (oldMapExpenseItems == null  || expItr.Expense_Amount__c != oldMapExpenseItems.get(expItr.Id).Expense_Amount__c || expItr.Expense_Type__c != oldMapExpenseItems.get(expItr.Id).Expense_Type__c))  
                
                //Adding id of the expense items related to expens
                setExpenseIds.add(expItr.Expense__c);
        }
        
        Map<Id, Expense__c> mapOfExpenses = new Map <Id, Expense__c> ([Select Id, Food_Expenses__c, Fuel_Expenses__c, Other_Expenses__c From Expense__c Where Id IN:setExpenseIds]); 
        
        Expense__c Expense = new Expense__c ();
        
        if(setExpenseIds.size() > 0) {
            
            //Iterating the new records 
            for(Expense_Item__c expt : newexpItems)  { 
                        
                Expense = mapOfExpenses.get(expt.Expense__c);
                
                //Condition to check that Expense type is equals to food
                if(expt.Expense_Type__c == 'Food') {
                    
                    //Condition to check that food expense is not equal to null
                    if(Expense.Food_Expenses__c != null )
                        
                        //Addition of expense item amount field and expense food expense
                        Expense.Food_Expenses__c = Expense.Food_Expenses__c - expt.Expense_Amount__c;
                   
                    else
    
                        //Update the value into the food expense field
                        Expense.Food_Expenses__c = expt.Expense_Amount__c;
                }
            }
        }
    }
}