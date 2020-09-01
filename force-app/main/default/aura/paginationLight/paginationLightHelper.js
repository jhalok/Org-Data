({
	setCurrentList: function(component) {
		var records = component.get("v.allAccounts");
        //console.log("records for frst time"+records);
        var pageNumber = component.get("v.pageNumber");
        //console.log("pageNumber"+pageNumber);
        var recPerPage = component.get("v.recordsPerPage");
        var pageRecords = records.slice((pageNumber-1)*recPerPage, pageNumber*recPerPage);
        component.set("v.currentList", pageRecords);
	}
})