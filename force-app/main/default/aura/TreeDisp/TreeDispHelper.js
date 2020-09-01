({
	selectedObj : function(component, event, helper) {
        console.log('in helper');
        var optnSlctd = component.find("objectPickList").get("v.value");
        alert(optnSlctd);
        var action = component.get("c.parentSObjectRecords");
        action.setParams({
            "objectAPI": optnSlctd
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var records = response.getReturnValue();
            console.log('records '+JSON.stringify(records));
            if (state === "SUCCESS")
                component.set('v.objectNames',records);
        });
        $A.enqueueAction(action);
    }
})