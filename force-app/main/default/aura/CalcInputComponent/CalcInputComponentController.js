({
	Calculator: function(component, event, helper) {
	var edit = false;
        
        var num1=component.find("frstnum1").get("v.value");
        var num2=component.find("secnum2").get("v.value");
        var btnLabel = component.find("butn").get("v.label");
        var total;
        if(btnLabel == "Add"){
            total = parseInt(num1) + parseInt(num2) ;
            edit = true;
            console.log(total);
            component.set("v.total", total);
            component.set("v.edit", edit);
            
        }
        else if(btnLabel == "Sub"){
            total = parseInt(num1) - parseInt(num2) ;
            edit = true;
            component.set("v.total", total);
            component.set("v.edit", edit);
        }
        else if(btnLabel == "Mul"){
            total = parseInt(num1) * parseInt(num2) ;
            edit = true;           
            component.set("v.total", total);
            component.set("v.edit", edit);
        }
        else if(btnLabel == "Div"){
            total = parseInt(num1) / parseInt(num2) ;
            edit = true;
            component.set("v.total", total);
            component.set("v.edit", edit);
        }
    }
    
})