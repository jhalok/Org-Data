({

    sendMessage: function(component, helper, message){
        //Send message to VF
        message.origin = window.location.hostname;
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        vfWindow.postMessage(message, component.get("v.vfHost"));
    }
})