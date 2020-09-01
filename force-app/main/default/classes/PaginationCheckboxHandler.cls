public with sharing class PaginationCheckboxHandler {    
    public Account acc{get;set;}    
    public List<Account> accountList {get;set;}        
    public Integer icount{get;set;}    
    List<string> conditions = new List<string>();    
    private integer totalRecs = 0;    
    private integer OffsetSize = 0;    
    private integer LimitSize= 5;  
    
    //Constructor
    public PaginationCheckboxHandler(){      
        acc = new Account();         
    }
    
    public void searchAcc(){        
        totalRecs = 0;        
        OffsetSize = 0;        
        if(accountList !=null && accountList.size()>0){            
            accountList=null;            
        }        
        searchAccounts ();        
        conditions.clear();        
    }
    
    public Void searchAccounts(){      
        if(accountList != null && !accountList.isEmpty()){            
            accountList.clear();            
        }        
        String strQuery ='SELECT Id,Name,AccountNumber,CreatedDate,Phone,Website,Industry,AnnualRevenue From Account WHERE Id!=null ';           
        if(acc.Name !=null && acc.Name !=''){            
            conditions.add('Name Like \'%' +acc.Name +'%\' ');            
        }        
        if(acc.AccountNumber !=null && acc.AccountNumber !=''){            
            conditions.add('AccountNumber Like\'%' +acc.AccountNumber +'%\' ');            
        }
        if (conditions.size() > 0) {            
            strQuery += ' AND ' + conditions[0];            
            for (Integer i = 1; i < conditions.size(); i++)                
                strQuery += '  AND ' + conditions[i];            
        }
        
        if(totalRecs !=null && totalRecs ==0){            
            System.debug('strQuery>>'+strQuery);            
            List<Account> accTemp = Database.query(strQuery);            
            totalRecs = (accTemp !=null &&accTemp.size()>0)?accTemp.size():0;            
        }
        strQuery += ' ORDER BY Name  ASC, CreatedDate DESC LIMIT :LimitSize OFFSET :OffsetSize';        
        accountList  =Database.query(strQuery);        
    }    
    
    @RemoteAction    
    public static boolean delAccount(String jsonString){        
        boolean flag=false;        
        try{            
            List<String> lstId=(List<String>)JSON.deserialize(jsonString, List<String>.class);            
            System.debug('lstId>>'+lstId);            
            List<Account> lstAccount=new List<Account>();            
            for(String s:lstId){                
                Account a=new Account();                
                a.Id=s; 
                lstAccount.add(a);                
            }            
            if(lstAccount.size()>0){                
                delete lstAccount;                
            }            
            flag=true;            
        }        
        catch(Exception ex){        
        }        
        return flag;        
    }  
    
    public void FirstPage(){        
        OffsetSize = 0;        
        searchAccounts();        
    }
    
    public void previous(){       
        OffsetSize = (OffsetSize-LimitSize);        
        searchAccounts();    
    }
    
    public void next(){        
        OffsetSize = OffsetSize + LimitSize;        
        searchAccounts();        
    }
    
    public void LastPage(){        
        OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);        
        searchAccounts();        
    }
    
    public boolean getprev(){        
        if(OffsetSize == 0){         
            return true;          
        }        
        else {      
            return false;         
        }        
    }
    
    public boolean getnxt(){        
        if((OffsetSize + LimitSize) > totalRecs){            
            return true;           
        }        
        else { 
            return false;            
        }        
    }    
 }