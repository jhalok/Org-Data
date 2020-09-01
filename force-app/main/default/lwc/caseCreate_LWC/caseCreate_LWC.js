import { LightningElement, wire, api, track } from 'lwc';
import fetchRecords from '@salesforce/apex/CaseCreateController.fetchRecords';
//import updateRecords from '@salesforce/apex/CaseCreateController.updateRecords';
//import deleteSObject from '@salesforce/apex/CaseCreateController.deleteSObject';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getResults from '@salesforce/apex/CaseCreateController.getResults';
import Product__c from '@salesforce/schema/Case.Product__c';
import Type from '@salesforce/schema/Case.Type';
import Status from '@salesforce/schema/Case.Status';
import Origin from '@salesforce/schema/Case.Origin';
import Subject from '@salesforce/schema/Case.Subject';
import AccountId from '@salesforce/schema/Case.AccountId';

import { getRecord } from 'lightning/uiRecordApi';

export default class CaseCreate_LWC extends NavigationMixin(LightningElement)  {
    //for search
    @api Label;
    @track searchRecords = [];
    @track selectedRecords = [];
    @track selectedItem = [];
    @api required = false;
    @api LoadingText = false;
    @track txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    @track messageFlag = false;
    @track openmodel = false;
    @track showResults = false;
    @track showAllSelectedData = false; 
    @track newsObject = []; 
    @track selRecords = [];
    @track multiSearch = false; 

    @track showAllData = true;
    @track showSearchData = false;
    @track caseCreationFields;
    @track createCaseModel = false;

    //for datatable
    @api objectApiName;
    @api fieldNamesStr = 'Name,Account.Name,CaseNumber,Reason,Priority,Status,Subject,Title,Email';
    @api inlineEdit = false;
    @api colAction = false;
    @track data;
    @track columns;
    @track recordIds;
    @track loadMoreStatus;
    @api totalNumberOfRows;
    @track showSelected = false;
    dataAfterDelete;
  
    wiredsObjectData;
      
    @wire(fetchRecords, { ObjectName: '$objectApiName', fieldNamesStr: '$fieldNamesStr', recordId: '' , Orderby: 'Id', OrderDir: 'ASC',inlineEdit: false , enableColAction: false })
    wiredSobjects(result) {
      this.wiredsObjectData = result;
          if (result.data) {
              //console.log('result data-----'+JSON.stringify(result.data));
              this.data = result.data.sobList;
              //var accountName = result.data.Account.Name;
              //console.log('Account Name-----'+accountName);
              console.log('this.data----'+JSON.stringify(this.data));
              this.columns = result.data.ldwList;
              console.log('----this.columns'+JSON.stringify(this.columns));
              this.totalNumberOfRows = result.data.totalCount;
          }else{
          }
      }
  
      loadMoreData(event) {
              this.loadMoreStatus = 'Wait Data is Loading';
              const currentRecord = this.data;
              console.log('currentRecord----'+currentRecord);
              console.log('lenght---'+currentRecord.length);
              const lastRecId = currentRecord[currentRecord.length - 1].Id;
              console.log('lastRecId----'+lastRecId);
              fetchRecords({ ObjectName: this.objectApiName, fieldNamesStr: this.fieldNamesStr, recordId: lastRecId , Orderby: 'Id', OrderDir: 'ASC',inlineEdit:this.inlineEdit , enableColAction:this.colAction })
              .then(result => {
                  const currentData = result.sobList;
                  //Appends new data to the end of the table
                  const newData = currentRecord.concat(currentData);
                  console.log('totalNumofRows-----'+this.totalNumberOfRows);
                  this.data = newData; 
                  if (this.data.length >= this.totalNumberOfRows) {
                      this.loadMoreStatus = 'No more data to Display';
                  } else {
                      this.loadMoreStatus = '';
                  }
              })
              .catch(error => {
                  console.log('-------error-------------'+error);
                  console.log(error);
              });
          }

        //search onee........................
        searchField(event) {
            console.log('inside searchField');
            this.showAllData = false;
            this.showSearchData = true;
            this.multiSearch = true; // for multisearch keep this true
            var currentText = event.target.value;
            console.log('currentText------'+currentText);
            var selectRecId = [];
            for(let i = 0; i < this.selectedRecords.length; i++){
                selectRecId.push(this.selectedRecords[i].Id);
            }
            this.objectApiName = 'Case';
            console.log('selectedRecord'+selectRecId);
            this.LoadingText = true;
            getResults({ ObjectName: this.objectApiName , value: currentText, selectedRecId : selectRecId })
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

        caseModal(){
            console.log('inside caseModal method');
            this.createCaseModel = true;
        }

        closeModal(){
            console.log('inside closemodal');
            this.createCaseModel = false;
            setTimeout(function(){
                location.reload()
            }, 50);
        }

        caseCreationFields = [Type, Status, Origin, Subject];   
        handleSub(event){
            event.preventDefault();      
            const caseCreationFields = event.detail.fields;
            console.log('-------userCreationFields------'+JSON.stringify(caseCreationFields));
            this.template.querySelector('lightning-record-form').submit(caseCreationFields);
            /*setTimeout(function(){
                    location.reload()
            }, 1000);*/
            //this.createCaseModal = false;
        }
}