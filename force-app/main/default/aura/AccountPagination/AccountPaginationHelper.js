({
    accountData : function(component, pageNumber, pageSize) {
        var action = component.get("c.accData");
        action.setCallback(this, function(result){
            var state = result.getState();
            console.log('-----state---'+state);
            if(state === "SUCCESS"){
                var totalSize = [];
                var response = result.getReturnValue();
                component.set('v.accountList',response);
                
                for(var i = 0; i < response.length; i++ ){
                    totalSize.push(response[i]);    
                }
                if(totalSize.length > 0){
                    component.set("v.totalRecords",totalSize.length);
                    var start = ((pageNumber - 1)*pageSize);
                    if((pageNumber * pageSize) > component.get('v.TotalRecords'))
                        var end = component.get('v.TotalRecords');
                    else
                        var end = pageNumber * pageSize; 
                    component.set("v.RecordStart",start+1);
                    component.set("v.RecordEnd",end);
                    component.set('v.TotalPages',Math.ceil(component.get('v.TotalRecords')/component.get('v.pageSize')));                  
                }
            }    
        });
        $A.enqueueAction(action);
    }
})