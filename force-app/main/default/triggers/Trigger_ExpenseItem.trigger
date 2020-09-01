/**
*   Description     :  This is a before trigger for check all the criteria before save in database.
*
*   Created by      :   Alok Kumar
*
*   Created Date    :   20/07/2018
*
*   Revision Log    :   V1.0 - Created
*
**/
trigger Trigger_ExpenseItem on Expense_Item__c (before insert,before update,after insert,after update,after delete ,before delete, after undelete) {
    
    //condition to check trigger work in before 
    if(Trigger.isBefore){
       /* System.debug(Trigger.isInsert);
        System.debug(Trigger.isUpdate);
        System.debug(Trigger.isDelete); */
        //condition to check trigger work in insert or update 
        if(Trigger.isInsert || Trigger.isUpdate ){
           /* System.debug('Trigger isBefore');
            System.debug(Trigger.new);
            System.debug(Trigger.old);
            System.debug(Trigger.newMap);
            System.debug(Trigger.oldMap);*/
            //Condition to call uniqueBillNumber having new data
            ExpenseItemTriggerHelper.checkforDuplicateBillNumber(Trigger.new , Trigger.oldMap);
        } 
    }
    //Condition to check trigger work in after
    else if (Trigger.isAfter){
        
        //Condition to check trigger work in insert update delete
        if(Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete || Trigger.isUndelete){
          /*   System.debug('Trigger isAfter');
            System.debug(Trigger.new);
            System.debug(Trigger.old);
            System.debug(Trigger.newMap);
            System.debug(Trigger.oldMap);
            Condition to call updateExpense having olddata */
            ExpenseItemTriggerHelper.UpdateExpense(Trigger.new, Trigger.oldMap);
        }
    }
}