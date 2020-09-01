trigger MaintenanceRequest on Case (after update) {
    MaintenanceRequestHelper.updateWorkOrders(Trigger.new);
}