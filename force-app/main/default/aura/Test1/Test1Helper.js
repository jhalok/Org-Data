({
	showData : function(component, event, helper) {
		var action = component.get('c.getContacts');
        console.log('action');
        action.setCallback(this, function(response){
           var returnedData = response.getReturnValue();
           console.log('name'+returnedData.Name);
           console.log('response'+JSON.stringify(returnedData));
           var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.showConName", returnedData.OtherCity);
                component.set("v.showEmail", returnedData.Name);
                
            }
        });
       	console.log('enqueue');
        $A.enqueueAction(action);
	}
})