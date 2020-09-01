({
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            console.log("Record is loaded successfully.");
        } else {
   			console.log("Record is not loaded successfully");         
    }
   }
})