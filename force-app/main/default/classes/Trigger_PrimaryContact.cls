public class Trigger_PrimaryContact {
    
    public static void checkContData(List<Contact> newData,List<Contact> oldData){
     	Set<Id> setOfNewContacts = new Set<Id>();
        Set<Id> setOfOldContacts = new Set<Id>();
        
        /*for(Contact con: oldData){
            if(con.Primary_Contact__c == true){
        		setOfOldContacts.add(con.Id);        
            }else{
            
            }
        }*/
        
        for(Contact conNew :newData){
            if(conNew.Primary_Contact__c !=true && conNew.AccountId !=NULL){
               conNew.Primary_Contact__c = true;
            }
        }
    }   
}