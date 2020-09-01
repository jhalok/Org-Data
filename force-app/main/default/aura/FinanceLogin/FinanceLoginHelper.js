// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({

    qsToEventMap: {
        'startURL'  : 'e.c:setStartUrl'
    },

    handleLogin: function (component, event, helpler) {
        var username = component.find("username").get("v.value");
        var password = component.find("password").get("v.value");
        var isRememberMe = component.find("rememberMe").get("v.value");
        var action = component.get("c.login");
        var startUrl = component.get("v.startUrl");

        startUrl = decodeURIComponent(startUrl);
        
        if (isRememberMe) {
        	this.storeUsernamePassword(component, username);
        }

        action.setParams({username:username, password:password, startUrl:startUrl});
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                // component.set("v.errorMessage",rtnValue);
                component.set("v.showError",true);
            }
        });
        $A.enqueueAction(action);
    },

    getIsUsernamePasswordEnabled : function (component, event, helpler) {
        var action = component.get("c.getIsUsernamePasswordEnabled");
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.isUsernamePasswordEnabled',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },

    getIsSelfRegistrationEnabled : function (component, event, helpler) {
        var action = component.get("c.getIsSelfRegistrationEnabled");
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.isSelfRegistrationEnabled',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },

    getCommunityForgotPasswordUrl : function (component, event, helpler) {
        var action = component.get("c.getForgotPasswordUrl");
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.communityForgotPasswordUrl',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },

    getCommunitySelfRegisterUrl : function (component, event, helpler) {
        var action = component.get("c.getSelfRegistrationUrl");
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.communitySelfRegisterUrl',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
    
    storeUsernamePassword: function(component, username) {
    	var d = new Date();
	    d.setTime(d.getTime() + (24*60*60*1000));
	    var expires = "expires=" + d.toGMTString();
	    document.cookie = "InTouchUsername=" + username + ";" + expires + ";path=/";
    },
    
    retrieveUsernamePassword: function(component, event, helper) {
    	var username = "";
    	
    	var name = "InTouchUsername=";
	    var decodedCookie = decodeURIComponent(document.cookie);
	    var ca = decodedCookie.split(';');
	    for(var i = 0; i < ca.length; i++) {
	        var c = ca[i];
	        while (c.charAt(0) == ' ') {
	            c = c.substring(1);
	        }
	        if (c.indexOf(name) == 0) {
	            username = c.substring(name.length, c.length);
	        }
	    }
    
    	component.find("username").set("v.value",username);
    },
})