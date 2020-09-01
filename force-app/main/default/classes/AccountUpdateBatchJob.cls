global class AccountUpdateBatchJob implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id,Name FROM Account';
       
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        for(Account a : scope)
        {
            a.Name = a.Name + 'Updated by Batch job';
        }
        update scope;
    }
    global void finish(Database.BatchableContext BC)
    {
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email    from AsyncApexJob where Id =:BC.getJobId()];
      
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Match Merge Batch ' + a.Status);
        mail.setPlainTextBody('records processed ' + a.TotalJobItems +   'with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}