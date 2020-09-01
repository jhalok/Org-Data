trigger SendEmailOnCase on Case (after insert) {
   /* Set<Id> caseIds = new Set<Id>();
    Set<Id> emailMsgIds = new Set<Id>();
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    for (Case c: trigger.old) {
        if(c.status == 'closed'){
            caseIds.add(c.Id);
        }
    }
    Map<Id, Case> conMap = new Map<Id, Case>([SELECT Id, status, OwnerId, SuppliedEmail, (SELECT id, ParentId FROM EmailMessages) FROM Case WHERE Status ='closed']);
    System.debug('---conMap---'+conMap);
    
        for (Case c : trigger.old) {
            if (c.status == 'Closed') {
                Case relatedCaseContact = conMap.get(c.Id);
                System.debug('relatedCaseContact---'+relatedCaseContact);
                //System.debug('---conMap ParentId---'+conMap.get(c.ParentId));
                Messaging.SingleEmailMessage CaseNotificationmail = new Messaging.SingleEmailMessage();  
                CaseNotificationmail.setToAddresses(new List<String> { relatedCaseContact.SuppliedEmail });
                CaseNotificationmail.setReplyTo('alok.akjha@gmail.com');
                CaseNotificationmail.setSenderDisplayName('Salesforce');            
                
                CaseNotificationmail.setSubject(' Case Status updation : ' + 'Changed to ' + c.status + '. Case Number:' + c.CaseNumber);
                CaseNotificationmail.setPlainTextBody('Your case Status for Case Number: ' + c.CaseNumber + ' has been closed'); 
                mails.add(CaseNotificationmail); 
            }
        }
    Messaging.sendEmail(mails); */
}