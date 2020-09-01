public class TreeStructureWithPagination {
    List<String> childOfAccount = new List<String>();
    
     @AuraEnabled
    public static List < Account > fetchAccts() {
        return [ SELECT Id, Name, Industry,( SELECT FirstName, LastName FROM Contacts ),(Select Name FROM Opportunities) FROM Account ORDER BY Name Desc LIMIT 10];
    }
    
}