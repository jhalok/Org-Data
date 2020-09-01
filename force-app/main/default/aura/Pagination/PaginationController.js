({
    doInit: function(component, event, helper) {
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
        alert("handleLast button");
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
                title : 'Error Message',
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
    onSelectChange: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber")
        var pageSize = component.find("pageSize").get("v.value");
        helper.getAccountList(component, pageNumber, pageSize);
    }
})