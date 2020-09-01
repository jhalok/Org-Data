import {LightningElement,wire} from 'lwc';
// import apex method reference from controller
import fatchPickListValue from '@salesforce/apex/PicklistValues.fatchPickListValue';
 
export default class GetPickListValueInLWC extends LightningElement {
//  invoke apex method with wire property and fetch picklist options.
// pass 'object information' and 'picklist field API name' method params which we need to fetch from apex
 @wire(fatchPickListValue, 
    {objInfo: {'sobjectType' : 'User'},picklistFieldApi: 'PortalRole'}) stageNameValues;
 
 onValueSelection(event){
  // eslint-disable-next-line no-alert
  alert(event.target.value);
 }                      
}