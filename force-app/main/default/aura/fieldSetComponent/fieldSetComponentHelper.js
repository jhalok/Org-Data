({
    configMap: {
        "string": { 
            componentDef: "lightning:input", 
            attributes: { 
                "aura:id": "findableAuraId",
                "class" : "",
            } 
        },        
        "button" : {
            componentDef : "lightning:button",
            attributes : {
                "aura:id": "findableAuraId",
                "variant" : "brand",
                "label" : "Submit Form",
                "class" : "slds-align_absolute-center"
            }
        },
        "picklist" : {
            componentDef : "lightning:select",
            attributes : {
                 "aura:id": "findableAuraId",
                "class" : "slds-select slds-select_container"
            }
        },
        "textarea" : {
            componentDef : "lightning:textarea",
            attributes : {
                "aura:id": "findableAuraId",
                "class" : ""
            }
        },
    },
    getdata : function(component, event, helper) {
        console.log("action doInit"+action);
        var action = component.get("c.getObjects");      
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var Objects = response.getReturnValue();
                var listOptions = [];
                listOptions.push({
                    label : '--None--',
                    value : ''
                });
                for(var i=0; i <Objects.length; i++){
                    listOptions.push({
                        label : Objects[i].split(',')[1],
                        value : Objects[i].split(',')[0]
                    });
                }
                console.log("Objects"+Objects);
                component.set("v.Objects", listOptions);                
            } 
        });
        $A.enqueueAction(action);
    },
   	getObjectsFieldSet: function(component, event, helper) {
        component.set("v.theForm",[]);
        component.set("v.showFieldSet",true);
        component.set("v.showFieldSetRecords",false);
        console.log("alok");  
        var action = component.get("c.getFieldSet");
        var selectedObject = component.find('selectedObject').get('v.value');
        console.log("selectedObject"+selectedObject);
        action.setParams({
            "sObjectName" :  selectedObject 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("state"+state);
            if(state === "SUCCESS"){
                var fieldsets = response.getReturnValue();
                var listOptions = [];
                listOptions.push({
                    label : '--None--',
                    value : ''
                });
                for(var i=0; i <fieldsets.length; i++){
                    listOptions.push({
                        label : fieldsets[i].split(',')[1],
                        value : fieldsets[i].split(',')[0]
                    });
                }
                component.set("v.fieldsets",listOptions);
            }
        });
         $A.enqueueAction(action);
    },
    getFieldSetMember :function(component, event, helper){
        component.set("v.showFieldSetRecords",false);
        component.set("v.showFieldSet",true);
        var self =this;
        var selectedObject = component.find('selectedObject').get("v.value");
        var selectedFieldSet = component.find('selectedFieldSet').get("v.value");
        var action = component.get("c.getFieldSetMember");
        action.setParams({
            "objectName":selectedObject,
            "fieldSetName":selectedFieldSet
        });
       action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var fieldSetMember = JSON.parse(response.getReturnValue());
                self.createForm(component, event, helper, fieldSetMember);
            }
        });
     $A.enqueueAction(action);
    },
    createForm : function(component, event, helper, fieldSetMember){
        component.set("v.showFieldSetRecords",true);
        var lightningInputMap = new Map();
        lightningInputMap.set('string','string');
        lightningInputMap.set('checkbox','checkbox');
        lightningInputMap.set('date','date');
        lightningInputMap.set('datetime','datetime');
        lightningInputMap.set('email','email');
        lightningInputMap.set('tel','tel');  
        lightningInputMap.set('number','number');
          
        var inputDesc = [];
        var config = null;   
       
        for(var i=0; i < fieldSetMember.length; i++){
            var objectName = component.getReference("v.sObjectName");
            if(lightningInputMap.has(fieldSetMember[i].fieldType.toLowerCase())){
                   console.log("y"+lightningInputMap.has(fieldSetMember[i].fieldType.toLowerCase()));
                config = JSON.parse(JSON.stringify(this.configMap['string'])); 
				console.log("configfrst"+JSON.stringify(config));
                if(config){
                    config.attributes.label = fieldSetMember[i].fieldLabel;
                    config.attributes.type = fieldSetMember[i].fieldType;
                    config.attributes.required =fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                    config.attributes.value = component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);
                      inputDesc.push([
                        config.componentDef,
                        config.attributes
                    ]);
                }
            }else{
                if(fieldSetMember[i].fieldType.toLowerCase() === 'integer'){
                    config = JSON.parse(JSON.stringify(this.configMap['string']));
                    config.attributes.label = fieldSetMember[i].fieldLabel;
                    config.attributes.type = 'number';
                    config.attributes.required = fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                    config.attributes.value = component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);
                    inputDesc.push([
                        config.componentDef,
                        config.attributes
                    ]);
                }else if(fieldSetMember[i].fieldType.toLowerCase() === 'phone'){
                    config = JSON.parse(JSON.stringify(this.configMap['string']));
                    config.attributes.label = fieldSetMember[i].fieldLabel;
                    config.attributes.type = 'tel';
                    config.attributes.required = fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                    config.attributes.value = component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);
                    inputDesc.push([
                        config.componentDef,
                        config.attributes
                    ]);
                }else if(fieldSetMember[i].fieldType.toLowerCase() === 'textarea'){
                    config = JSON.parse(JSON.stringify(this.configMap['textarea']));
                    config.attributes.label = fieldSetMember[i].fieldLabel;
                    config.attributes.name = fieldSetMember[i].fieldLabel;
                    config.attributes.required = fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                    config.attributes.value = component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);
                    inputDesc.push([
                        config.componentDef,
                        config.attributes
                    ]);
                }else if(fieldSetMember[i].fieldType.toLowerCase() === 'picklist'){
                    config = JSON.parse(JSON.stringify(this.configMap['picklist']));
                    config.attributes.label = fieldSetMember[i].fieldLabel;
                    config.attributes.name = fieldSetMember[i].fieldLabel;
                    var pickList = fieldSetMember[i].pickListValues;
                    var options = [];
                    for(var k=0; k<pickList.length; k++){
                        if(pickList[k].active){
                            options.push({
                                value : pickList[k].value,
                                label : pickList[k].label
                            });
                        }
                    }
                    config.attributes.options = options;
                    config.attributes.required = fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                    config.attributes.value = component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);
                    inputDesc.push([
                        config.componentDef,
                        config.attributes
                    ]);
                }
            }
        }
        var newConfig = JSON.parse(JSON.stringify(this.configMap['button']));
        console.log(JSON.parse(JSON.stringify(newConfig)));
        newConfig.attributes.onclick = component.getReference("c.handlePress");
        inputDesc.push([
           newConfig.componentDef,
           newConfig.attributes
        ]);
        
        $A.createComponents(inputDesc,function(components, status, errorMessage){
                                if (status === "SUCCESS") {
                                    var form = [];
                                    for(var j=0; j < components.length; j++){
                                        form.push(components[j]);
                                    }
                                    component.set("v.theForm", form);
                                }
                            });
    },
     onUpserObject : function(component, event, helper){
        var self =this;
        var upsertObject = component.get('c.doUpsertObjects');
        upsertObject.setParams({
            "objectData" :component.get('v.sObjectName')
        });
        upsertObject.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && (state === 'SUCCESS')){
                var upsertedRecord = JSON.parse(response.getReturnValue());
                this.toast(component, event, helper);
            }
        });
        $A.enqueueAction(upsertObject);
        //document.location.reload(true);     
    },
    toast :function(event){
    var toastEvent = $A.get("e.force:showToast");
            	toastEvent.setParams({
                title : '',
                message: 'Record inserted succesfully.',
                duration:' 8000',
                key: 'info_alt',
                type: 'success',
                mode: 'pester'
            });
            toastEvent.fire();
	}
})