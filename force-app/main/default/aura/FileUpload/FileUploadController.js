({  

   handleUploadFinished : function (cmp, event){  

     var uploadedFiles = event.getParam("files");  

     var action = cmp.get("c.getClient");  
      var rcdId = cmp.get("v.recordId");
	console.log('rcdId-----'+cmp.get("v.recordId"));
     action.setParams({ 
         oppId : rcdId
     });  

     action.setCallback(this, function(response) {  

       var state = response.getState();  
		console.log('state'+state);
       if (state === "SUCCESS") {  

       }  

     });  

     $A.enqueueAction(action);  

     alert("Files uploaded Client : " + uploadedFiles.length);  

   }  

 })