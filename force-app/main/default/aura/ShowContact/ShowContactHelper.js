({
   onLoad : function(component, event, helper) {
        var action = component.get("c.contData");
        action.setCallback(this, function(response){
            var records = response.getReturnValue();
            var state = response.getState();
            if(state === "SUCCESS"){
  				console.log('inside helper');
                console.log('records'+JSON.stringify(records));
                console.log('records--'+JSON.stringify(records[0].Name));
                component.set("v.showData", records);
            }
        });
        $A.enqueueAction(action);
    }
})