public class KanbanView {
    
    public static List<SelectOption> getPickListValues()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }   
}