trigger updatePricee on Contact (after update,after insert,after delete) {
    
    if((trigger.isAfter && trigger.isUpdate) ||(trigger.isAfter && trigger.isInsert) ||(trigger.isAfter && trigger.isDelete)){
        updatePriceHelper.updatePrice(Trigger.new,Trigger.oldMap);     
       
    }
}