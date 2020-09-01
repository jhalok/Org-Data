({
    doInit: function(component, event, helper) {
        component.set("v.defaultShow",true);   
        component.set("v.showButton",false);
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        helper.getAccountList(component, pageNumber, pageSize);
    }, 
    handleFirst: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        helper.getAccountList(component, 1 , pageSize);
    },
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber++;
        helper.getAccountList(component, pageNumber, pageSize);
    },
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
      	pageNumber--;
        helper.getAccountList(component, pageNumber, pageSize);
    },
    handleLast: function(component, event, helper) {
        var pageSize = component.find("pageSize").get("v.value");
        var TotalRecords =component.get("v.TotalRecords");
        var last = Math.ceil(TotalRecords/pageSize);
        helper.getAccountList(component, last, pageSize);
    },
    setPageNum :function(component, event, helper){
      var pageNumber = component.get("v.PageNumber");  
      var pageSize = component.find("pageSize").get("v.value");
      var totalPages = component.get("v.TotalPages");
        if(pageNumber > totalPages){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : '',
                message: 'Invalid page number!!,The page number you entered is greater then the total number of existing pages.',
                duration:' 8000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            helper.getAccountList(component,1, pageSize);
        }else{
            helper.getAccountList(component, pageNumber, pageSize);
        }
    },
    onSelectChange: function(component, event, helper){
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        helper.getAccountList(component, pageNumber, pageSize);
    },
    createRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Account"
        });
        createRecordEvent.fire();
    },
    searchKeyChange: function(component, event,helper){
       component.set("v.defaultShow",false);   
       component.set("v.showButton",true);   
       var searchKey =  component.find("searchField").get("v.value");  
         if($A.util.isEmpty(searchKey)){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : '',
                message: 'Please enter the string you want to search.',
                duration:'2000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
             helper.getAccountList(component, 1,5);
        }else{
                helper.getAccount(component);
   		}
    },
    handleSelect: function (component, event) {
        console.log("in han");
        var selected = event.getParam("label");
        console.log("selected"+selected);
        var selectedMenuItemValue = event.getParam("value");
        console.log("selectedMenuItemValue"+selectedMenuItemValue);
                var action = component.get("c.deleteAccount");
                action.setParams({accId:selectedMenuItemValue});
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        $A.get('e.force:refreshView').fire();
                    }
                });
                $A.enqueueAction(action);
             document.location.reload(true);
        switch (selectedMenuItemValue) {
            case 'menuSec':
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/"+selectedMenuItemValue
                });
                urlEvent.fire();
                break;
        }
    },
    showSpinner: function(component, event) {
        component.set("v.spinner", true); 
   }, 
    hideSpinner : function(component,event){
       component.set("v.spinner", false);
    }
})