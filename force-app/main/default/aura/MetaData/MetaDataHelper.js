({
	rtrvList : function(component, event) {  
        component.set('v.mycolumns', [
            {label: 'Account Name', fieldName: 'Name', type: 'text'},
            {label: 'Phone', fieldName: 'Phone', type: 'phone'},
            {label: 'Rating', fieldName: 'Rating', type: 'text'}
        ]);
        var url = new URL(window.location.href);
		var AccsCode = url.searchParams.get("code");
        console.log('acsCode'+AccsCode);
        var action = component.get('c.AccessToken');
        action.setParams({
            'AuthCode' : AccsCode
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                var resultData = result.getReturnValue();
                console.log('resultData----------'+JSON.stringify(resultData));
                component.set("v.AccessToken", resultData[0].acsToken);
                component.set("v.link",resultData[0].link);  		
            }
        });
        $A.enqueueAction(action);
    },
    rtrvMetaDataList : function(component, event){

        //console.log('inside helper rtrvMetaDataList');
        component.set("v.showMetaData", true); 
        component.set("v.hideMetaDataButton", false); 
        component.set("v.hideMetaDataItemButton", true); 
       
        var acsToken = component.get('v.AccessToken');
        var endPntLink = component.get('v.link');
        //console.log('acsToken-----'+acsToken);
        var action = component.get('c.listMetadataTypes');
        action.setParams({
            'AcessTkn' : acsToken,
            'endPointLink' : endPntLink
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                var resultData = result.getReturnValue();
                component.set("v.response", JSON.parse(resultData));  	
               // console.log('label-----------'+resultData);	
            }
        });
        $A.enqueueAction(action);
    },
    reterieveMetaDataItem : function(component, event){
        console.log('inside helper reterieveMetaDataItem');
        component.set("v.showMetaDataItem", true); 
        component.set("v.showMetaData", true); 
        component.set("v.hideMetaDataItemButton", false); 
        var acsToken = component.get('v.AccessToken');
        var endPntLink = component.get('v.link');
        
        var SelectedMetadata  = component.find("curntSlctdVal").get("v.value");
		//console.log('selected Val'+SelectedMetadata);
        //console.log('acsToken-----'+acsToken);
        var action = component.get('c.listMetadataItems');
        action.setParams({
            'slctdVal': SelectedMetadata, 
            'AcessTkn' : acsToken,
            'endPointLink' : endPntLink
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                //alert('resultData'+resultData);
                var resultData = result.getReturnValue();
                component.set("v.metaDataItem",JSON.parse(resultData));  	
                console.log('metaDataIteam-----------'+resultData);	
            }
           // this.reterieveMetaDataZip(component,event);
           /* var that = this;
           
            window.setTimeout(function() { 
                    that.reterieveMetaDataZip(component,event);
            }, 5000); */            
        });
        $A.enqueueAction(action);
    },
    reterieveMetaDataZip : function(component, event){
        console.log('inside helper reterieveMetaDataItem');
        component.set("v.showMetaDataItem", true); 
        component.set("v.showMetaData", true); 
        component.set("v.hideMetaDataItemButton", false); 
        //component.set("v.retrieveMetaDataItemButton",true);       
        var acsToken = component.get('v.AccessToken');
        var endPntLink = component.get('v.link');
        //var SelectedMetadata  = component.find("curntSlctdVal").get("v.value");
		//console.log('selected Val'+SelectedMetadata);
        //console.log('acsToken-----'+acsToken);
       
        var action = component.get('c.retrieveMetadataItem');
        action.setParams({
            'AcessTkn' : acsToken
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                //alert('resultData'+resultData);
                var resultData = result.getReturnValue();
                component.set("v.asyncId",resultData);  	
                console.log('asyncid-----------'+resultData);	
            }
            var that = this;
            var idToRtrv = component.get('v.asyncId');
            console.log('--idToRtrv---'+idToRtrv);
            //if(idToRtrv != NULL){
               // window.setTimeout(function() { 
                    this.rcvmetaDataZip(component,event);
               // }, 5000);      
            //}         
        });
       /* window.setTimeout(
            $A.getCallback(function() {
                var action = component.get('c.checkAsyncRequest');
                action.setParams({
                    'AcessTkn' : acsToken
                });
            }), 5000
        );*/
        $A.enqueueAction(action);
    },
    rcvmetaDataZip  : function(component, event){
        console.log('inside zip code');
        var acsToken = component.get('v.AccessToken');
        var endPntLink = component.get('v.link');
        var rtrvid = component.get('v.asyncId');
        console.log('---rtrvid---'+rtrvid);
        //var SelectedMetadata  = component.find("curntSlctdVal").get("v.value");
		//console.log('selected Val'+SelectedMetadata);
        //console.log('acsToken-----'+acsToken);
        var action = component.get('c.checkAsyncRequest');
        action.setParams({
            'AcessTkn' : acsToken,
            'AsyncRsltId' : rtrvid
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                //alert('resultData'+resultData);
                var resultData = result.getReturnValue();
                component.set("v.zipFile",resultData);  	
                console.log('$$$$$$ MetaDataRetrieveZip-----------'+resultData);	
            }
        });
        $A.enqueueAction(action);
    },
    rcvmetaDataZip  : function(component, event){
        console.log('inside zip code');
        var acsToken = component.get('v.AccessToken');
        var endPntLink = component.get('v.link');
        var rtrvid = component.get('v.asyncId');
        console.log('---rtrvid---'+rtrvid);
        //var SelectedMetadata  = component.find("curntSlctdVal").get("v.value");
		//console.log('selected Val'+SelectedMetadata);
        //console.log('acsToken-----'+acsToken);
        var action = component.get('c.checkAsyncRequest');
        action.setParams({
            'AcessTkn' : acsToken,
            'AsyncRsltId' : rtrvid
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                //alert('resultData'+resultData);
                var resultData = result.getReturnValue();
                component.set("v.zipFile",resultData);  	
                console.log('$$$$$$ MetaDataRetrieveZip-----------'+resultData);	
            }
        });
        $A.enqueueAction(action);
    },
    unZipFile  : function(component, event){
        console.log('inside unZipFile helper');
        var acsToken = component.get('v.AccessToken');
        var endPntLink = component.get('v.link');
        var rtrvid = component.get('v.asyncId');
        console.log('---rtrvid---'+rtrvid);
        //var SelectedMetadata  = component.find("curntSlctdVal").get("v.value");
		//console.log('selected Val'+SelectedMetadata);
        //console.log('acsToken-----'+acsToken);
        var action = component.get('c.receiveMetadataZipFile');
        action.setParams({
            'AcessTkn' : acsToken
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                //alert('resultData'+resultData);
                var resultData = result.getReturnValue();
                //component.set("v.zipFile",resultData);  	
                console.log('******unZip-----------'+resultData);	
            }
        });
        $A.enqueueAction(action);
    }
})