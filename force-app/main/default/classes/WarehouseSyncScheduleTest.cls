@isTest
private class WarehouseSyncScheduleTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    static testmethod void testjob(){
        MaintenanceRequestTest.CreateData( 5,2,2,'Repair');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        String joBID= System.schedule('TestScheduleJob', CRON_EXP, new WarehouseSyncSchedule());
        // List<Case> caselist = [Select count(id) from case where case]
        Test.stopTest();
    }
}