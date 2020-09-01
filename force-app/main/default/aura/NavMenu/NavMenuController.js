({
    showLeftNav : function(component, event, helper) {
        console.log('inside mthd');
        // var showNavCloseButton = component.get("v.showNavCloseButton") ? false : true;
        // var showLeftNav = showNavCloseButton ? true : false;
        // var showNavButton = component.get("v.showNavButton") ? false : true;
        // component.set('v.showLeftNav',showLeftNav);
        // component.set('v.showNavCloseButton',showNavCloseButton); 
        // component.set('v.showNavButton',showNavButton); 
        
    },
    onClick : function(component, event, helper) {
        console.log('inside onClick mthd');
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
    doSomething : function(component, event, helper) {
      /*  console.log('inside doSomething mthd');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": 'https://www.google.com/maps/place/'
        });
        urlEvent.fire();*/
    }
})