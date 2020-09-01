({
    doInit: function (component, event, helper) {
        var spinner = component.find("spnr");
        var action = component.get('c.getAccountTree');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                //get account and respective contact list, and initialize with items
                component.set('v.items', response.getReturnValue());
                //hide spinner after getting data
                $A.util.toggleClass(spinner, "slds-hide");
            }else{
                $A.util.toggleClass(spinner, "slds-hide");
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);
    },
    handleSelect: function (cmp, event, helper) {
        //return name of selected tree item
        var selectedName = event.getParam('name');
//alert("Selected Name: " + selectedName);
    }
})