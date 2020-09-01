public without sharing class updatePriceHelper {
   
    public static void updatePrice(List<Contact> newCont,Map<Id,Contact> oldCon){
        Decimal totalOFPrntField = 0;
        Decimal childFldTtl = 0;
        Decimal SubPrntTtl =0;
        Map<Id, Account> mapOfAcc = new Map<Id, Account>();
        Set<Id> accountIds = new Set<Id>();
        String suprAcc;
        Decimal agrgtTtlPrc=0;
        
        if(newCont!= null){
            for(Contact record: newCont) 
                accountIds.add(record.AccountId);        
        }
        
        if(oldCon!= null){
            for(Contact record: oldCon.values()) {
                accountIds.add(record.AccountId);
            }
        }      
        
        for(Id accountId: accountIds) {
            mapOfAcc.put(accountId, new Account(Id=accountId, Child_sma_total__c=0));
        }
        
        List<Account> listAcc =[Select Id,name,Child_sma_total__c from Account WHERE ParentId=:accountIds];
        System.debug('listAcc'+listAcc);  
        for(Account acc:listAcc){  
            totalOFPrntField = acc.Child_sma_total__c;
        }
        
        List<Contact> con = [Select Id From Contact Where AccountId = :accountIds];
        if(con.size()>0){
            AggregateResult agRslt = [SELECT AccountId Id, SUM(sma_total__c) ttlofcnt FROM Contact WHERE AccountId = :accountIds GROUP BY AccountId];            
            childFldTtl =(Decimal)agRslt.get('ttlofcnt');
            agrgtTtlPrc =(Decimal)agRslt.get('ttlofcnt');
            System.debug('childFldTtl'+childFldTtl);
            
            mapOfAcc.get((Id)agRslt.get('Id')).Child_sma_total__c = totalOFPrntField + childFldTtl;
            
            System.debug('frstAgrgt'+mapOfAcc.get((Id)agRslt.get('Id')).Child_sma_total__c);
            
            List<Account> parentAcc = [Select ParentId From Account where Id = : accountIds];
            System.debug('parentAcc'+parentAcc);
            System.debug('parentAccccaccountIds'+accountIds);
            Set<Id> parentIdSet = new Set<Id>();
            System.debug('parentIdSet'+parentIdSet);
            for(Account parAcc : parentAcc){
                parentIdSet.add(parAcc.ParentId);
            }
            List<Contact> con1 = [Select Id From Contact Where AccountId = :parentIdSet];
            System.debug('con1'+con1);
            Decimal childFldTtl1=0.0;
            if(con1.size()>0){
                AggregateResult agRslt1 = [SELECT AccountId Id, SUM(sma_total__c) ttlofcnt FROM Contact WHERE AccountId = :parentIdSet GROUP BY AccountId];
                childFldTtl1 =(Decimal)agRslt1.get('ttlofcnt');
            }
            Map<Id,Account> parentAccInfoMap = new Map<Id,Account>([Select Child_sma_total__c From Account where Id = : parentIdSet]);
            System.debug('parentAccInfoMap'+parentAccInfoMap);
            for(Account parAcc : parentAcc){
                System.debug('parAcc.ParentId'+parAcc.ParentId);
                if(parentAccInfoMap.containsKey(parAcc.ParentId)){
                    System.debug('childFldTtl1 : '+childFldTtl1);
                    mapOfAcc.put(parAcc.ParentId, new Account(Id=parAcc.ParentId, Child_sma_total__c=childFldTtl1));
                    mapOfAcc.get((parAcc.ParentId)).Child_sma_total__c += mapOfAcc.get((Id)agRslt.get('Id')).Child_sma_total__c;  
                    //SubPrntTtl = mapOfAcc.get((parAcc.ParentId)).Child_sma_total__c;
                    System.debug('finalOne'+ mapOfAcc.get((parAcc.ParentId)).Child_sma_total__c);
                }
            }
        }
        else{
            for(Id accId : accountIds){
                mapOfAcc.get((accId)).Child_sma_total__c = totalOFPrntField + childFldTtl;
               // suprAcc = mapOfAcc.get((accId)).ParentId;
            }
        }
        if(mapOfAcc.size()>0){
            update mapOfAcc.values();           
        }
    }
}