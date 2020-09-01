({
	doInit : function(component, event, helper) {
		//alert('inside doInit');
        console.log('inside doinit');
		helper.rtrvList(component, event);
	},
	metaDataList : function(component, event, helper){
		console.log('metaDataList do Init called');
		helper.rtrvMetaDataList(component, event);
	},
	slctdVal : function(component, event, helper){
		component.find("curntSlctdVal").get("v.value");
		console.log('selected Val'+component.find("curntSlctdVal").get("v.value"));
		//helper.rtrvList(component, event);
		//helper.reterieveMetaDataItem(component, event);
	},
	metaDataItemList :  function(component, event, helper){
		//console.log('metaDataItemList do Init called');
		helper.reterieveMetaDataItem(component, event);
	},
	reterieveMetaData : function(component, event, helper){
		console.log('metaDataItemList do Init called');
		helper.reterieveMetaDataZip(component, event);
	},
	extractZip : function(component, event, helper){
		console.log('in extractZip()');
		helper.unZipFile(component, event);
	}
})