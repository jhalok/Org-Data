public with sharing class ListOfObjects {
	
	Map<String,Schema.SObjectType> m= Schema.getGlobalDescribe();
    
    Schema.SObjectType s = m.get('Accounts');
    Schema.DescribeSObjectResult r = s.getDescribe();
    
    Map<String,Schema.SObjectField> fields = r.fields.getMap();
    
}