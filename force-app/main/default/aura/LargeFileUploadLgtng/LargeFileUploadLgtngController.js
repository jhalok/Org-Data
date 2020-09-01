({
    doInit : function(component, event, helper) {
     	var action = component.get("c.insertCase");
        action.setCallback(this, function(response){
            var records = response.getReturnValue();
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('Inside success of doinit');
                console.log('id'+records.Id);
                component.set("v.parentId",records.Id);
                console.log('returned data'+JSON.stringify(records));
            }
        });
        $A.enqueueAction(action);	   
    },
    handleFilesChange: function(component, event, helper) {
        console.log('inside onchange of file');
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
       		 component.set("v.fileName", fileName);     
            helper.uploadHelper(component, event);
        }
       
    },
})