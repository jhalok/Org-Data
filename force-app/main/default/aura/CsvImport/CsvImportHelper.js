({
    CSV2JSON: function (component,csv) {
        //  console.log('Incoming csv = ' + csv);
        
        //var array = [];
        var arr = []; 
        
        arr =  csv.split('\n');
        //console.log('Array  = '+array);
        // console.log('arr = '+arr);
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                obj[headers[j].trim()] = data[j].trim();
                //console.log('obj headers = ' + obj[headers[j].trim()]);
            }
            jsonObj.push(obj);
        }
        var json = JSON.stringify(jsonObj);
        //console.log('json = '+ json);
        return json;
        
        
    },
    
    CreateAccount : function (component,jsonstr){
        // console.log('jsonstr' + jsonstr);
        var action = component.get('c.insertData');
        //  alert('Server Action' + action);    
        action.setParams({
            strfromle : jsonstr
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {  
                var result=response.getReturnValue();
                alert("Accounts Inserted Succesfully");
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                    //alert('Unknown');
                }
            }
        }); 
        
        $A.enqueueAction(action);    
        
    },
    
    
    //export helper start from here
    onLoad: function(component, event) {
        //call apex class method
        var action = component.get('c.fetchContact');
        action.setCallback(this, function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfContact attribute on component.
                component.set('v.ListOfContact', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys variable store fields API Names as a key 
        // this labels use in CSV file header  
        keys = ['Name','Phone','AccountNumber' ];
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey]; 
                
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                } 
                // if condition for blank column display if value is empty
                if(objectRecords[i][skey] != undefined){
                    csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                }else{
                    csvStringResult += '"'+ '' +'"';
                }
                counter++;
                
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        return csvStringResult; 
        
    },
})