({
	doInit : function(component, event, helper) {
		helper.getdata(component, event, helper); 
    },
    selectObject :function(component, event, helper) {
   		helper.getObjectsFieldSet(component, event, helper);
    },
    selectFieldSet :function(component, event, helper){
 		helper.getFieldSetMember(component, event, helper);
	},
    handlePress : function(component, event, helper) {
        alert("now called handlepress");
        helper.onUpserObject(component, event, helper);
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    hideSpinner : function(component,event,helper){
       component.set("v.Spinner", false);
    }
})