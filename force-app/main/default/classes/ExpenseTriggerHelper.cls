/**
* 
* Description   - This class of trigger is used to delete the the Expense if the Expense_item does not exist for the Expense 
*
* Created By    - Alok kumar
* 
* Created Date  - 20/07/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/
public without Sharing class ExpenseTriggerHelper{
    
    /**
* 
* @description  -  doNotDeleteExpense() checks that Expense is having Sub Expense then record will not get deleted
*
* @return       -  Void
* 
*/
    public static void doNotDeleteExpense(List<Expense__c> oldExpenses){
        //System.debug(oldExpenses);
        //Check for expense
        if(oldExpenses.size() > 0 ){
            
            //Initilization of set to add the id 
            Set<Id> setOfExpenseId = new Set<Id>();
            
            //Iterating the old data stored in ExpenseRecord
            for(Expense__c expData :  oldExpenses)  {
                
                //Adding the expense Id to the set
                setOfExpenseId.add(expData.Id);  
            } 
            
            //Iteration of Expense data to fetch that main expense is having sub expenses or not
            for(Expense__c expFetchedData :  [Select Id, (Select Id from Expense_Items__r LIMIT 1) from  Expense__c where Id in : setOfExpenseId]) {
                
                //Getting the id in epxItr.Id of the Expense which we want to delete & checking that it is having subexpenses or not
                if(expFetchedData.Expense_Items__r.size() > 0){
                    
                    //Showing the error message When a Expense is having sub expense
                    oldExpenses[0].addError('Expense cant be deleted, because Expense is having sub Expenses');
                }
            }         
        }  
    }
    
    /**
* 
* @description  -  expenseUpdate() is used to update the expense
*
* @return       -  Void
* 
*/
    public static void expenseUpdate(List<Expense__c> newExpenses, Map<Id,Expense__c> oldMapExpenses) {
        
        //Map to store the Expenses corresponding to the id 
        Map<ID, Expense__c> mapOfExpenses = new Map <ID, Expense__c>();
        
        //Instance of Expense
        Expense__c expn = new Expense__c();
        
        //Iterate the new expense list
        for(Expense__c expns : newExpenses) {
            
            //Check if expense type is yearly or monthly
            if(expns.Yearly_Expense__c != null  && ( expns.Type__c == 'Monthly') && (oldMapExpenses == null || expns.Total_Expense__c!= oldMapExpenses.get(expns.Id).Total_Expense__c))
                
                //Putting the value in Map
                mapOfExpenses.put(expns.Yearly_Expense__c,new Expense__c(id = expns.Yearly_Expense__c,Other_Expenses__c =0,Fuel_Expenses__c =0,Food_Expenses__c=0));
        }
        //Aggregate query to calculate the total expense of food fuel and other type  
        List<AggregateResult> aggregateExpenses  = [SELECT Yearly_Expense__c yearlyExpId, Sum(Food_Expenses__c) foodAmount, Sum(Fuel_Expenses__c) fuelAmount,
                                                    Sum(Other_Expenses__c) otherAmount, Sum(Total_Expense__c) totalAmount FROM Expense__c
                                                    WHERE Yearly_Expense__c IN : mapOfExpenses.keySet() Group by Yearly_Expense__c];
        
        //Calculate the sum according to the type
        for(AggregateResult  result : aggregateExpenses) {
            
            expn = mapOfExpenses.get((Id)result.get('yearlyExpId'));
            expn.id=(id)result.get('yearlyExpId');
            expn.Food_Expenses__c  =(decimal)result.get('foodAmount');
            expn.Fuel_Expenses__c =(decimal)result.get('fuelAmount');
            expn.Other_Expenses__c =(decimal)result.get('otherAmount');
            expn.Total_Expense__c  =(decimal)result.get('totalAmount');
            mapOfExpenses.put((id)result.get('yearlyExpId'),expn);
        }
        //Updating the map
        update mapOfExpenses.values();
    }
}