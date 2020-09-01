public class DisplayContact {
    
    @AuraEnabled
    public static Contact getContact(){
        Contact conData = [Select Name From Contact LIMIT 1];
        return conData;
    }
}