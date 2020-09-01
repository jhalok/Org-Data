({
	setCurrentList: function(component) {
        console.log("in setCurrentList ");
		    var records = component.get("v.AccountList");	
       		var pageNumber = component.get("v.currentPageNumber");	
            var recPerPage = component.get("v.recordsper");   
      		var pageRecords = records.slice((pageNumber-1)*recPerPage, pageNumber*recPerPage);
            console.log("pageRecords"+pageRecords);
            component.set("v.currentList", pageRecords);	
	}
})