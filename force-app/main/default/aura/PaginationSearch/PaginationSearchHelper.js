({
    getAccountList: function(component, pageNumber, pageSize) {
        var action = component.get("c.getAccountData");
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                var resultData = result.getReturnValue();
                console.log(JSON.stringify(resultData.accountList));
                component.set("v.AccountList", resultData.accountList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
            }
        });
        $A.enqueueAction(action);
    },
    getAccount: function(component){
       var searchKey =  component.find("searchField").get("v.value");  
       var action = component.get("c.fetchAccount"); 
       action.setParams({    
           "searchKeyWord": searchKey
       });
       action.setCallback(this, function(response) {
           var state = response.getState();
           if (component.isValid() && state === "SUCCESS"){
               var resultData = response.getReturnValue();   
               component.set("v.TotalRecords", component.get("v.AccountList").length);
			   component.set('v.AccountList', resultData); 
           }
       });
       $A.enqueueAction(action);
   },
})