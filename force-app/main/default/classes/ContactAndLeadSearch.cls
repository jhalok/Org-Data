public class ContactAndLeadSearch {
    
    public static List<List< SObject>> searchContactsAndLeads(String mtchData){
        
        List<List<sObject>> searchList = [FIND :mtchData IN ALL FIELDS 
                                          RETURNING Lead(Name,LastName),Contact(FirstName,LastName,Department)];
        
        return searchList;
    }   
}