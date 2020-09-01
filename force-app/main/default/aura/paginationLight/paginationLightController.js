({
    doInit: function(component, event, helper) {
        var action = component.get("c.getAccounts");
        var recPerPage = component.get("v.recordsPerPage");
        action.setParams({
            "limitValue":"2000",
            "offSetValue":"0"
        });
        action.setCallback(this, function(response){
            var records = response.getReturnValue();
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log("Inside success");
                component.set("v.allAccounts", records);
                component.set("v.maxPage", Math.floor((records.length+(recPerPage-1))/recPerPage));
                helper.setCurrentList(component);
            }
        });
        $A.enqueueAction(action);		
    },	
    handlePageChange: function(component, event, helper){
        console.log("in handlePageChange");
        helper.setCurrentList(component);
    },
    showSpinner: function(component, event) {
        component.set("v.spinner", true); 
    }, 
    hideSpinner : function(component,event){
        component.set("v.spinner", false);
    },
})