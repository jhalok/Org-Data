public with sharing class CaseCreateController {
    
	//init method to fetch initial records
    @AuraEnabled(cacheable=true)
    public static DataTableWrapper fetchRecords(String ObjectName, String fieldNamesStr, String recordId, String Orderby, String OrderDir, boolean inlineEdit, boolean enableColAction) {
        
        DataTableWrapper dtw = new DataTableWrapper();
        List<LabelDescriptionWrapper> labelList = new List<LabelDescriptionWrapper>();
        System.debug('Order by-----'+Orderby+'-----objectName-----'+ObjectName+'---fieldNamesStr----'+fieldNamesStr);
        List<String> fieldSet = new List<String>();
        System.debug(fieldNamesStr);
        Set<String> fieldNameSet = new Set<String>(fieldNamesStr.split(','));
        System.debug('splitted field values-----'+fieldNameSet);
        if(Schema.getGlobalDescribe().containsKey(ObjectName) ) {
            sObject sObj = Schema.getGlobalDescribe().get(ObjectName).newSObject() ;
            System.debug('sobj describe---'+sObj);
            //get all the labels for Opportunity fields and put them in a map, keyed to the field api name
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap();
            System.debug('fieldMap------'+fieldMap);
            Map<Schema.SObjectField,String> fieldToAPIName = new Map<Schema.SObjectField,String>();
            System.debug('fieldToAPIName------'+fieldToAPIName);
            Map<String, String> apiNameToLabel = new Map<String, String>();
            //Iteration on splitted passed fieldNames to check that passed parameter field values exist in the 
            for(String fieldName :  fieldNameSet){
                //Now checking the splited values matched with the objects fields in the FIELDMAP list or not 
                if(fieldMap.containsKey(fieldName)) {
                    fieldSet.add(fieldName);
                    System.debug('Unique fields in the set for current obj'+fieldSet);
                    labelList.add(new LabelDescriptionWrapper(fieldMap.get(fieldName).getDescribe().getLabel(), fieldName, fieldMap.get(fieldName).getDescribe().getType().name().toLowerCase(), true, inlineEdit, null  ));
                    System.debug('1---'+fieldMap.get(fieldName).getDescribe().getLabel());
                    System.debug('2-----'+fieldName);
                    System.debug('3------'+fieldMap.get(fieldName).getDescribe().getType().name().toLowerCase());
                }
            }
           
			System.debug('labelList-------'+labelList);
            if(enableColAction) {
                List<Actions> actionList = new List<Actions>();
                actionList.add(new Actions('Edit','edit'));
                actionList.add(new Actions('View','view'));
                actionList.add(new Actions('Delete','delete'));
                TypeAttributes tAttribute = new TypeAttributes(actionList);
                System.debug('typeAttributes-----'+tAttribute);
                labelList.add(new LabelDescriptionWrapper('', '', 'action', false, false, tAttribute ));
            }
            //call method to query
            List<sObject> sObjectRecords = getsObjectRecords(ObjectName, fieldSet, 50, recordId, Orderby, OrderDir);
            System.debug('recordId---------'+recordId);
            dtw.ldwList 	= labelList;
            dtw.sobList 	= sObjectRecords;
            dtw.fieldsList 	= fieldSet;
            dtw.totalCount  = Database.countQuery('SELECT count() FROM '+ObjectName);
        }
        System.debug('-----return data-----'+dtw);
        return dtw;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<sObject> getsObjectRecords(String ObjectName, List<String> fieldNameSet, Integer LimitSize, String recId, String Orderby, String OrderDir) {
        OrderDir = String.isBlank(OrderDir) ? 'ASC' : OrderDir;
        String query = 'SELECT '+String.join(fieldNameSet, ',')+'  FROM '+ObjectName;
        if(String.isNotBlank(recId)) {
            recId = String.valueOf(recId);
            query += ' WHERE ID >: recId ';
        }
        query += ' ORDER BY '+Orderby+' '+OrderDir+' NULLS LAST';
        if(LimitSize != null && Integer.valueOf(LimitSize) > 0) {
            LimitSize = Integer.valueOf(LimitSize);
            query += ' Limit '+LimitSize;
        }
        return Database.query(query);    
    }

	
	//wrapper class for data table
    public class DataTableWrapper {
        @AuraEnabled
        public List<LabelDescriptionWrapper> ldwList;
        @AuraEnabled
        public List<sObject> sobList;
        @AuraEnabled
        public List<String> fieldsList;
        @AuraEnabled
        public Integer totalCount;
    }

	//Wrapper class to store Field details
    public class LabelDescriptionWrapper {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public boolean sortable;
        @AuraEnabled
        public boolean editable;
        @AuraEnabled
        public TypeAttributes typeAttributes;
        
        public LabelDescriptionWrapper(String labelTemp, String fieldNameTemp, String typeTemp, boolean sortableTemp, boolean editableTemp,TypeAttributes typeAttributesTemp) {
            label 	  = labelTemp;
            fieldName = fieldNameTemp;
            type 	  = typeTemp;
            sortable  = false;//sortableTemp;
            editable  = editableTemp;
            typeAttributes = typeAttributesTemp;
        }
    }
    
	//Wrapper class to bind dropdown action with data row
    public class TypeAttributes  {
        @AuraEnabled
        public List<Actions> rowActions;
        public typeAttributes(List<Actions> rowActionsTemp) {
            rowActions = rowActionsTemp;
        }
    }

	//Wrapper class  to store dropdown action
    public class Actions {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String name;
        
        public Actions(String labelTemp, String nameTemp) {
            label 	  	= labelTemp;
            name 		= nameTemp;
        }
    }

    //Bellow code is to search the records of Case
    @AuraEnabled
    public static List<sObject> getResults(String value, String ObjectName, List<String> selectedRecId) {
        System.debug('value-----'+value+'objectName-------'+ObjectName+'selectedRecId-------'+selectedRecId);
        String searchKey = '%' + value + '%';
        List < sObject > returnList = new List < sObject > ();

        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
        String sQuery =  'select Id, AccountId, CaseNumber, Reason, SourceId, Priority, Status, Subject from ' +ObjectName + ' where (caseNumber LIKE: searchKey OR Subject LIKE: searchKey OR Status LIKE: searchKey) AND Id NOT IN : selectedRecId order by Id ASC';
        List < sObject > lstOfRecords = Database.query(sQuery);
        System.debug('lstOfRecords------'+lstOfRecords);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        System.debug('returnlist--------'+returnList);
        return returnList;
    }
}