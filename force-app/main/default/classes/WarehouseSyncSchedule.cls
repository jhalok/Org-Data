global  class WarehouseSyncSchedule implements Schedulable{
    // implement scheduled code here
    global  void execute (SchedulableContext sc){
        
        WarehouseCalloutService.runWarehouseEquipmentSync();
        //optional this can be done by debug mode 
       String sch = '00 00 01 * * ?';//on 1 pm 
       System.schedule('WarehouseSyncScheduleTest', sch, new WarehouseSyncSchedule());
         
           
    }
}