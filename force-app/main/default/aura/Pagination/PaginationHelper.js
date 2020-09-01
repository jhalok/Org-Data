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
                component.set("v.AccountList", resultData.accountList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
            }
        });
        $A.enqueueAction(action);
    }
})