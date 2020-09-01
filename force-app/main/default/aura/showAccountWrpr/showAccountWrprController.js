({
    doInit : function(component, event, helper) {
        var curntId = component.get('v.recordId');
        console.log('---------------curntId--------------------'+curntId);
        var action = component.get("c.AccountDetails");
        action.setParams({
            "RecordId": component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var ord = response.getReturnValue();
                console.log('---' + JSON.stringify (response.getReturnValue()));
                console.log('ord--------------------'+ord);
                component.set("v.NameStored",JSON.stringify(ord.StoreName));
                component.set("v.BillingCityStored",JSON.stringify(ord.StoreCompany));
            }
        });
        $A.enqueueAction(action);   
    }
})