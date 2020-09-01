import { LightningElement,api,track } from 'lwc';
import getResults from '@salesforce/apex/MultiSelect_LwcController.getResults';
import Name from '@salesforce/schema/Account.Name';
import Phone from '@salesforce/schema/Account.Phone';
import { NavigationMixin } from 'lightning/navigation';
//import Account from '@salesforce/schema/Account';
//import Name from '@salesforce/schema/Account.Name';

import { getRecord } from 'lightning/uiRecordApi';
const FIELDS = [
    'Account.Name',
    'Account.Industry',
    'Account.Phone',
];

let columns = [{
    label: 'Id',
    fieldName: 'Id'
},
{
    label: 'Name',
    fieldName: 'Name',
},
{
    label: 'Phone',
    fieldName: 'Phone',
},
/*{
    label: 'User Profile',
    fieldName: 'profileName'
},
{
    label: 'User Role',
    fieldName: 'roleName'
},
{
    type: 'action',
    initialWidth: 90,
    typeAttributes: {
        rowActions: actions,
        variant: 'base',
        size: 'large',
        //menuAlignment: 'right'
    }
},*/
];


export default class MultiSelect_LWC extends NavigationMixin(LightningElement) {
    @api objectName = 'Account';
    @api fieldName = 'Phone';
    //@api fieldName = 'Phone';
    @api Label;
    @track searchRecords = [];
    @track selectedRecords = [];
    @track selectedItem = [];
    @api required = false;
    @api iconName = 'action:new_account'
    @api LoadingText = false;
    @track txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    @track messageFlag = false;
    @track openmodel = false;
    @track showResults = false;
    @track columns = columns;
    @track showAllSelectedData = false; 
    @track newsObject = []; 
    @track selRecords = [];
    @track multiSearch = false; 
    @track singleSearch = false; //To show by default single search 

    
    searchField(event) {
        console.log('inside searchField');
        this.multiSearch = true; // for multisearch keep this true
        var currentText = event.target.value;
        console.log('currentText------'+currentText);
        var selectRecId = [];
        for(let i = 0; i < this.selectedRecords.length; i++){
            selectRecId.push(this.selectedRecords[i].Id);
        }
        console.log('selectedRecord'+selectRecId);
        this.LoadingText = true;
        getResults({ ObjectName: this.objectName, value: currentText, selectedRecId : selectRecId })
        .then(result => {
            console.log('result------'+JSON.stringify(result));
            this.searchRecords= result;
            console.log('returned results-------'+JSON.stringify(this.searchRecords));
            this.LoadingText = false;
            
            this.txtclassname =  result.length > 0 ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
            console.log('this.txtclassname--------'+this.txtclassname);
            if(currentText.length > 0 && result.length == 0) {
                this.messageFlag = true;       
            }
            else {
                this.messageFlag = false;
            }
        })
        .catch(error => {
            console.log('error------------'+JSON.stringify(error));
            console.log(error);
        });
        
    }
    
    setSelectedRecord(event) {
        this.showAllSelectedData = true; // for multisearch data keep this true
        var recId = event.currentTarget.dataset.id;
        var selectName = event.currentTarget.dataset.name;
        console.log('selectName---'+selectName);
        //var selectPhone = event.detail.row;
        //console.log('row-----'+selectPhone);
        var selectPhone = event.currentTarget.dataset.phone;
    
        console.log('selectPhone---'+selectPhone);
        if(selectPhone != undefined){
            let newsObject = { 'Id' : recId ,'Name' : selectName , 'Phone': selectPhone };
            this.selectedRecords.push(newsObject);
        }
       
       
        this.txtclassname =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        this.selRecords = this.selectedRecords;
        console.log('newly pushed data----'+JSON.stringify(this.selRecords));
        var newOne = [];
        for(let i = 0; i <this.selRecords.length; i++){
            newOne.push(this.selRecords[i]);
        }
        console.log('newOneeeee------'+JSON.stringify(newOne));
        var newData = this.selRecords;
        this.selectedRecords = [...newOne];
        
        let selRecords = this.selectedRecords;
        let selRecordsWithName = selRecords.Name;
        //console.log('selRecords-----'+JSON.stringify(this.selRecords));
        //console.log('selRecordsWithName-----'+JSON.stringify(selRecordsWithName));
        this.template.querySelectorAll('lightning-input').forEach(each => {
            each.value = '';
        });
        const selectedEvent = new CustomEvent('selected', selRecords.Name );
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }


    removeRecord (event){
        console.log('inside removeRecord');
        let selectRecId = [];
        for(let i = 0; i < this.selectedRecords.length; i++){
            if(event.detail.name !== this.selectedRecords[i].Id)
                selectRecId.push(this.selectedRecords[i]);
        }
        this.selectedRecords = [...selectRecId];
        console.log('this.selectedRecords-----'+JSON.stringify(this.selectedRecords));
        let selRecords = this.selectedRecords;
        /*if(this.selectedRecords.length == 0){
            this.showResults = false;
        }*/
        const selectedEvent = new CustomEvent('selected', { detail: {selRecords}, });
        console.log('selectedEvent----'+selectedEvent);
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

    handleItemClicked(event) {
        console.log('inside handleItemClicked');
        event.preventDefault();
        event.stopPropagation();
        this.selectedItem = event.target.dataset.recordId;
        console.log('this.selectedItem---------'+this.selectedItem);
        this.showResults = true;
        //this.openModal(this.selectedItem);
        //this.navigateToRecordViewPage(event.target.dataset.recordId);
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.selectedItem,
                    objectApiName: 'Account',
                    actionName: 'view'
                },
        }); 
    }
}