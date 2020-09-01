({
    doInit : function(component) {
        var action = component.get("c.getAccountRecords");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var data = response.getReturnValue();
            console.log('records '+JSON.stringify(data));
            if (state === "SUCCESS")
                component.set("v.accounts",data.listOfAccount); 
                component.set("v.totalSizeOfRecords",data.totalSize);    
        });
        $A.enqueueAction(action);
    },
    selectedRecord : function(component, event, helper){
        helper.showSelectedRecData(component, helper, event);
    }
})