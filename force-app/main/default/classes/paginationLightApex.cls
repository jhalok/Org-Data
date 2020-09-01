public class paginationLightApex {
    
    @AuraEnabled
    public static List<Account> getAccounts(Integer limitValue,Integer offSetValue,List<Account> accData){
       System.debug('in get');
        String lastName;
        List<Account> accList = new List<Account>();
       // DateTime dt = DateTime.now();
        System.debug('limitValue'+limitValue);
        System.debug('offSetValue'+offSetValue); 
        Integer limitVal = Integer.valueOf(limitValue);
        Integer offSetVal = Integer.valueOf(offSetValue);
        Integer totalRec =[Select COUNT() from Account];
        System.debug('totalRec'+totalRec);
        System.debug('accData.size()'+accData.size());
        if(accData.size()==null || accData.size()<2000){
               accList = [SELECT Id, Name, Phone, Rating, AccountNumber, Website, CreatedDate FROM Account ORDER BY NAME LIMIT:limitVal]; 
        }
       else if(accData.size()>=2000){
            System.debug('In else');
            for(Account acc:accData){           
                lastName = String.valueOf(acc.NAME);
            }
            System.debug(lastName);
           // List<String> dateTi = lastDate.split(' ');
           // List<String> yyMMDD = dateTi[0].split('-');
            //List<String> tim = dateTi[1].split(':');
            //String formattedDt = dt.format(yyMMDD[0]+'-'+yyMMDD[1]+'-'+yyMMDD[2]+'\'T\''+tim[0]+':'+tim[1]+':'+tim[2]+'\'Z\'');
           // System.debug('formattedDt  '+formattedDt);
            String query = 'SELECT Id, Name, Phone, Rating, AccountNumber, Website, CreatedDate FROM Account WHERE NAME >:lastName ORDER BY NAME LIMIT:limitVal';
            //system.debug('query  '+query);
            //List<Account> accList1 = [SELECT Id, Name, Phone, Rating, AccountNumber, Website, CreatedDate FROM Account WHERE CreatedDate > lastDate ORDER BY CreatedDate LIMIT:limitValue OFFSET:offSetValue]; 
            accList = new List<Account>();
            accList = Database.query(query);
           System.debug('accList'+accList);
        }
        return accList;
    }
}