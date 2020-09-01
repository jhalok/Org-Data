({
    doInit: function(component, event){
        var glblPcklst = component.get("v.globalpicklist");  
        var action = component.get("c.fetchPicklist");
        action.setParams({
            "MasterLabel": glblPcklst
        });
        var opts = [];
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log('state'+state);
            if (state === "SUCCESS"){    
                var resultData = result.getReturnValue(); 
                console.log('resultData'+resultData);
                /*for(var i in resultData){
                    console.log('resultData'+resultData[i]);
                }*/
                for (var i = 0; i < resultData.length; i++) {
                    opts.push({
                        label: resultData[i].valueName,
                        value: "value"+i,
                    });              
                }
               /* var slctdValues=[];
                
                for (var i = 0; i < resultData.length; i++) {
                    slctdValues.push({ value: "value"+i});      
                }*/
                component.set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },   
    handleChange: function (component, event) {
        var selectedOptionValue = event.getParam("value");     
         alert("Option selected with value: '" + selectedOptionValue.toString() + "'");
         component.set("v.values",selectedOptionValue);
        console.log("selectedOptionValue              "+selectedOptionValue);
    }
})