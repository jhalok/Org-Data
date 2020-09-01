public class InsertData {

    public void insertValue(String strName){
        
        List<Account> listToStore = new List<Account>();
       
        Account acc = new Account(Name = strName);
		
            listToStore.add(acc);
        
        insert acc;
        System.debug(listToStore);
       
    }
}