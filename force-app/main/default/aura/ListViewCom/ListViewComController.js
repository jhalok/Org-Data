({
    myAction : function(component, event, helper) {
           helper.helperMethod(component);
    }, 
    
    scrollMove : function(component, event, helper) {
        
        var elmnt = document.getElementById("ScrollId");  
        var ButtonTitle =  event.currentTarget.title;
        
        if(ButtonTitle == "up")
            elmnt.scrollTop += -50;
        if(ButtonTitle == "down")
            elmnt.scrollTop += +50;
        if(ButtonTitle == "prev")
            elmnt.scrollLeft += -50;
        if(ButtonTitle == "next")
            elmnt.scrollLeft += 50; 
         if(ButtonTitle == "close")
            component.set("v.hideButton",false);
    }, 
    
    showButton : function(component, event, helper) {
           
        var valueOfShowIcons=component.get("v.showIcons");
        
        if(valueOfShowIcons)
            component.set("v.showIcons",!valueOfShowIcons);
        else
            component.set("v.showIcons",!valueOfShowIcons);  
    },
     
})