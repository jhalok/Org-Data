global class DailyLeadProcessor implements Schedulable {

    global void execute(SchedulableContext ctx) {
        List<Lead> lList = [Select Id, LeadSource from Lead where LeadSource = null];
        
        if(!lList.isEmpty()) {
			for(Lead l: lList) {
				l.LeadSource = 'Dreamforce';
			}
			update lList;
		}
    }
}