@isTest
public class SyndicationEventHandler_Test {

    @testSetup
    public static void setup(){
        
        List<Account> allAccts = new List<Account>();
        List<Contact> allContacts = new List<Contact>();
        List<Show__c> allShows = new List<Show__c>();
        List<Syndication__c> allSynds = new List<Syndication__c>();
        
        for(Integer x=0; x<5;x++){
            Account a = new Account(Name='Test Account'+x);
            allAccts.add(a);               
        }
            insert allAccts;
        for(Integer x=0; x<5;x++){
            Contact c = new Contact(FirstName='Test', LastName='Contact'+x, AccountId=allAccts[x].Id); 
            allContacts.add(c); 
        }
        insert allContacts;
        
        for(Integer x=0; x<3;x++){
            Show__c sh = new Show__c(Name='Test Show'+x, Host__c=allContacts[x].Id);
            allShows.add(sh);
        }
        insert allShows;
        for(Integer x=0; x<6;x++){
            Syndication__c sy = new Syndication__c();
            if(Math.mod(x,2)==0){
                sy.Start_Date__c = Date.today().addYears(1);
                sy.End_Date__c = Date.today().addYears(2);
                sy.Subscriber_Station_Network__c = allAccts[4].Id;
                sy.Show__c = allShows[0].Id;
                //need subscriber
            }else{
                sy.Start_Date__c = Date.today();
                sy.End_Date__c = Date.today().addYears(3);
                sy.Subscriber_Station_Network__c = allAccts[3].Id;
                sy.Show__c = allShows[1].Id;
            }
            allSynds.add(sy);

        }
        insert allSynds;
      
    }
    
    @isTest
    static void test1(){
        List<Syndication__c> allActive = [SELECT Id FROM Syndication__c WHERE IsActive__c = TRUE];
        
        Syndication__c syn = allActive[0];
        syn.Start_Date__c = Date.today().addYears(-2);
        syn.End_Date__c = Date.today().addYears(-1);
        test.startTest();
        update syn;
        test.stopTest();
        List<Syndication__c> newActives = [SELECT Id FROM Syndication__c WHERE IsActive__c = TRUE];
        system.assertNotEquals(allActive, newActives);
    }
}