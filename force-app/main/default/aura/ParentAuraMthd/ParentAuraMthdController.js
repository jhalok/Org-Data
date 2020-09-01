({
	handleClick : function(component, event, helper) {
        console.log("in Parent cmp controller");
		var childCmpUSingId = component.find('idOfChildCmp');
        var show = childCmpUSingId.childMehtod('1','2');
     console.log("show"+show);
	}
})