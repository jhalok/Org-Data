@isTest
public class ZBSLoadDataController_Test {
	/* NOTE:
	 * This is NOT a comprehensive test class. It was designed to serve package coverage,
	 * not serve as an example of production-ready test class structure or best practices in testing.
	 */
    @testSetup
    private static void setup(){
        List<Account> testAccts = new List<Account>();
        for(Integer i=0; i<5; i++){
            Account a = new Account();
            a.Name = 'TestAcc'+i;
         	testAccts.add(a);
        }
        insert testAccts;
    }
    
    static testMethod void canDeleteAll(){
        List<Account> allAccts = [SELECT Id FROM Account];
        ZBSDataLoadController.deleteAll();
        List<Account> allAfterDelete = [SELECT Id FROM Account];
        system.assertNotEquals(allAccts.size(), allAfterDelete.size());
        system.assert(allAccts.size() > allAfterDelete.size());
        
    }
}