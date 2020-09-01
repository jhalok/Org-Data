({
   /* onCustomInputChange: function (component, event, helper) {
       helper.validateAndReplace(component, event);
    },*/
    Change : function(component, event, helper) {
         var dob = component.find("inputVal");
         var dateValue = dob.get('v.value');
         console.log('----dateValue----'+dateValue);
         var formattedValue = dateValue.replace(/^(\d\d)(\d)$/g,'$1/$2').replace(/^(\d\d\/\d\d)(\d+)$/g,'$1/$2').replace(/[^\d\/]/g,'');
         dob.set('v.value',formattedValue);
     },
     onChange : function(component, event, helper){
         console.log('inside ui input js mthd');
         var dob = component.find("text");
         var dateValue = dob.get('v.value');
         console.log('----dateValue----'+dateValue);
         var formattedValue = dateValue.replace(/^(\d\d)(\d)$/g,'$1/$2').replace(/^(\d\d\/\d\d)(\d+)$/g,'$1/$2').replace(/[^\d\/]/g,'');
         console.log('--formattedValue--'+formattedValue);
         dob.set('v.value',formattedValue);
     }
})