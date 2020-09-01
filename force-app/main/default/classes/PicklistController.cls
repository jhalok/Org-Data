public class PicklistController {
	
    @AuraEnabled        
    public static List<String> getPickListValuesIntoList(){
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get('Opportunity');
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get('Stage').getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        System.debug('hiii'+pickListValuesList);
        return pickListValuesList;
    }
}