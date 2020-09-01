({
	showSelectedRecData : function(component, helper, event){
		var ctarget = event.currentTarget;
        console.log('ctarget '+ctarget);
        var curntActRcd = ctarget.dataset.value;
        console.log('curntActRcd   '+curntActRcd);
        
        var action = component.get("c.getContactRecords");
        action.setParams({
            accId :  curntActRcd
        });
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            var records = response.getReturnValue();
            console.log('records '+JSON.stringify(records));
            if (state === "SUCCESS")
                component.set("v.contacts",records.listOfContact);  
                component.set("v.cases",records.listOfCase);  
              
        });
        $A.enqueueAction(action);
	}
})