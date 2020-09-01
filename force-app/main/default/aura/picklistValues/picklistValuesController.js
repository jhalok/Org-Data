({
    doInit : function(component,event,helper) {
        alert("hellooo");
        var action = component.get("c.getPickListValuesIntoList");
        action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            component.set("v.picklistValues", list);
        })
        $A.enqueueAction(action);
    }
})