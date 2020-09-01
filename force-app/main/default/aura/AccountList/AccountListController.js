({
	 show: function(component, event, helper) {
		
	},
 	 doInit : function (component, event, helper) {
        var action = component.get("c.getAcc");
        action.setCallback(this,function (response) { 
        	var accList = response.getReturnValue();
            console.log(accList);
            component.set("v.newAccDetails",accList);
        });
        $A.enqueueAction(action);
    }
})