({
    initialize: function(component, event, helper) {
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap}).fire();
        component.set('v.isUsernamePasswordEnabled', helper.getIsUsernamePasswordEnabled(component, event, helper));
        component.set("v.isSelfRegistrationEnabled", helper.getIsSelfRegistrationEnabled(component, event, helper));
        component.set("v.communityForgotPasswordUrl", helper.getCommunityForgotPasswordUrl(component, event, helper));
        component.set("v.communitySelfRegisterUrl", helper.getCommunitySelfRegisterUrl(component, event, helper));
        helper.retrieveUsernamePassword(component, event, helper);
    },

    handleLogin: function (component, event, helpler) {
        helpler.handleLogin(component, event, helpler);
    },

    setStartUrl: function (component, event, helpler) {
        var startUrl = event.getParam('startURL');
        if(startUrl) {
            component.set("v.startUrl", startUrl);
        }
    },
    checkRememberMe: function(component, event, helper){
        helper.getRememberMeCheck(component);
    },
    onKeyUp: function(component, event, helpler){
        //checks for "enter" key
        if (event.getParam('keyCode')===13) {
            helpler.handleLogin(component, event, helpler);
        }
    },
    onCheck: function(component, event, helper){

        if (localStorage.chkbx && localStorage.chkbx != '') {
            $('#rememberMe').attr('checked', 'checked');
            $('#username').val(localStorage.usrname);
        } else {
            $('#rememberMe').removeAttr('checked');
            $('#username').val('');
        }

        $('#rememberMe').click(function() {

            if ($('#remember_me').is(':checked')) {
                // save username
                localStorage.usrname = $('#username').val();
                localStorage.chkbx = $('#rememberMe').val();
            } else {
                localStorage.usrname = '';
                localStorage.chkbx = '';
            }
        });
    },

    navigateToForgotPassword: function(cmp, event, helper) {
        var forgotPwdUrl = cmp.get("v.communityForgotPasswordUrl");
        if ($A.util.isUndefinedOrNull(forgotPwdUrl)) {
            forgotPwdUrl = cmp.get("v.forgotPasswordUrl");
        }
        var attributes = { url: forgotPwdUrl };
        $A.get("e.force:navigateToURL").setParams(attributes).fire();
    },


    navigateToSelfRegister: function(cmp, event, helper) {
      window.open ('/ItsAboutBreathing/s/join','_self',false);
        // var selrRegUrl = cmp.get("v.communitySelfRegisterUrl");
        // if (selrRegUrl == null) {
        //     selrRegUrl = cmp.get("v.selfRegisterUrl");
        // }
        //
        // var attributes = { url: selrRegUrl };
        // $A.get("e.force:navigateToURL").setParams(attributes).fire();
    },
    
})