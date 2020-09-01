({
    onSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been Saved successfully."
        });
        toastEvent.fire();
    },
    onSubmit : function(component, event, helper) {
    },
    onLoad : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Loaded!",
            "message": "The record has been Loaded successfully ."
        });
        toastEvent.fire();
    },
    onError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Error."
        });
        toastEvent.fire();
    } 
})