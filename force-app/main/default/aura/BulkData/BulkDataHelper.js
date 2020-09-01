({
    uploadFile: function(component, file, base64Data) {
        var action = component.get("c.accessToken");
        var decodedString = atob(base64Data);
        var selectedObj = component.get("v.selectedValue");
        action.setParams({
            selectedObj : selectedObj,
            fileName: file.name,
            base64Data: base64Data,
            contentType: file.type
        });
        this.show(component,event);
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                this.hide(component,event);
                var resultData = result.getReturnValue();
                component.set("v.jobId",resultData.jobId);
                component.set("v.accessToken",resultData.accessToken);
                this.changeJobStatus(component,event);
            }
        });
        $A.enqueueAction(action);
    },
    show: function (component, event) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hide:function (component, event) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    changeJobStatus : function(component, event){
        var JSONResponse = '';
        var params = '{"state" : "UploadComplete"}';
        var jobId = component.get("v.jobId");
        var accessToken = component.get("v.accessToken");
        var xmlHttp = new XMLHttpRequest();
        var url = 'https://lightdevlopment-dev-ed.my.salesforce.com/services/data/v41.0/jobs/ingest/'+jobId;
        xmlHttp.open( "PATCH", url, true );
        xmlHttp.setRequestHeader('Content-Type', 'application/json');
        xmlHttp.setRequestHeader('Authorization', 'Bearer ' + accessToken);
        xmlHttp.responseType = 'text';
        xmlHttp.onload = function () {    
            if (xmlHttp.readyState === 4 || xmlHttp.status === 200) {
            }
        };
        xmlHttp.send(params);
    },
    failedData : function(component, event) {  
        var jobId = component.get("v.jobId");
        var accessToken = component.get("v.accessToken");
        var action = component.get('c.failedData');
        action.setParams({
            jobId : jobId, 
            sessionId : accessToken
        })
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                var resultData = result.getReturnValue();
                this.failedDataCSV(component,resultData);
            }
        });
        $A.enqueueAction(action);
    },  
    failedDataCSV : function(component,resultData){
        var csv = resultData;   
        if(csv == null){
            return;
        }  
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = 'FailedData.csv'; 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
        var csvStringResult, counter, keys, columnDivider, lineDivider;  
        if (resultData == null || !resultData.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider =  '\n';
        keys = [];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < resultData.length; i++){   
            counter = 0;            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey]; 
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                } 
                if(resultData[i][skey] != undefined){
                    csvStringResult += '"'+ resultData[i][skey]+'"'; 
                }else{
                    csvStringResult += '"'+ '' +'"';
                }
                counter++;
            }
            csvStringResult += lineDivider;
        } 
        return csvStringResult; 
    },
})