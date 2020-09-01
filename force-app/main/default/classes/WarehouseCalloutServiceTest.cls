@IsTest
private class WarehouseCalloutServiceTest {
    @isTest
    static void testCallout(){
        
        Test.startTest();
        
        if (test.isRunningTest())
            Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        
        WarehouseCalloutService.runWarehouseEquipmentSync();
        
        Test.stopTest();
        
       	List<Product2> prodObj = [SELECT id FROM Product2];
        System.debug('prodObj ==> ' + prodObj);
        System.assertEquals(2, prodObj.size());
    }
}