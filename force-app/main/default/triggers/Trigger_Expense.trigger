/**
* 
* Description   - This class is used to provide the old existing expense record 
*
* Created By    - Alok kumar
* 
* Created Date  - 20/07/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/
trigger Trigger_Expense on Expense__c(before delete, after insert, after update, after delete) {
    
    //Checking the condition to fire triger 
    if (Trigger.isBefore) {
        
        //Check the condition to fire trigger
        if (Trigger.isdelete) {
            
            //Calling the static method of DeleteAllExpenseTrigger,Passing the Trigger.old to provide the existing data
            ExpenseTriggerHelper.doNotDeleteExpense(Trigger.old);
        }
    }
    
    //Condition to fire the triger if it is after
    if(Trigger.isAfter){
        
        //Condition to update the trigger
        if(Trigger.isUpdate){
            
            //Calling the expenseUpdate static method to provide new & old data
            ExpenseTriggerHelper.expenseUpdate(Trigger.new,Trigger.oldMap);
        }
    }
}