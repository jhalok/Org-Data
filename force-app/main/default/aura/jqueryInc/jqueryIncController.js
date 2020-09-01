({
    onChange : function(component, event){
        var seperator = "/";
        var lengthTtl;
        var curntVal;
        
        curntVal = component.find("inputData").get('v.value');
        lengthTtl = curntVal.length;
        if(lengthTtl == 2 || lengthTtl == 5) {
            curntVal += seperator;
            component.set('v.DOB',curntVal);
        }
        window.addEventListener("keydown", function(e){
            if((e.keyCode >= 65 && e.keyCode <=90) || (e.keyCode >= 106 && e.keyCode <=123) || (e.keyCode >= 186 && e.keyCode <=192) || (e.keyCode >= 219 && e.keyCode <=222)) {
                e.preventDefault();
            }
        }); 
    },
})