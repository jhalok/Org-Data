/*******************************************************************************************************@@
Class Name     :  Batch_EloquaDupeConCleanup
Purpose        :  Delete contacts with LastModifiedDates are 30 days older. 
History:
-------
VERSION  AUTHOR                 DATE                DETAIL                      TICKET REFERENCE/ NO.
1.       Anant Sharma           06/08/20          	Original Version            
*********************************************************************************************************/
global class Batch_DeleteContact implements Database.Batchable<sObject>{
    
    global Batch_DeleteContact(){
       
    }
 
    global Database.QueryLocator start(Database.BatchableContext BC){
		String numberOfDaysOld = '30';
        String name = 'Rose';
       	String query = 'SELECT Id, Name, LastModifiedDate FROM Contact WHERE FirstName =\''+ name +'\' AND LastModifiedDate < LAST_N_DAYS:' + numberOfDaysOld;
        System.debug('query'+query);
        //System.debug(Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact>scope){
        if(scope.size() > 0){
            System.debug('scope'+scope);
            //delete scope;
        }
    }
    
    global void finish(Database.BatchableContext BC){
   
    }
}