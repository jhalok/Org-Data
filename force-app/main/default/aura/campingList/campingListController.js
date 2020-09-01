({
    // Load items from Salesforce
	doInit: function(component, event, helper) {
    
        // Create the action
        var action = component.get("c.getItems");
    
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state == "SUCCESS") {
                component.set("v.items", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
    
        // Send action off to be executed
        $A.enqueueAction(action);
	},
    handleAddItem : function (component,event,helper){
	var action = component.get("c.saveItem");
        var Item = event.getParam("item");
        var lstItems = component.get("v.items");

        lstItems.push(Item);
        component.set("v.items",lstItems);
        console.log("After:"+lstItems);
        action.setParams({"CampingItem":Item});
        action.setCallback(this,function(response){
            var state = response.getState();
                
            if (component.isValid() && state === "SUCCESS") {
                //let the magic happen
            }
         });
        $A.enqueueAction(action);   
     }
})