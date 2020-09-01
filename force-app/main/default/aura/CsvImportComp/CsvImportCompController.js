({ 
    init: function(component, event, helper) {
        var action = component.get("c.getObjectName");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {           
                var allValues = response.getReturnValue();
                console.log('all objectsss--'+allValues);
                component.set("v.options", allValues);
            }                    
        });
        $A.enqueueAction(action);
    },
    onDragOver : function(component, event, helper) {
        event.preventDefault();
    },
    
    onDrop : function(component, event, helper) {
        event.stopPropagation();
        event.preventDefault();
        event.dataTransfer.dropEffect='copy';
        var files=event.dataTransfer.files;
        //console.log('--files'+files[0]);
        helper.readFile(component,helper,files[0]);
    },
    
    processFileContent : function(component,event,helper){
        helper.saveRecords(component,event);
    },
    
    cancel : function(component,event,helper){
        component.set("v.showMain",false);
    },
    selectedObjectHelper: function(component,event,helper){
        helper.selectedObject(component,event);
        component.set("v.showFieldSec",true);
    },
    handleChange: function (component, event, helper) {
        component.set("v.showMain",true); 
        var selectedDualValues = event.getParam("value");
        console.log('----selectedDualValues'+selectedDualValues);
        component.set("v.selectedItems", selectedDualValues);
    },
})