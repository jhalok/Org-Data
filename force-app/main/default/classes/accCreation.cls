public class accCreation {
    
    public static void createAcc(List<Account> newAcc,Map<Id,Account> oldAcc){
        
        Set<String> setOfName = new Set<String>();
        for(Account acc : newAcc){
            setOfName.add(acc.Name);
        }   
        
        List<Account> fetchdRsult =[Select id,Name from Account where name=:setOfName];
        
        for(Account a :newAcc){

            if(fetchdRsult.size() > 0 )
                a.addError('Account already exists in your Organization with name');
        }
    }
}