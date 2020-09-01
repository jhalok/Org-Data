({
	SignUp : function(component, event, helper) {
		var uname = component.find("userName").get("v.value");
        console.log('uname: '+uname);
        var fname = component.find("firstName").get("v.value");
        console.log('fname: '+fname);
        var lname = component.find("lastName").get("v.value");
        console.log('lname: '+lname);
        var email = component.find("emailId").get("v.value");
        console.log('email: '+email);
        var alias = fname.slice(0,1)+lname.slice(0,3);
        console.log('alias: '+alias);
        /*var action = component.get('c.registerUser');
        action.setParams({
            "lname" : lname,
            "fname" : fname,
            "email" : email,
            "uname" : uname,
            "alias" : alias
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('SUCCESS');
            }
            else{
                console.log('Error: '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);*/
	}
})