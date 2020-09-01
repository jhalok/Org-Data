({
    doInit : function(component,event){    
        //var acsToken = component.get('v.AccessToken');
        var endPntLink = component.get('v.link');
        //console.log('acsToken-----'+acsToken);
        var action = component.get('c.condata');
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                var resultData = result.getReturnValue();
                component.set("v.AccessToken", resultData);	
                console.log('label-----------'+resultData);	
            }
        });
        $A.enqueueAction(action);
    },
})