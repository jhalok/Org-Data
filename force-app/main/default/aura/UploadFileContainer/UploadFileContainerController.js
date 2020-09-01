({
    doInit : function(component, event, helper) {
        //Send LC Host as parameter to VF page so VF page can send message to LC; make it all dynamic
        component.set('v.lcHost', window.location.hostname);

        var frameSrc = '/apex/UploadFilePage?id=' + component.get('v.recordId') + '&lcHost=' + component.get('v.lcHost');
        console.log('frameSrc:' , frameSrc);
        component.set('v.frameSrc', frameSrc);

        //Add message listener
        window.addEventListener("message", function(event) {

            console.log('event.data:', event.data);

            // Handle the message
            if(event.data.state == 'LOADED'){
                //Set vfHost which will be used later to send message
                component.set('v.vfHost', event.data.vfHost);
            }

            if(event.data.state == 'uploadFileSelected'){
                component.find('uploadFileButton').set('v.disabled', false);
            }

            if(event.data.state == 'fileUploadprocessed'){

                var uiMessage = component.find('uiMessage');

                //Disable Upload button until file is selected again

                component.find('uploadFileButton').set('v.disabled', true);

                $A.createComponents([
                        ["markup://ui:message",{
                            "body" : event.data.message,
                            "severity" : event.data.messageType,
                        }]
                    ],
                    function(components, status, errorMessage){
                        if (status === "SUCCESS") {
                            var message = components[0];
                            // set the body of the ui:message to be the ui:outputText
                            component.find('uiMessage').set("v.body", message);
                        }
                        else if (status === "INCOMPLETE") {
                            console.log("No response from server or client is offline.")
                            // Show offline error
                        }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                            // Show error message
                        }
                    }
                );
            }
        }, false);
    },
    sendMessage: function(component, event, helper) {
        //Clear UI message before trying for file upload again
        component.find('uiMessage').set("v.body",[]);

        //Prepare message in the format required in VF page
        var message = {
            "uploadFile" : true
        } ;
        //Send message to VF
        helper.sendMessage(component, helper, message);
    }
})