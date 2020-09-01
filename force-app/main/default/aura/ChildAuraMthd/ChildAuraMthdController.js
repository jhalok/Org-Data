({
    callingChildMethod : function(component, event, helper) {
        console.log("in child method controller");
        var retRvdPrm = event.getParam('arguments');
        console.log("retRvdPrm"+retRvdPrm);
        if(retRvdPrm){
        var frst = retRvdPrm.firstParam;
            console.log("frst"+frst);
        var scnd = retRvdPrm.secParam;
            console.log("scnd"+scnd);
            var total =frst + scnd;
            console.log("total"+total);
            return total;
        }
    }
})