public class TreeStructure {
     
    @AuraEnabled
    public static List<item> getAccountTree(){
         
        List<item> items = new List<item>();
        List<Account> acctList = new List<Account>();

        acctList = [SELECT Id, Name,BillingCity, (SELECT Id, Name From Contacts) From Account ORDER BY Name DESC LIMIT 10];
        for(Account acc: acctList){
             
            //get contacts of current account record
            List<item> conitems = new List<item>();
            for(Contact c: acc.Contacts){
                //add contact items
                item conitem = new item(c.Name,c.Id, String.valueOf(c.Id), false, null);
                conitems.add(conitem);
            }
             
            //add account items
            item accitem = new item(acc.Name,acc.Id, String.valueOf(acc.Id), false, conitems);
            items.add(accitem);
        }
        return items;
    }
     
    //Item Wrapper Class
    public class item{
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public Boolean expanded {get; set;}
		@AuraEnabled
        public String Id;
        @AuraEnabled
        public List<item> items {get; set;}
         
        public item(String label, String name,String Id, Boolean expanded, List<item> items){
           	this.Id = Id;
            this.label = label;
            this.name = name;
            this.expanded = expanded;
            this.items = items;
        }
    }
}