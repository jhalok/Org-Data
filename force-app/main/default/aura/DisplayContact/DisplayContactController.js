({
	doInIt : function(component, event, helper) {
		helper.showData(component, event, helper);
        //this.currntData(component, event, helper);
        var action = component.get("c.currntData");
        action.setCallback(this, function(response){
            //var result = response.getReturnValue();
         
        });
        $A.enqueueAction(action);
	},
    currntData : function(component, event, helper){
        alert("inside currntData");
    }
})