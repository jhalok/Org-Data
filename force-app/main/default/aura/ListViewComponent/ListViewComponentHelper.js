({
    helperMethod : function(component) {
        var  listOfFields = ['header1','header2','header3','header4','header5','header6','header7','header8','header9'];
        var  listOfRecords = ['value1','value2','value3','value4','value5','value6','value7','value8','value9'];
        component.set("v.showingfields",listOfFields);
        component.set("v.listOfRecord",listOfRecords);       
    }
})