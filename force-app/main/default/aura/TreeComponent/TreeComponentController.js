({
    fetchAccounts : function(component, event, helper) {
        var columns = [
            {
                type: 'text',
                fieldName: 'Name',
                label: 'Account Name'
            },
            {
                type: 'text',
                fieldName: 'Industry',
                label: 'Industry'
            },
            {
                type: 'text',
                fieldName: 'FirstName',
                label: 'First Name'
            },
            {
                type: 'text',
                fieldName: 'LastName',
                label: 'Last Name'
            },
            {
                type: 'email',
                fieldName: 'Email',
                label: 'Email'
            }
        ];
        component.set('v.gridColumns', columns);
        var action = component.get("c.fetchAccts");
        action.setCallback(this, function(response){
            var state = response.getState();
            if ( state === "SUCCESS" ) {
                var data = response.getReturnValue();
                console.log('response :'+JSON.stringify(data));
                for ( var i=0; i<data.length; i++ ) {
                    data[i]._children = data[i]['Contacts'];  
    				delete data[i].Contacts; 
                }
                component.set('v.gridData', data);
            }
        });
        $A.enqueueAction(action);
    }
})