({
    handleActionPane : function(component, event, helper) {
        var buttonName =  event.getSource().get("v.name");
        if(buttonName == "right") {
            document.getElementById('container').scrollLeft += 50;
        } else if(buttonName == "left") {
            document.getElementById('container').scrollLeft += -50;    
        } else if(buttonName == "up") {
            document.getElementById('container').scrollTop += -50;    
        } else if(buttonName == "down") {
            document.getElementById('container').scrollTop += 50;    
        } else {}
    },
    
    handleSelectFieldsToDisplay: function(component, event, helper) {
        
    },
})