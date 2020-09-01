({
    doInit: function(component, event, helper) {
        component.find("contactRecordCreator").getNewRecord(
            "Contact", // objectApiName
            null, // recordTypeId
            false, // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newContact");
                var error = component.get("v.newContactError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                }
                else {
                    console.log("Record template initialized: " + rec.sobjectType);
                }
            })
        );
    },

    handleSaveContact: function(component, event, helper) {
        if(helper.validateContactForm(component)) {
            component.set("v.simpleNewContact.AccountId", component.get("v.recordId"));
            component.find("contactRecordCreator").saveRecord(function(saveResult) {
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {

                    // Success! Prepare a toast UI message
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Contact Saved",
                        "message": "The new contact was created."
                    });

                    // Update the UI: close panel, show toast, refresh account page
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();

                    // Reload the view so components not using force:recordData
                    // are updated
                    $A.get("e.force:refreshView").fire();
                }
                else if (saveResult.state === "INCOMPLETE") {
                    console.log("User is offline, device doesn't support drafts.");
                }
                else if (saveResult.state === "ERROR") {
                    console.log('Problem saving contact, error: ' +
                                 JSON.stringify(saveResult.error));
                }
                else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                }
            });
        }
    },

    handleCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})