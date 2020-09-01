/**
* Description   :   To implement the KanbanView functionality
*
* Created By    :   Aditi Saxena
*
* Created Date  :   13/09/2019
*
* Version       :   V1.0 Created
*             
**/ 
public class kanbanController {
    
    
    /** 
*     Description     :      getKanbanWrap is used to display the KanBan View on the basis of particular picklistField value
*
*     Arguments       :      objName, objFields, kanbanField
*     
*     Return Types    :      kanbanWrap
*
*     Revision Logs   :      V_1.0 - Created
* 
* */                       
    
    @AuraEnabled(cacheable=true)
    public static kanbanWrap getKanbanWrap(String objName, String[] objFields, String kanbanField) {
        System.debug('objName' +objName);
        System.debug('objFields' +objFields);
        System.debug('kanbanField' +kanbanField);
        List<String> lstPickvals=new List<String>();
        
        //Here, we fetch the values of a  picklist field
        for (Schema.PicklistEntry a : Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(kanbanField).getDescribe().getPickListValues())
            lstPickvals.add(a.getValue());
        System.debug(lstPickvals.size());
        
        //Total Records Count
        String q = 'SELECT ' +kanbanField + ' , COUNT(Id) recordCount' + ' FROM ' + objName + ' GROUP BY ' +kanbanField;  
        System.debug(Database.query(q));
        
        /* AggregateResult[] groupedResults= [SELECT  Name ,AccountId ,CloseDate ,StageName ,Amount, COUNT(Id) recordCount FROM Opportunity GROUP BY StageName];
for (AggregateResult ar : groupedResults)  {
System.debug('Campaign ID' + ar.get('StageName'));

} */
        
        
        String query = 'SELECT Id, ';
        for(String s:objFields){
            query += s+' ,';
        }
        query = query.removeEnd(',');
        query += ' FROM ' + objName;
        System.debug('===Query== ' + query);
        System.debug('===Query Result== ' + Database.query(query));        
        return new kanbanWrap(Database.query(query), lstPickvals,Database.query(q));
    }
    
    /** 
*     Description     :      getUpdatePickList is used to update the picklist value oa particular record 
*
*     Arguments       :      recId, kanbanField, kanbanNewValue
*     
*     Return Types    :      String
*
*     Revision Logs   :      V_1.0 - Created
* 
* */   
    @AuraEnabled(cacheable=true)
    public static String getUpdatePickList(Id recId, String kanbanField, String kanbanNewValue) {
        System.debug('===recId== ' + recId);
        System.debug('kanbanField'+kanbanField);
        System.debug('kanbanNewValue'+kanbanNewValue);
        SObject o1 = recId.getSObjectType().newSObject(recId);
        o1.put(kanbanField,kanbanNewValue);
        System.debug('===o1== ' + o1);         
        update o1;      
        return 'SUCCESS';
    }
    
    
    /**
* Description   :   To  hold the values of a records , total count and list of picklist values  
*
* Created By    :   Aditi Saxena
*
* Created Date  :   13/09/2019
*
* Version       :   V1.0 Created
*             
**/ 
    
    public class kanbanWrap {
        @AuraEnabled
        public List<sObject> records {get;set;}
        @AuraEnabled
        public List<sObject> recordsCount {get;set;}        
        @AuraEnabled
        public List<String> pickVals {get;set;}
        @AuraEnabled
        public Map<String,List<sObject>> mapStage {get;set;}
        public kanbanWrap(List<sObject> recs, List<String> pVals,List<sObject> recCount){
            
            this.records = recs;
            this.pickVals = pVals;
            this.recordsCount = recCount;
            System.debug(' this.recCount'+ this.recordsCount);
            mapStage= new Map<String,List<sObject>>();
            for(SObject ob : recs) {
                System.debug('mapStage'+ob.get('Status'));
                System.debug('mapStage'+mapStage.containskey(String.valueOf(ob.get('Status'))));
                if( !mapStage.containskey(String.valueOf(ob.get('Status')))){
                    mapStage.put(String.valueOf(ob.get('Status')),new List<SObject>{ob});
                }
                else {
                    mapStage.get(String.valueOf(ob.get('Status'))).add(ob);
                }
            } 
            System.debug('mapStage Data'+mapStage);
            
        }
    }
}