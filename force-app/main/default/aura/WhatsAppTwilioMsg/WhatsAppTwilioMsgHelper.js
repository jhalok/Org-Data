({
    sendMessage : function(component, event) {
        var isSigned = false;
        var action = component.get("c.sendMessage");
        action.setParams({
            mobileno: component.find("mobileNumber").get("v.value"),
            message: component.find("message").get("v.value")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.find('notifLib').showNotice({
                    "variant": "info",
                    "header": "Success!",
                    "message": "WhatsApp Message Sent"
                });
                
            } else {
                component.find('notifLib').showNotice({
                    "variant": "error",
                    "header": "Something has gone wrong!",
                    "message": "Unfortunately, there was a problem while sending WhatsApp Message"
                });
            }
        });
        $A.enqueueAction(action);
    }
})