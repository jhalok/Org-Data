({
	showData : function(component, event, helper) {
		var action = component.get("c.getContact");
        action.setCallback(this, function(response){
           var result = response.getReturnValue();
           var state = response.getState();
            if(state ==="SUCCESS"){
                component.set("v.contactName", result.Name);
            }
        });
        $A.enqueueAction(action);
	}
})