({
	billing : function(component, event, helper) {
       component.set("v.showProduct",true);
       component.set("v.showBilling",false);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success Message',
            message: 'Products are added to cart successfully.',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
	},   
    doInit : function (component, event, helper) {
        var action = component.get("c.getItems");
        action.setCallback(this,function (response) { 
        	var prodItem = response.getReturnValue();
            console.log(prodItem);
            component.set("v.items",prodItem);
        });
        var obj ={
            "ShippingAddress":'',
            "ShippingCity":'',
            "ShippingState":'',
            "ShippingZip":'',
            "ShippingCountry":'',
            "BillingAddress":'',
            "BillingCity":'',
            "BillingState":'',
            "BillingZip":'',
            "BillingCountry":'',
            "CardNum":'',
            "ExpDate":'',
            "Year":'',
            "CVV":'',
            "FullName":'', 
        };
        var arr=[obj];
        component.set("v.billingDetails",arr);
        $A.enqueueAction(action);
    },
    CalcSum : function(component, event, helper) {
        var quant = component.find("ttlNo");    
        var ttlPrc = component.get("v.items");
        var amount = 0;
     	 for(var i = 0; i < ttlPrc.length;i++){
                    if(!$A.util.isEmpty(ttlPrc[i].PricebookEntries)) {
                        for(var j=0;j<ttlPrc[i].PricebookEntries.length;j++){
                           if(ttlPrc[i].Quantity__c){
              		       amount+=ttlPrc[i].PricebookEntries[j].UnitPrice*ttlPrc[i].Quantity__c; 
                           }
                        }
            		}
                 }
         component.set("v.amount",amount);
    },
    Payment : function(component,event,helper){
     var billingList =component.get('v.billingDetails');
  
 	 var billingjson ='{ "createTransactionRequest": { "merchantAuthentication": { "name": "85uCz9GNs", "transactionKey": "9TzEt3P75t5kw2MT" }, "refId": "123456", "transactionRequest": { "transactionType": "authCaptureTransaction", "amount": "5", "payment": { "creditCard": { "cardNumber": '+billingList.CardNum+', "expirationDate": "2020-11", "cardCode": '+billingList.cvv+' } }, "lineItems": { "lineItem": { "itemId": "1", "name": "vase", "description": "Cannes logo", "quantity": "18", "unitPrice": "45.00" } }, "tax": { "amount": "4.26", "name": "level2 tax name", "description": "level2 tax" }, "duty": { "amount": "8.55", "name": "duty name", "description": "duty description" }, "shipping": { "amount": "4.26", "name": "level2 tax name", "description": "level2 tax" }, "poNumber": "456654", "customer": { "id": "99999456654" }, "billTo": { "firstName": "Alok", "lastName": "jha", "company": "Souveniropolis", "address": "kpv", "city": "kpv", "state": "uk", "zip": "44713", "country": "india" },"shipTo": { "firstName": "Alok", "lastName": "jha", "company": "Thyme for Tea", "address": "kpv", "city": "uk", "state": "uk", "zip": "244713","country": "India"}, "customerIP": "192.168.1.1", "transactionSettings": { "setting": { "settingName": "testRequest", "settingValue": "false" } }, "userFields": { "userField": [ { "name": "MerchantDefinedFieldName1", "value": "MerchantDefinedFieldValue1" }, { "name": "favorite_color", "value": "blue" } ] } } } }';
        
      console.log(billingList.ShippingAddress);
      var validExpense = component.find('expenseform').reduce(function (validSoFar, inputCmp) {
      inputCmp.showHelpMessageIfInvalid();
      return validSoFar && inputCmp.get('v.validity').valid;
       }, true);
        if(validExpense){
           var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success Message',
            message: 'Payment is done suucessfully.',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
        }else{
           var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning Message',
            message: 'Please fill out the form properly.',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
        }
        var action =component.get("c.makePayment"); 
        action.setParams({"jsonStr":billingjson});  
         $A.enqueueAction(action);
    },
    backToProduct : function(component, event, helper) {
        component.set("v.showBilling",true);
        component.set("v.showProduct",false);
    }
})