public class sendEmail {
    
    public static void sendNotification(List<EmailMessage> emailData){
        Set<Id> caseIds = new Set<Id>();
        Set<Id> emailMsgIds = new Set<Id>();
        Set<String> emailIdntfr = new Set<String>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage CaseNotificationmail = new Messaging.SingleEmailMessage();  
        for (EmailMessage c: emailData) {
            caseIds.add(c.Id);
            emailMsgIds.add(c.ParentId);
            emailIdntfr.add(c.ThreadIdentifier);
        }
        System.debug('------caseIds'+caseIds);
        System.debug('----prntId'+emailMsgIds);
        List<Case> caseData = [Select Id, Status, CaseNumber, FormualThreadId__c, SuppliedEmail From Case Where Id In :emailMsgIds];
        System.debug('caseData---------'+caseData);
        
        for(Case eMsg : caseData){
            if(eMsg.Status == 'closed'){
                System.debug('---caseNumber---'+eMsg.CaseNumber+ '-----SuppliedEmail'+eMsg.SuppliedEmail);
                CaseNotificationmail.setToAddresses(new List<String> { eMsg.SuppliedEmail });
                //CaseNotificationmail.setReplyTo('alok.akjha@gmail.com');
                CaseNotificationmail.setSenderDisplayName('no-replay');            
                CaseNotificationmail.setSubject(' Case Status: ' + 'Changed to ' + eMsg.status + '. Case Number:' + eMsg.CaseNumber +
                                                '. Case ThreadId:'+eMsg.FormualThreadId__c);
                CaseNotificationmail.setPlainTextBody('\n Your case Status for Case Number: ' + eMsg.CaseNumber + 
                                                      ' has been closed \n Please login to below mentioned link to check your closed case. \n https://lightdevlopment-dev-ed.my.salesforce.com/'+eMsg.Id); 
                mails.add(CaseNotificationmail); 
            }
        }                    
        Messaging.sendEmail(mails);
    }   
}