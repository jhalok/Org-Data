global class ContactApprovalStatus_Batch implements Database.Batchable<sObject>,Database.Stateful{
    
    global List<Contact> lstOfCont = new List<Contact>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select id,name,CreatedDate ,Approval_Status__c from Contact Where Approval_Status__c=\'Ready for Approval\' and CreatedDate = TODAY'; 
            //'Select id,name,CreatedDate ,Approval_Status__c from Contact';
        system.debug('query    '+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){   
        for(Contact con : scope){
            if(con.Approval_Status__c == 'Ready for Approval'){
                lstOfCont.add(con);
            }
        }
        System.debug('lstOfCont in execute() ------- '+lstOfCont);
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug('lstOfCont in Finish() ------- '+lstOfCont);
        //List<Contact> conlist = [Select name,CreatedDate ,Approval_Status__c from Contact Where Approval_Status__c ='Ready for Approval' and createdDate = TODAY];
        string header = 'Name , Created Date, Approval Status \n';
        string totalData = header ;
        for(Contact conData: lstOfCont){
            string recordString = '"'+conData.Name+'","'+conData.CreatedDate+'","'+conData.Approval_Status__c +'"\n';
            totalData = totalData +recordString;
        }
        Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(totalData);
        csvAttachment.setFileName('ListofContactsForApproval.csv');
        csvAttachment.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {'alok.akjha@gmail.com'};
        //String subject ='Contact Approval Status';
        email.setSubject('Contact Approval Status');
        email.setToAddresses( toAddresses );
        email.setPlainTextBody('Contact Data With Ready For Approval Status');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
       	Messaging.SendEmailResult [] sndMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
    }
}