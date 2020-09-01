global class ContactApprovalStatus implements Database.Batchable<sObject> {
	
    global List<Contact> lstOfCont = new List<Contact>();

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator('SELECT Id,Name,Approval_Status__c FROM Contact');
    }
    global void execute(Database.BatchableContext BC, List<Contact> scope)
    {   
        for(Contact con : scope)
        {
            if(con.Approval_Status__c == 'Ready for Approval'){
                lstOfCont.add(con);
            }
        }
        System.debug('lstOfCont  ------- '+lstOfCont);
    }
    global void finish(Database.BatchableContext BC)
    {
        AsyncApexJob a = [Select Id,Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email    from AsyncApexJob where Id =:BC.getJobId()];    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Contact Approval Status' + a.Status);
        mail.setPlainTextBody('records processed ' + a.TotalJobItems +   'with '+ a.NumberOfErrors + ' failures.' );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }
}