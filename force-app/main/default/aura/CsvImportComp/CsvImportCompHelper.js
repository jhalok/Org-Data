({
    readFile: function(component, helper, file) {
        if (!file) return;
        console.log('file'+file.name);
        if(!file.name.match(/\.(csv||CSV)$/)){
            return alert('only support csv files');
        }else{
            reader = new FileReader();
            reader.onerror =function errorHandler(evt) {
                switch(evt.target.error.code) {
                    case evt.target.error.NOT_FOUND_ERR:
                        alert('File Not Found!');
                        break;
                    case evt.target.error.NOT_READABLE_ERR:
                        alert('File is not readable');
                        break;
                    case evt.target.error.ABORT_ERR:
                        break; // noop
                    default:
                        alert('An error occurred reading this file.');
                };
            }
            //reader.onprogress = updateProgress;
            reader.onabort = function(e) {
                alert('File read cancelled');
            };
            reader.onloadstart = function(e) { 
                var output = '<ui type=\"disc\"><li><strong>'+file.name +'</strong> ('+file.type+')- '+file.size+'bytes, last modified: '+file.lastModifiedDate.toLocaleDateString()+'</li></ui>';
                component.set("v.filename",file.name);
                component.set("v.TargetFileName",output);
                console.log('Target File Name output'+output);
               
            };
            reader.onload = function(e) {
                var data=e.target.result;
                console.log('--data--'+data);
                component.set("v.fileContentData",data);
                console.log("file data"+JSON.stringify(data));
                var allTextLines = data.split(/\r\n|\n/);
                console.log('--allTextLines--'+allTextLines);
                var dataRows=allTextLines.length-1;
                console.log('--dataRows--'+dataRows);
                var headers = allTextLines[0].split(',');
                console.log('--headers--'+headers);
                console.log("Rows length::"+dataRows);         
                	var numOfRows=component.get("v.NumOfRecords");
                	console.log('--numOfRows--'+numOfRows);
                    if(dataRows > numOfRows+1 || dataRows == 1 || dataRows== 0){
                   
                     alert("File Rows between 1 to "+numOfRows+" .");
                    component.set("v.showMain",true);   
                } 
                else{
                    var lines = [];
                    var filecontentdata;
                    var content = "<table class=\"table slds-table slds-table--bordered slds-table--cell-buffer\">";
                    content += "<thead><tr class=\"slds-text-title--caps\">";
                    for(i=0;i<headers.length; i++){
                        content += '<th scope=\"col"\>'+headers[i]+'</th>';
                    }
                    content += "</tr></thead>";
                    for (var i=1; i<allTextLines.length; i++) {
                        filecontentdata = allTextLines[i].split(',');
                        if(filecontentdata[0]!=''){
                            content +="<tr>";      
                            for(var j=0;j<filecontentdata.length;j++){
                                content +='<td>'+filecontentdata[j]+'</td>';
                            }
                            content +="</tr>";
                        }
                    }
                    content += "</table>";
                    component.set("v.TableContent",content);
					component.set("v.showMain",false);                   
                }
            }
            reader.readAsText(file);
            //console.log('--text reader--'+reader.readAsText(file));
        }
        var reader = new FileReader();
        reader.onloadend = function() {
        };
        reader.readAsDataURL(file);
    },
    
    saveRecords : function(component,event){
        var action = component.get("c.processData");
        //console.log('selected fieldsList---'+fieldsList);
        action.setParams({ 
            fileData : component.get("v.fileContentData"),
            sobjectName:component.get("v.selectedValue"), 
            fields: component.get("v.selectedItems"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showMain",true);
                alert('Import of file Started');
            }
            /*else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }*/
        });
        $A.enqueueAction(action);
    },
    
    selectedObject:function(component,event){
    	var selectedObj = component.get("v.selectedValue");
    	console.log('%%%%%%%%%%selectedObj'+selectedObj);
        var action = component.get("c.getFieldName");
        action.setParams({
            selectedObj : selectedObj, 
        })
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var options = [];
         		var fieldMap = response.getReturnValue(); 
        		for (var k in fieldMap) {
            		options.push({ value:k, label:fieldMap[k]});
        		}
                console.log('pushed options-------'+JSON.stringify(options));
        	component.set('v.fieldOptions', options);
            }
        });
        $A.enqueueAction(action);
	}
});