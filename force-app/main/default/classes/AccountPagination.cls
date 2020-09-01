public class AccountPagination {
	
    @AuraEnabled
    public static List<Account> accData(){
        List<Account> accList = new List<Account>();
        for(Account acc : [Select Name, Industry, (Select FirstName, MobilePhone From Contacts Limit 1) from Account]){
            //if(acc.contacts.size()>0){
                accList.add(acc);
            //}
        }
        //List<Account> listofAcc = [Select Name, Industry, (Select FirstName, MobilePhone From Contacts) from Account];
        //System.debug('--listofAcc--'+listofAcc);
        //System.debug('--JSON.serialize(listofAcc)--'+JSON.serialize(listofAcc));
        return accList;
    }
}