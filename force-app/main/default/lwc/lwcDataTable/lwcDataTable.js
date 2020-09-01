import { LightningElement, wire, api, track } from 'lwc';
import initRecords from '@salesforce/apex/LWCDataTableController.initRecords';
import updateRecords from '@salesforce/apex/LWCDataTableController.updateRecords';
import deleteSObject from '@salesforce/apex/LWCDataTableController.deleteSObject';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LwcDataTable extends NavigationMixin(LightningElement) {

  @api objectApiName;
  @api fieldNamesStr = 'Name,Title,Email,Phone,AccountId,LastModifiedById';
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
    
  @wire(initRecords, { ObjectName: '$objectApiName', fieldNamesStr: '$fieldNamesStr', recordId: '' , Orderby: 'Id', OrderDir: 'ASC',inlineEdit: false , enableColAction: false })
  wiredSobjects(result) {
    this.wiredsObjectData = result;
        if (result.data) {
            //console.log('result data-----'+JSON.stringify(result.data));
            this.data = result.data.sobList;
            //console.log('this.data'+this.data);
            this.columns = result.data.ldwList;
            //console.log('this.columns'+this.columns);
            this.totalNumberOfRows = result.data.totalCount;
        }else{
        }
    }

    getSelectedName(event) {
        console.log('inside getSelectedName mthd');
        var selectedRows = event.detail.selectedRows;
        var recordIds=[];
        if(selectedRows.length > 0) {
            for(var i =0 ; i< selectedRows.length; i++) {
                recordIds.push(selectedRows[i].Id);
            }
            this.showSelected = true;
            console.log('recordIds---'+recordIds);
           const selectedEvent = new CustomEvent('selected', { detail: {recordIds}, });
           // Dispatches the event.
           this.dispatchEvent(selectedEvent);
        }
        
    }

    loadMoreData(event) {
            //Display a spinner to signal that data is being loaded
            //Display "Loading" when more data is being loaded
            this.loadMoreStatus = 'Loading';
            const currentRecord = this.data;
            console.log('currentRecord----'+currentRecord);
            console.log('lenght---'+currentRecord.length);
            const lastRecId = currentRecord[currentRecord.length - 1].Id;
            console.log('lastRecId----'+lastRecId);
            initRecords({ ObjectName: this.objectApiName, fieldNamesStr: this.fieldNamesStr, recordId: lastRecId , Orderby: 'Id', OrderDir: 'ASC',inlineEdit:this.inlineEdit , enableColAction:this.colAction })
            .then(result => {
                const currentData = result.sobList;
                //Appends new data to the end of the table
                const newData = currentRecord.concat(currentData);
                this.data = newData; 
                if (this.data.length >= this.totalNumberOfRows) {
                    this.loadMoreStatus = 'No more data to load';
                } else {
                    this.loadMoreStatus = '';
                }
            })
            .catch(error => {
                console.log('-------error-------------'+error);
                console.log(error);
            });
        }

        handleRowAction(event) {
            event.preventDefault();
            event.stopPropagation();
            const actionName = event.detail.action.name;
            const row = event.detail.row;
            switch (actionName) {
            case 'edit':
                this.editRecord(row);
                break;
            case 'view':
                this.viewRecord(row);
                break;
            case 'delete':
                this.deleteRecord(row);
                break;
            default:
                this.viewRecord(row);
                break;
            }
        }
    
		//currently we are doing client side delete, we can call apex tp delete server side
        deleteRecord(row) {
            console.log('delete id'+JSON.stringify(row));
            this.deleteData(row.Id);
            /*const { id } = row;
            const index = this.findRowIndexById(id);
            if (index !== -1) {
                this.data = this.data
                    .slice(0, index)
                    .concat(this.data.slice(index + 1));
            }*/
            
        }

        deleteData(row) {
            console.log('inside deleteData-----'+row);
            deleteSObject(row)
                .then(result => {
                    this.result = result;
                    console.log('result-----'+JSON.stringify(this.result));
                })
                .catch(error => {
                    this.error = error;
                    console.log('error-----'+JSON.stringify(this.error));
                });
        }

        /*delete(row){
        @wire(deleteSObject, { ObjectName: this. })
        wiredSobjects(result) {
        this.dataAfterDelete = result;
        console.log('this.dataAfterDelete'+this.dataAfterDelete);
        if (result.data) {
            console.log('result data-----'+JSON.stringify(result.data));
            this.data = result.data.sobList;
            console.log('this.data'+this.data);
            this.columns = result.data.ldwList;
            console.log('this.columns'+this.columns);
            this.totalNumberOfRows = result.data.totalCount;
        }else{
        }
        }
    }*/
    
        findRowIndexById(id) {
            let ret = -1;
            this.data.some((row, index) => {
                if (row.id === id) {
                    ret = index;
                    return true;
                }
                return false;
            });
            return ret;
        }
    

        editRecord(row) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: row.Id,
                    actionName: 'edit',
                },
            });
        }
        
        viewRecord(row) {
            console.log('-----insidde view----'+JSON.stringify(row));
            console.log('-----insidde view----'+row.Id);
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: row.Id,
                    actionName: 'view'
                },
            }); 
        }

		//When save method get called from inlineEdit
        handleSave(event) {

            var draftValuesStr = JSON.stringify(event.detail.draftValues);
            updateRecords({ sobList: this.data, updateObjStr: draftValuesStr, objectName: this.objectApiName })
            .then(result => {
                console.log('result----'+result);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Records updated',
                        variant: 'success'
                    })
                );
                // Clear all draft values
                this.draftValues = [];
                return refreshApex(this.wiredsObjectData);
            })
            .catch(error => {
                console.log('-------error-------------'+JSON.stringify(error));
                console.log(error);
            });

        }

        // The method will be called on sort click
        updateColumnSorting(event) {
            var fieldName = event.detail.fieldName;
            var sortDirection = event.detail.sortDirection;    
       }
}