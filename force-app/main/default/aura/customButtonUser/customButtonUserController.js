({
    doInit: function(component, event, helper) {
       var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse'+JSON.stringify(storeResponse));
                console.log('Profile Name'+storeResponse.Name);
                component.set("v.currentProfileName",storeResponse.Name);
            }
        });
        $A.enqueueAction(action);
	},
    action: function(component, event, helper) {
        var action = component.get("c.customSettingData");
        var prflName = component.get("v.currentProfileName");
        action.setParams({
            "prflName":prflName,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse'+JSON.stringify(storeResponse));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type" : "Error",
                    "title": "",
                    "message": JSON.stringify(storeResponse)
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})