public class SyndicationEventHandler {
	
    public void handleSyndicationChanges(List<Syndication_Event__e> syndEvents){
        
        Set<Id> showIds = new Set<Id>();
        Set<Id> subscrAcctIds = new Set<Id>();
        for(Syndication_Event__e s: syndEvents){
            showIds.add(s.Show__c);
            subscrAcctIds.add(s.Subscriber_Station_Network__c);
        }
        Map<String, Integer> syndMap = fetchShowSyndications(showIds);
        Map<String, Integer> subMap = fetchSubscriptions(subscrAcctIds);
       
        List<Show__c> shows = new List<Show__c>();
        Set<Id> syndAcctIds = new Set<Id>();
        for(Show__c s: [SELECT Id, Active_Syndications__c, Host__r.AccountId FROM Show__c WHERE Id in :showIds]){
            s.Active_Syndications__c = syndMap.get(s.Id);
            shows.add(s);
            syndAcctIds.add(s.Host__r.AccountId);    
        }
        
        update shows;
        
        List<Account> subscribers = new List<Account>();
        for(Account a: [SELECT Id, Active_Subscriptions__c FROM Account WHERE Id in :subscrAcctIds]){
            a.Active_Subscriptions__c = subMap.get(a.Id);
            subscribers.add(a);
        }
        
        update subscribers;
        
        
        Map<String, Integer> syndAcctMap = fetchAcctSyndications(syndAcctIds);
        List<Account> syndicators = new List<Account>();
        for(Account a: [SELECT Id, Active_Syndications__c FROM Account WHERE Id in :syndAcctIds]){
            a.Active_Syndications__c = syndAcctMap.get(a.Id);
            syndicators.add(a);
        }
        
        update syndicators;
    }
    
    private Map<String, Integer> fetchShowSyndications(Set<Id> showIds){
        
        Map<String, Integer> syndMap = new Map<String, Integer>();
        List<AggregateResult> activeSyndications = [SELECT Count(Id) total, Show__c s FROM Syndication__c WHERE IsActive__c = TRUE AND Show__c in :showIds GROUP BY Show__c];
        for(AggregateResult a: activeSyndications){
            syndMap.put(String.valueOf(a.get('s')), Integer.valueOf(a.get('total')));
        }
        return syndMap;
    }
    
    private Map<String, Integer> fetchSubscriptions(Set<Id> acctIds){
        
        Map<String, Integer> subMap = new Map<String, Integer>();
        List<AggregateResult> activeSubscriptions = [SELECT Count(Id) total, Subscriber_Station_Network__c FROM Syndication__c WHERE IsActive__c = TRUE AND Subscriber_Station_Network__c in : acctIds GROUP BY Subscriber_Station_Network__c];
        for(AggregateResult a: activeSubscriptions){
            subMap.put(String.valueOf(a.get('Subscriber_Station_Network__c')), Integer.valueOf(a.get('total')));
        }
        return subMap;
    }
    
    private Map<String, Integer> fetchAcctSyndications(Set<Id> acctIds){
        
        Map<String, Integer> syndMap = new Map<String, Integer>();
        List<AggregateResult> activeSyndications = [SELECT Count(Id) total, Show__r.Host__r.AccountId acct FROM Syndication__c WHERE IsActive__c = TRUE AND Show__r.Host__r.AccountId in : acctIds GROUP BY Show__r.Host__r.AccountId];
        for(AggregateResult a: activeSyndications){
            syndMap.put(String.valueOf(a.get('acct')), Integer.valueOf(a.get('total')));
        }
        return syndMap;
    }
}