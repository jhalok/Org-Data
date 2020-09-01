({
    handleSaveRecord : function(component, event, helper) {
     component.find("accountRecordId").saveRecord($A.getCallback(function(saveResult) {
               if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                   console.log("Save completed successfully.");
               } else if (saveResult.state === "INCOMPLETE") {
                   console.log("User is offline, device doesn't support drafts.");
               } else if (saveResult.state === "ERROR") {
                   console.log('Problem saving record, error: ' + 
                              JSON.stringify(saveResult.error));
                   var errMsg = "";
                   for (var i = 0; i < saveResult.error.length; i++) {
                       errMsg += saveResult.error[i].message + "\n";
                   }
                   component.set("v.recordSaveError", errMsg);
               } else {
                   console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
               }
           }));
    }
})