({
    doInit: function(component, event, helper) {
        var action = component.get("c.getObjectName");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {           
                var allValues = response.getReturnValue();
                component.set("v.options", allValues);
            }                    
        });
        $A.enqueueAction(action);
    },
    selectedObject : function(component,event,helper){
        component.set("v.showObjects",false);
        component.set("v.showFailed",false);
        component.set("v.showMain",true);
    },
    closeJob : function(component, event, helper) {
        helper.changeJobStatus(component, event);
    },
    showFailedData : function(component, event, helper) {
        helper.failedData(component, event);
    },
    onFileUploaded : function(component,event,helper){
        component.set("v.showMain",false);
        component.set("v.showObjects",false);
        component.set("v.showFailed",true);
        var files = component.get("v.fileToBeUploaded");
        if (files && files.length > 0) {
            var file = files[0][0];
            var reader = new FileReader();
            reader.onloadend = function() {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                helper.uploadFile(component, file, content);
            }
            reader.readAsDataURL(file);
        }
    },
})