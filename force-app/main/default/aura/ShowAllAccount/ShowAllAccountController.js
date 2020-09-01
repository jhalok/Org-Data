({
	fetchDetails : function(component, event, helper) {
        var action = component.get("c.getRecords");
        action.setCallback(this,function(response){
        var state = response.getState();
            var acclist = response.getReturnValue();
            console.log(acclist);
            alert(state);
            if(state === "SUCCESS"){
                component.set("v.showAcc",acclist);
            }                                  
       });
     $A.enqueueAction(action);
	}
})