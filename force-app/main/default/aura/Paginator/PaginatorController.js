({
    firstPage: function(component, event, helper) {
        component.set("v.currentPageNumber", 1);
    },
    prevPage: function(component, event, helper) {
        component.set("v.currentPageNumber", component.get("v.currentPageNumber")-1);    
    },
    nextPage: function(component, event, helper) {
        component.set("v.currentPageNumber", component.get("v.currentPageNumber")+1);
        var page = component.get("v.currentPageNumber");
        console.log("page"+page);
        var rcrds = component.get("v.recordsper");
        console.log("rcrds"+rcrds);
        var accData = component.get("v.AccountList");
        console.log("accData"+accData);
        var curntTotalRcd = page * rcrds;
        //Console.log("curntTotalRcd"+curntTotalRcd);
        if(curntTotalRcd >= 2000){
            var action = component.get("c.getAccounts");
            var recPerPage = component.get("v.recordsper");
          	console.log("recPerPage"+recPerPage);
            var limit= component.get("v.limitvalue");
            console.log("limit"+limit);
            var curntlimit =limit +100;
            console.log("curntlimit",curntlimit);
            component.set("v.limitvalue", curntlimit);    
            action.setParams({      
                "limitValue":curntlimit,
                "accData" : accData
            });
            action.setCallback(this, function(response){
                var records = response.getReturnValue();
                //console.log("records"+JSON.stringify(records));
                var state = response.getState();
                console.log("state"+state);
                if(state === "SUCCESS"){              
                    component.set("v.AccountList", records);
                    component.set("v.maxPageNumber", Math.ceil((records.length+(recPerPage-1))/recPerPage));
                   	helper.setCurrentList(component);
                }       
            });         
            $A.enqueueAction(action);
        }
    },
    lastPage: function(component, event, helper) {
        component.set("v.currentPageNumber", component.get("v.maxPageNumber"));
    },
    handlePageChange: function(component, event, helper){
        console.log("in handlePageChange");
        helper.setCurrentList(component);
    },
})