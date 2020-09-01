({
    doInit : function(component, event, helper) {
        console.log('doInit called');
        helper.accountData(component,1,10);  
    },
    onSelectChange: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber")
        var pageSize = component.find("pageSize").get("v.value");
        helper.accountData(component, pageNumber, pageSize);
    }
})