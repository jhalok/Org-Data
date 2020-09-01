({
    createExpense: function(component, expense) {
        var theExpenses = component.get("v.newAcc");
 
        // Copy the expense to a new object
        // THIS IS A DISGUSTING, TEMPORARY HACK
        var newExpense = JSON.parse(JSON.stringify(expense));
 
        theExpenses.push(newAcc);
        component.set("v.newAcc", theExpenses);
    }
})