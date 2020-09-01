({
	myAction : function(component, event, helper) {
		var action =component.get("c.getAllAccounts");
         action.setCallback(this, function(response){      
            component.set("v.accounts", response.getReturnValue());
            console.log('The accs are :'+JSON.stringify(response.getReturnValue()));
        });
        $A.enqueueAction(action);
	}
})