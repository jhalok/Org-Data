public class CsvImportExport {
   /* for import data into sobject and insert data from csv file  */ 
    @AuraEnabled
    public static string insertData(String strfromle){
        String returnresponse ='';
        List<Account> AccoutnListtoInsert = new List<Account>();
        //system.debug('strfromle = ' + strfromle);
        List<fieldWrapper> datalist = (List<fieldWrapper>)JSON.deserialize(strfromle, List<fieldWrapper>.class);
        //system.debug('datalist = ' + datalist);
        //system.debug('datalistSize = ' + datalist.size());
        for(fieldWrapper wrapper: datalist){
            Account acc =new  Account();
            acc.Name = wrapper.Name;
            acc.Phone = wrapper.phone;
            acc.AccountNumber = wrapper.AccountNumber;
            AccoutnListtoInsert.add(acc);            
        }
        
        if(AccoutnListtoInsert.size() > 0){
            try {
                insert AccoutnListtoInsert;
                returnresponse = 'SUCCESS';
            }
            catch(Exception ex){
                returnresponse = 'ERROR';
            }
        }
        return returnresponse;
    }
    
    public class fieldWrapper{        
        public String Name;        
        public String AccountNumber;        
        public String phone;
        
    } 
    
    /* for export data into csv file  */
    @AuraEnabled
    public static list <Account> fetchContact(){      
        List <Account> returnConList = new List < Account > ();        
        for(Account con: [SELECT Name, phone, AccountNumber From Account ]) {
            returnConList.add(con);
        }
        return returnConList;
    }
}