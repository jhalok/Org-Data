({
  createAccount : function(component, event) {
    var newAcc = component.get("v.newAccount");
      console.log(newAcc);
    var action = component.get("c.saveAccount");
      console.log(action);
    action.setParams({ "acc": newAcc});
    action.setCallback(this, function(a) {
           var state = a.getState();
            if (state === "SUCCESS") {
                var name = a.getReturnValue();
                console.log(name);
               alert("hello from here"+name);
            }
        });
    $A.enqueueAction(action)
}
})