({
    selectedRecords : function(component, event, helper) {
        var selectRecords = event.getParam('recordIds');
        console.log('selected Records------'+selectRecords);
        if(selectRecords != undefined) {
            component.set("v.recordIds", selectRecords);
        }
    }
})