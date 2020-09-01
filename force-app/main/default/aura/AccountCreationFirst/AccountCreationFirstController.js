({
    doInit : function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        var state = pageRef.state; // state holds any query params
        var base64Context = state.inContextOfRef;
        
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));
        console.log('addressableContext               '+JSON.stringify(addressableContext));
        var rcd = component.set("v.recordId", addressableContext.attributes.recordId);
        console.log('rcd     '+rcd);
    },
    Save : function(component,event,helper){
        console.log('in fetchRcdId method');
        var curntRecordId = component.get("v.recordId");
        console.log('curntRecordId        '+curntRecordId);
        component.set("v.showSecondSec",true);
        component.set("v.showFirstSec",false);      
    }
})