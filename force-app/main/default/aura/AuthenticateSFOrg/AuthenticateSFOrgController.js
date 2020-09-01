({
    authenticateOrg: function(component,event,helper) {
        //var clientId = component.get('v.clientId');
        //console.log('clientId----------'+clientId);
        var action = component.get('c.CallApi');
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log('state----------'+state);
            if (state === "SUCCESS"){
                var resultData = result.getReturnValue();
                var clientId = resultData[0].clientId;
                
                console.log('resultData----------'+JSON.stringify(resultData[0].clientId));
                //console.log('clientId'+JSON.stringify(clientId));
                //component.set("v.showData", resultData);  		
                $A.get("e.force:navigateToURL").setParams({ 
                    "url": 'https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=' + clientId + '&redirect_uri=https://jhaalok-developer-edition.ap4.force.com/MetaOrg/RetrieveXMLCmpPage&prompt=login&display=popup&state=state'
                }).fire();
            }
        });
        $A.enqueueAction(action);
    }
})