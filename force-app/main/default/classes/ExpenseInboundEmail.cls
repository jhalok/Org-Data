/**
*   Description     :	This class is used to insert the expense item using inbound email
*
*   Created by      :	Alok kumar
*
*   Created Date    :   08/08/2018
*
*   Revision Log    :   V1.0 - Created
*
**/

global class ExpenseInboundEmail implements Messaging.InboundEmailHandler {
    
    List<Expense_Item__c> expItemList = new List<Expense_Item__c>(); 
    
        
    /**
    *  @description    :   This method is used to save the records in expense item 
    *
    *  @args           :   List of expense type
    *
    *  @return         :   List of expense type
    * 
    *  @revision Logs  :   V1.0 -- Created
    *
    **/    
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env) {
        
        //initialize of Messaging.InboundEmailResult
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        //String to store filedata
        String stringForFileData;
        
        //variable to store subject of email
        String subject;
        
        ExpenseInboundEmail classInstance = new ExpenseInboundEmail();
        
        //Get subject from mail
        subject = email.subject;
        
        //condition to check the subject of mail
        if(subject.equalsIgnoreCase('Expense Details')){
            
            //used to handle query Exception
            try{
                
                //used to get the data from attachment
                for(Messaging.Inboundemail.BinaryAttachment binAttachment : email.binaryAttachments) {
                    
                   //Insert the data in string
                   stringForFileData = binAttachment.body.toString();
                }    
                    
                    //call another method and store its return value in list of expense item type 
                   expItemList =  classInstance.readFile(stringForFileData);
                
                //dml for inserting the record in expense item
                database.insert(expItemList);
            }catch(QueryException e){
                
            }
        }
        
        return result;
    }
        
        /**
    *  @description    :   This method is used to save the records in expense item object 
    *
    *  @args           :   List of expense type
    *
    *  @return         :   List of expense type
    * 
    *  @revision Logs  :   V1.0 - Created
    *
    **/    
    
    public List<Expense_Item__c> readFile(String stringForFileData) {
        
        
        //string array to store the list of string in single line
        String[] fileLines;
         
        List<Member__c> members = new List<Member__c>();
        
        //list of expense object
        List<Expense__c> expenses = new List<Expense__c>();
        List<Expense__c> expensesMonthly = new List<Expense__c>();
        
        //store data in array of string
        fileLines = stringForFileData.split('\n');
        
        //Query to retrieve id of member, house and person from member
        members = [Select Id,House__r.Name,Person__r.Name from Member__c];
        
        //Query to retrieve id and date fro expense where type is monthly
        expenses=[Select Id ,Date__c,Member__c from Expense__c where Type__c = 'Yearly'];
               
        expensesMonthly=[Select Id ,Date__c,Yearly_Expense__c from Expense__c where Type__c = 'Monthly'];
         
        //variables of id datatype
        Id membersId , expenseYearlyId, expenseMonthlyId;
        
        //loop till the number of lines in csv file
        for (Integer i=1;i<filelines.size();i++) {
            
            //String type array to gather short name in expense of type monthly
            String[] monthArray = new String[]{' ','JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'};
                
                // list of expense item used to hold all the required field of expense type yearly    
                List<Expense__c> expenseYearlyToInsert = new List<Expense__c>();
            
            // list of expense item used to hold all the required field of expense type monthly
            List<Expense__c> expenseMonthlyToInsert = new List<Expense__c>();  
            
            //Reinitialize the values
            membersId=null;
            expenseYearlyId=null;
            expenseMonthlyId=null;
            
            //array of string
            String[] inputvalues = new String[]{};  
                
                //store data by comma seperated
                inputvalues = filelines[i].split(',');
             
            //variable of object expense item type to hold all field value and than insert in list
            Expense_Item__c expItem = new Expense_Item__c();
            
            //variable of object expense type to hold all field value and than insert in list
            Expense__c expMonthly = new Expense__c();
            Expense__c expYearly = new Expense__c();
            
            //variable of type date to hold the date value from csv file
            Date d = date.valueOf(inputvalues[0]);
   
            //iteration with respect to member records
            for(Member__c member: members){
                
                
                //Trim used to remove spaces from before and after string 
                String memHouse = member.House__r.Name;               
                String memPerson = member.Person__r.Name;               
                String inputHouse = inputvalues[4];                
                String inputPerson = inputvalues[3];
               
                //condition to retrieve id of member if house and person both are same
                if(memHouse==inputHouse && memPerson==inputPerson) {
                    membersId = member.Id;
                    break;
                }
            }
            //iteration on expense
            for(Expense__c expe : expenses) {
                
                //condition to match year of date given in file if true retrieve data
                if(expe.Date__c != null && expe.Date__c.year()==d.year() && expe.Member__c == membersId) {
                    expenseYearlyId = expe.Id;
                    break;
                }
            }
            //condition to check yearly expense exist or not 
            if(expenseYearlyId != null) {
                
                //iteration with respect to expense
                for(Expense__c expe : expensesMonthly) {
            
                    //condition to match month and year of date given in file if true retrieve data
                    if(expe.Date__c != null && expe.Date__c.month()==d.month() && expe.Date__c.year()==d.year() && expe.Yearly_Expense__c == expenseYearlyId) {
                        expenseMonthlyId = expe.Id;
                        break;
                    }
                }
                //if yearly and monthly expense are already present
                if(expenseMonthlyId != null) {
                    
                    //directly assign the id in expense field of expense item
                    expItem.Expense__c = expenseMonthlyId; 
                }
                //if monthly record not exist
                else {
                    
                    //insert the monthly record required fields
                    expMonthly.Type__c = 'Monthly';
                    expMonthly.Client__c = 'Abc';
                    expMonthly.Yearly_Expense__c = expenseYearlyId;
                    expMonthly.Name = 'abc';
                    
                    expMonthly.Date__c = Date.valueOf(inputvalues[0]);
                    expMonthly.Member__c = membersId;
                    String dateForShort = monthArray[d.month()];
                    expMonthly.Short_Name__c = dateForShort; 
                    expMonthly.Total_Balance__c = 50000;
                    expMonthly.Food_Expenses__c = 0;
                    expMonthly.Fuel_Expenses__c = 0;
                    expMonthly.Other_Expenses__c= 0;
                    expMonthly.Total_Expense__c = 0;
                    
                    //add those values in expense list
                    expenseMonthlyToInsert.add(expMonthly);
                    
                    //call another method for insert monthly record and get id of expense monthly
                    List<Expense__c> expId = saveMonthlyRecord(expenseMonthlyToInsert);
                    //iterate list to get expense id for expense item
                    for(Expense__c e :  expId) {
                        
                        expItem.Expense__c = e.Id;
                    }
                }
            }
            //if expense of type yearly not exist
            else {
                
                //insert all required fields in variable of expense type 
                expYearly.Name = 'july';
                expYearly.Member__c = membersId;
                expYearly.Short_Name__c = String.valueOf(d.year());
                expYearly.Type__c = 'Yearly';
                expYearly.Client__c = 'Alok';
                expYearly.Date__c = Date.valueOf(inputvalues[0]);
                expYearly.Food_Expenses__c = 0;
                expYearly.Fuel_Expenses__c =0;
                expYearly.Other_Expenses__c = 0;
                expYearly.Total_Balance__c = 50000;
                
                expMonthly.Name = 'july1';
                expMonthly.Date__c = Date.valueOf(inputvalues[0]);
                expMonthly.Type__c = 'Monthly';
                String dateForShort = monthArray[d.month()];
                expMonthly.Short_Name__c = dateForShort;
                expMonthly.Member__c = membersId;
                expMonthly.Client__c = 'Alok2';
                expMonthly.Food_Expenses__c = 0;
                expMonthly.Fuel_Expenses__c = 0;
                expMonthly.Other_Expenses__c = 0;
                expMonthly.Total_Expense__c = 0;
                expMonthly.Total_Balance__c = 50000;
                //add those values in list
                expenseYearlyToInsert.add(expYearly);
                
                //call another method for insert yearly record and get id of expense yearly
                List<Expense__c> expId = saveYearlyRecord(expenseYearlyToInsert);
               
                //iterate list to get expense id for expense of type monthly
                for(Expense__c e :  expId){
                    
                    //insert that value in yearly expense field
                    expMonthly.Yearly_Expense__c = e.Id;
                   
                }                
                
                //insert all those value in list
                expenseMonthlyToInsert.add(expMonthly);
                
                //call another method for insert monthly record and get id of expense monthly
                List<Expense__c> expIdMonth = saveMonthlyRecord(expenseMonthlyToInsert);
              
                //iterate list to get expense id of type monthly for expense item
                for(Expense__c e :  expIdMonth) {
                    
                    //insert that value in  expense item expense__c field
                    expItem.Expense__c = e.Id;
                    
                }                                
            }
            //insert all the required data of expense item
            expItem.Bill_Number__c = inputvalues[5];           
            expItem.Date__c = Date.valueOf(inputvalues[0]);         
            expItem.Expense_Amount__c = Decimal.valueOf(inputvalues[1]);         
            expItem.Description__c = inputvalues[2];
            expItem.Expense_Type__c = inputvalues[2];
         
            //insert all those value in list
            expItemList.add(expItem);
           
        }

        //return that list in the method where it get call
        return expItemList;	
    }
    
        /**
    *  @description    :   this method use to save expense of type monthly and return the list that contain id of new monthly record. 
    *
    *  @args           :   List of expense type
    *
    *  @return         :   List of expense type
    * 
    *  @revision Logs  :   V1.0 - Created
    *
    **/ 
    
    public List<Expense__c> saveMonthlyRecord(List<Expense__c> listForInsertMonthly) {
        
        //variable of type string
        String  shortName;
        
        //variable of type Id
        Id memId, yearlyExpenseId;
        
        //List of type expense
        List <Expense__c> expId = new List <Expense__c>();
        
        //iterate the list get from calling method for retrieving member id,yearly expense id and short name
        for(Expense__c exp : listForInsertMonthly) {
            
            memId = exp.Member__c;
            yearlyExpenseId = exp.Yearly_Expense__c;        
            shortName = exp.Short_Name__c;           
        }   
      
        //insert monthly expense record
        if(listForInsertMonthly.size()>0) {                       
            insert listForInsertMonthly;
        }
        	
        //query for retrieving Id
        expId = [Select Id from Expense__c where Member__c =: memId AND Yearly_Expense__c =: yearlyExpenseId AND Type__c = 'Monthly'];
       
        //return that list to the calling function
        return expId;
    }
    
        /**
    *  @description    :   this method use to save expense of type monthly and return the list that contain id of new yearly record. 
    *
    *  @args           :   List of expense type
    *
    *  @return         :   List of expense type
    * 
    *  @revision Logs  :   V1.0 - Created
    *
    **/    
    public List<Expense__c> saveYearlyRecord(List<Expense__c> listForInsertYearly) {
        
        //variable of type string
        String  shortName;
        
        //variable of type Id
        Id memId;
        
        //List of type expense
        List <Expense__c> expId = new List <Expense__c>();
        
        //iterate the list get from calling method for retrieving member id and short name
        for(Expense__c e : listForInsertYearly) {
            
            memId = e.Member__c;          
            shortName = e.Short_Name__c;            
        }  
         
        //insert yearly expense record
        if(listForInsertYearly.size()>0) {
            insert listForInsertYearly;
        }
        
        //query for retrieving Id
        expId = [Select Id from Expense__c where Member__c =: memId AND Short_Name__c =: shortName And Type__c = 'Yearly'];
        //return that list to the calling function
        return expId;
    }    
}