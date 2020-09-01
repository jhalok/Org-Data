global class LeadProcessor implements Database.Batchable<sobject>,Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('select id,LeadSource from Lead');
    }
    
    global void execute(Database.BatchableContext bc,List<Lead> scope){
        List<Lead> leadData = new List<Lead>();
        for(Lead ld : scope){
            ld.LeadSource = 'Dreamforce';
            leadData.add(ld);
        }
        update leadData;
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}