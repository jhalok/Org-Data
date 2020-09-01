({
    doInit: function (component, event, helper) { 
        var action = component.get("c.ObjectNames");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var records = response.getReturnValue();
            console.log('records '+JSON.stringify(records));
            if (state === "SUCCESS")
                component.set('v.objectNames',records);
        });
        $A.enqueueAction(action);
    },
    selectedObject: function(component, event, helper){
        helper.selectedObj(component,event,helper);
     	//alert(optnSlctd);
    }
})