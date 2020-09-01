trigger AccountContactCrt on Account (after insert){ 
    if(Trigger.isInsert){
        
        List<Contact> ct = new List <Contact>();
        
        for(Account acc : trigger.new){
            for(integer i = 0; i <2; i++){
            Contact c = new Contact(LastName = acc.name + i,
                                    AccountId=acc.id,
                                    Fax=acc.Fax,
                                    MailingStreet=acc.BillingStreet,
                                    MailingCity=acc.BillingCity,
                                    /* similarly add all fields which you want */
                                    MailingState=acc.BillingState,
                                    MailingPostalCode=acc.BillingPostalCode,
                                    MailingCountry=acc.BillingCountry,
                                    Phone=acc.Phone);
            
            ct.add(c);    
            }
        }
        insert ct; 
    }
}