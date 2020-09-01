/**
* 
* Description   - This class is used to check unique bill number
*
* Created By    - Alok kumar
* 
* Created Date  - 20/07/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/
public without sharing class ExpenseItemTriggerHelper {
    
    /**
* 
* @description  - checkforDuplicateBillNumber() is checking if the Expense_item is having duplicate bill number or not
*
* @return       - null
* 
*/
    
    //List to store the new data enterd by user and 
    public static void checkforDuplicateBillNumber(List<Expense_Item__c> newExpenseItems , Map<Id, Expense_Item__c> oldMapExpenseItem){
        System.debug(newExpenseItems);
        System.debug(oldMapExpenseItem);
       
        //Map Of String with Expense
        Map<String, Id> mapOfBillNoWithExpense = new Map<String, Id>();
        List<String> expenseList = new List<String>();
        System.debug(mapOfBillNoWithExpense);
        
        //Iterating new data entered by user in Expense_item and adding it's id into the set
        for(Expense_Item__c expRecord :  newExpenseItems ){
            
            //Check for insert and update
            if( expRecord.Bill_Number__c != null && expRecord != null && 
               (oldMapExpenseItem == null || (expRecord.Bill_Number__c != oldMapExpenseItem.get(expRecord.Id).Bill_Number__c || expRecord.Expense__c != oldMapExpenseItem.get(expRecord.Id).Expense__c))) {
                   
                   expenseList.add(expRecord.Expense__c);
                   //Check for the bill number exists or not using contains key  
                   if(! mapOfBillNoWithExpense.containsKey(expRecord.Bill_Number__c)) 
                       
                       //If the bill_number doesn't exists add it to the map key as a Bill_Number__c and value as a Expense__c
                       mapOfBillNoWithExpense.put(expRecord.Bill_Number__c, expRecord.Expense__c);
                   else
                       //Error message to be displayed on the field
                       expRecord.Bill_Number__c.addError('Duplicate Bill no cant be stored, Please enter unique bill number');   
                   
               }
        }
        
        //Condition to check that Expense exists or not
        if(mapOfBillNoWithExpense.size() > 0) {
            
            //List to fetch the records from Expense_item__c
            List<Expense_Item__c> expenseItems = [SELECT Bill_Number__c, Expense__c FROM Expense_Item__c Where Expense__c IN :mapOfBillNoWithExpense.values()];
            
            //Condition to check for expenseItems is having subitems or not
            if(expenseItems.size() > 0) { 
                
                //Iteration of list Having new data
                for(Expense_Item__c expenseItem : expenseItems ){
                    
                    //Condition to check that bill is already existing or not
                    if(mapOfBillNoWithExpense.containsKey(expenseItem.Bill_Number__c)){
                        
                        //Error to be displayed if the bill number already exist 
                        newExpenseItems[0].Bill_Number__c.addError('Please enter unique Bill number');   
                    }
                }
            }
        }
    }
    
    
/**
* 
* @description  -  UpdateExpense() is used to update the expenses amount according to the type selected
*
* @return       -  Void
* 
*/
    
    public static void UpdateExpense( List<Expense_Item__c> newexpenseItems, Map<Id,Expense_Item__c> oldMapExpenseItem) {
        
        //Initilization of Map to store the Expense data
        Map<Id,Expense__c> expenseMap = new Map<Id,Expense__c>();
        System.debug( newexpenseItems);
        System.debug(oldMapExpenseItem);
        
        //Conditional operator to iterate the loop according to the condition
        for( Expense_Item__c expenseItem : newexpenseItems != null ? newexpenseItems : oldMapExpenseItem.values()) {
            
            //Condition to check all blank update
            if((oldMapExpenseItem == null ||( expenseItem.Expense_Amount__c != oldMapExpenseItem.get(expenseItem.Id).Expense_Amount__c  ||oldMapExpenseItem != null || expenseItem.Expense_Type__c != oldMapExpenseItem.get(expenseItem.Id).Expense_Type__c)  || expenseItem.Expense__c != oldMapExpenseItem.get(expenseItem.Id).Expense__c))
                
                //put the data in map corresponding to id
                expenseMap.put( expenseItem.Expense__c, new Expense__c ( Id = expenseItem.Expense__c, Food_Expenses__c = 0, Other_Expenses__c = 0, Total_Expense__c = 0, Fuel_Expenses__c = 0 )); 
        }
        
        //Aggregate Query to fetch Expense Amount according to the type
        for(AggregateResult agrgtresult : [Select Expense__c expId, SUM(Expense_Amount__c) expAmount, Expense_Type__c expType From Expense_Item__c Where Expense__c IN : expenseMap.keyset() GROUP BY Expense__c,Expense_Type__c]) {  
            
            //Condition to check map is empty or not
            if(expenseMap.size() > 0 ) {
                
                //Getting the expense id 
                Expense__c expense = expenseMap.get((Id)agrgtresult.get('expId'));
                
                //Condition to check if expense item type is Food
                If(agrgtresult.get('expType') =='Food') {
                    
                    //Showing the expAmount of food on the field Food_Expenses__c
                    expense.Food_Expenses__c =(Decimal)agrgtresult.get('expAmount');
                }
                //Condition to check expense item type is fuel
                else if(agrgtresult.get('expType') == 'Fuel') {
                    
                    //Showing the expAmount of fuel on the field Fuel_Expenses__c
                    expense.Fuel_Expenses__c =(Decimal)agrgtresult.get('expAmount');
                }
                
                //Condition to check if expense item type is rather then food or fuel
                else if(agrgtresult.get('expType') =='Other' || agrgtresult.get('expType') =='Rent' || agrgtresult.get('expType') =='Clothes' ) {
                    
                    //Showing the expAmount of fuel on the field Other_Expenses__c
                    expense.Other_Expenses__c =(Decimal)agrgtresult.get('expAmount');
                }
                
                //Total expense to be displayed according to the total of food ,Fuel and 
                expense.Total_Expense__c = expense.Fuel_Expenses__c + expense.Other_Expenses__c + expense.Food_Expenses__c;
                
                //putting the expense data in expenseMap
                expenseMap.put((Id)agrgtresult.get('expId'), expense);
            } 
        } 
        //Condition to perform update
        if( expenseMap != null && expenseMap.size() > 0 ) 
            update expenseMap.values();   
    } 
}