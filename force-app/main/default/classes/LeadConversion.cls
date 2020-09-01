public class LeadConversion {
    
    public static void onLeadConversion(LIST<Lead> convertedLeads) {

		SET<ID> leadId = new SET<ID>();
		SET<ID> accId = new SET<ID>();
		SET<ID> oppId = new SET<ID>();

		//<lead id,Opportunity id>
		MAP<String, String> leadIdOpp = new MAP<String, String>();
		MAP<String, String> leadIdAcc = new MAP<String, String>();


		for(Lead lead :convertedLeads) {
			leadIdOpp.put(lead.id, lead.convertedOpportunityId);
			leadIdAcc.put(lead.id, lead.convertedAccountId);
			leadId.add(lead.id);

			accId.add(lead.convertedAccountId);
			oppId.add(lead.convertedOpportunityId);

			System.debug('oppId is ' + lead.convertedOpportunityId);
		}
		MAP<ID, Account> accIdMap = new MAP<ID, Account>([SELECT ID, Type, Name FROM ACCOUNT WHERE ID IN :leadIdAcc.keySet()]);
        System.debug('accIdMap is ' + accIdMap);
		MAP<ID, Opportunity> oppIdMap = new MAP<ID, Opportunity>([SELECT ID FROM Opportunity WHERE ID IN :oppId]);
		System.debug('oppIdMap is ' + oppIdMap);
		
	}
}