import {LightningElement,track,wire,api } from 'lwc';
import getActiveUserList from '@salesforce/apex/userInfoData.getActiveUserList';
import getInActiveUserList from '@salesforce/apex/userInfoData.getInActiveUserList'; 
import sendResetPasswordMail from '@salesforce/apex/userInfoData.sendResetPasswordMail';
import moreDataLoad from '@salesforce/apex/userInfoData.moreDataLoad';

import deactivateUser from '@salesforce/apex/userInfoData.deactivateUser'; 
import User from '@salesforce/schema/User';
import Email from '@salesforce/schema/User.Email';
import FirstName from '@salesforce/schema/User.FirstName';
import LastName from '@salesforce/schema/User.LastName';
import TimeZoneSidKey from '@salesforce/schema/User.TimeZoneSidKey';
//import Profile from '@salesforce/schema/User.Profile';
import LocaleSidKey from '@salesforce/schema/User.LocaleSidKey';
import EmailEncodingKey from '@salesforce/schema/User.EmailEncodingKey';
import LanguageLocaleKey from '@salesforce/schema/User.LanguageLocaleKey';
import Phone from '@salesforce/schema/User.Phone';
import Username from '@salesforce/schema/User.Username';
import MobilePhone from '@salesforce/schema/User.MobilePhone';
import ProfilePL1__c from '@salesforce/schema/User.ProfilePL1__c';
import Alias from '@salesforce/schema/User.Alias';
import Title from '@salesforce/schema/User.Title';
import CommunityNickname from '@salesforce/schema/User.CommunityNickname';
//import RoleId from '@salesforce/schema/User.RoleId';
//import UserRole from '@salesforce/schema/User.UserRole';
import ProfileId from '@salesforce/schema/User.ProfileId';
import UserRoleId from '@salesforce/schema/User.UserRoleId';

import { loadStyle } from 'lightning/platformResourceLoader';

import LWCPagination from '@salesforce/resourceUrl/LWCPagination';
//import LWCPagination from ‘@salesforce/resourceUrl/LWCPagination‘;
// importing to show toast notifictions
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

// importing to refresh the apex if any record changes the datas
import {refreshApex} from '@salesforce/apex';

let actions= [
    { label: 'View Information', name: 'edit'}, 
    { label: 'Edit Email', name: ''}, 
    { label: 'Reset Password', name: 'reset'},
    { label: 'Deactivate User', name: 'deactivate'},
    { label: 'uploadFile', name: 'upload'}
];

let actionforDeactivated = [
    { label: 'View Information', name: 'edit'},
    { label: 'Activate User', name: 'activate'}
];
   

let columns = [/*{
        label: '',
        type: '',
        initialWidth: 5,
        typeAttributes: {
            iconName: '',
            //title: 'Preview',
            variant: 'base',
            //alternativeText: 'View'
            
        }
    },*/
    {
        label: 'Name',
        fieldName: 'Name'
    },
    {
        label: 'Email',
        fieldName: 'Email',
    },
    {
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
    },
   /* {
        label: '',
        type: 'buttonMenu',
        initialWidth: 75,
        typeAttributes: {
            iconName: 'utility:down',
            //title: 'Preview',
            variant: 'base',
            //alternativeText: 'View'
            
        }
    }*/
];

let columnData = [
{
    label: 'Name',
    fieldName: 'Name'
},
{
    label: 'Email',
    fieldName: 'Email',
},
{
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
        rowActions: actionforDeactivated,
        variant: 'base',
        size: 'large',
    }
}
];

export default class userInformationPgn extends LightningElement {
    @track loadMoreStatus;
    @track columnData = columnData;
    @track data = [];
    @track dataa = [];
    @track bShowModal = false;
    @track currentRecordId;
    @track isEditForm = false;
    @track showLoadingSpinner = false;
    @track columns = columns;
    //@track currentPageData = [];
    storeUsersEmailId;
    @track currentPageData = [];
    @track currentPage = [];
    @track curntId;
    @track createtUsrModel = false;
    @track showLoadingSpinner = false;
    @track activeStatus;
    @track currentData;
    //@track actions;
    //@track rowActions;
 
    
    connectedCallback() {
        console.log('inside connectedCallback');
        Promise.all([
            loadStyle(this, LWCPagination + '/pagination.css'),
        ])
            .then(() => {
                //alert('Files loaded.');
            })
            .catch(error => {
               // alert(error.body.message);
            });

           
        getActiveUserList()
        .then(result=>{
            console.log(JSON.stringify(result));
            this.data = result;
            console.log('---active data---'+JSON.stringify(this.data));
            if (this.data) {
                this.refreshTable = this.data;
                //console.log('data-------'+JSON.stringify(this.data));
                let currentData = [];
                this.data.forEach((row) => {
                    let rowData = {};
                    rowData.Id = row.Id;
                    rowData.Name = row.Name;
                    rowData.Email = row.Email;
                    rowData.SmallPhotoUrl = row.SmallPhotoUrl;
                    rowData.FirstName = row.FirstName;
                    rowData.LastName = row.LastName;
                    rowData.IsActive = row.IsActive;
                    //console.log('---rowData.NAme----'+rowData.Name);
                    //Profile related data
                    if (row.Profile) {
                        rowData.profileName = row.Profile.Name;
                        //console.log('---prfl name'+rowData.profileName);
                    }
                    //UserRole releated data
                    if (row.UserRole) {
                        rowData.roleName = row.UserRole.Name;
                    }
                    currentData.push(rowData);
                });
                console.log(' mera data ye rha : '+JSON.stringify(currentData));
                this.data = currentData;
                this.currentPageData = this.data;            
        }
    })
        .catch(error =>{
            //console.log(error);
    });
    }    
    


    @wire(getInActiveUserList)
    userInactivedata({ error, data }) {
        if (data) {
            //console.log('data-------'+JSON.stringify(data));
            let currentData = [];
            data.forEach((row) => {
                let rowData = {};
                rowData.Id = row.Id;
                rowData.Name = row.Name;
                rowData.Email = row.Email;
                rowData.SmallPhotoUrl = row.SmallPhotoUrl;
                rowData.FirstName = row.FirstName;
                rowData.LastName = row.LastName;
                rowData.IsActive = row.IsActive;
                //console.log('---rowData.SmallPhotoUrl----'+rowData.SmallPhotoUrl);
                //Profile related data
                if (row.Profile) {
                    rowData.profileName = row.Profile.Name;
                    //console.log('---prfl name'+rowData.profileName);
                }
                //UserRole releated data
                if (row.UserRole) {
                    rowData.roleName = row.UserRole.Name;
                }
                currentData.push(rowData);
            });
            this.dataa = currentData;
            this.currentPageData = this.data;
            console.log('after push data'+JSON.stringify(this.data));
        }
        else if(error) {
            window.console.log(error);
        }
    }

    userCreationFields = [FirstName,CommunityNickname,LastName,UserRoleId,Email,ProfileId,Title,Phone,Username,ProfilePL1__c,MobilePhone,TimeZoneSidKey,LanguageLocaleKey,LocaleSidKey,TimeZoneSidKey,EmailEncodingKey];
    //TimeZoneSidKey,LanguageLocaleKey,LocaleSidKey,TimeZoneSidKey,EmailEncodingKey
    handleSub(event){
        event.preventDefault();      
        const userCreationFields = event.detail.fields;
        console.log('-------userCreationFields------'+JSON.stringify(userCreationFields));
        userCreationFields.Alias = 'test';
        this.template.querySelector('lightning-record-form').submit(userCreationFields);
        setTimeout(function(){
                location.reload()
            }, 5000);
        //this.createtUsrModel = false;
    }
    
    myFields = [Email];
    sendEmail(){
        //console.log('inside sendEmail method');
        //console.log('storedEmailId'+this.storeUsersEmailId);
        this.emailResetData();
    }

    emailResetData(){
    console.log('inside emailResetData');
    console.log('this.storeUsersEmailId'+this.storeUsersEmailId);
    sendResetPasswordMail({userId:this.storeUsersEmailId,Dataa:true})
      .then(result => { 
          this.messageFromImperative = result 
          this.openmodel = false;
          this.successToast();
        })
      .catch(error => { this.errorFromImperative = error })
    }

    //Method to deactivate Active user
    deactivateUser(currentRow){
        console.log('inside deactivate user'+currentRow);
        console.log('Id'+currentRow.Id);
        this.curntId = currentRow.Id;
        this.activeStatus = currentRow.IsActive;
        console.log('curntID'+this.curntId);
        //console.log('storedEmailId'+this.storeUsersEmailId);
        deactivateUser({userId:this.curntId})
        .then(result => { this.messageFromImperative = currentRow.Id;
            console.log('this.messageFromImperative'+this.messageFromImperative);
            if(this.activeStatus){
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'User is deactivated.',
                    variant: 'Success'
                }),
                );
                location.reload()
               // eval("$A.get('e.force:refreshView').fire();");
               /* console.log('###########------------new array in active users'+JSON.stringify(this.data));
               
                this.currentPageData = [this.currentPageData, this.data];
                console.log('---inside active %%%%%-----'+JSON.stringify(this.currentPageData));
                */
                //this.currentPageData = this.data;
            }else{
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'User is activated.',
                    variant: 'Success'
                }),
                );
                window.location.reload()
                //eval("$A.get('e.force:refreshView').fire();");
               /* console.log('###########------------new array in deactivated users'+JSON.stringify(this.dataa));
                this.currentPage = [this.currentPage, this.dataa];
                console.log('------inside deactive !!!!!='+JSON.stringify(this.currentPage));*/
                //this.currentPage = this.dataa;
            }
        })
        .catch(error => { this.errorFromImperative = error  
            //console.log('this.errorFromImperative'+JSON.stringify(this.errorFromImperative));
            //console.log('this.errorFromImperative.body.message'+JSON.stringify(this.errorFromImperative.body.message));
            //console.log('without stringify'+this.errorFromImperative.body.message);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!!',
                message: this.errorFromImperative.body.message,
                variant: 'Error'
            }),
            );
        })
    }

    //Event to track which one is the active tab
    @track selectedTab = "ACTIVE USERS";
    @track tabbb;
    tabselect(event) {  
        this.selectedTab =  event.target.label;
        this.tabbb = event.target.label;
        if(this.selectedTab === "ACTIVE USERS"){
            this.tabbb = ""
            console.log('inside if'+this.selectedTab);
            this.currentPageData = this.data;
            console.log('---this.currentPageData active'+this.currentPageData);
            console.log('-----this.userdata'+this.userdata);
            this.selectedTab = "ACTIVE USERS"
        }else if(this.tabbb === "DEACTIVATED USERS"){
            this.selectedTab = ""
            console.log('inside elsetabbb'+this.tabbb);
            console.log('actions'+JSON.stringify(actions));
            console.log('columns'+JSON.stringify(columns));
            this.currentPage = this.dataa;
            console.log('---this.currentPageData inactive'+this.currentPage);
            console.log('-----this.userInactivedata'+this.userInactivedata);
            this.tabbb = "DEACTIVATED USERS"
        }
    }

    //Method to show the data in the edit mode
    editCurrentRecord(currentRow) {
        // open modal box
        this.bShowModal = true;
        this.isEditForm = true;

        // assign record id to the record edit form
        this.currentRecordId = currentRow.Id;
        //console.log('curnt rcd id'+this.currentRecordId);
        this.currentRecordProfile = currentRow.profileName;
        //console.log('this.currentRecordProfile--------------------'+this.currentRecordProfile);
        this.currentRecordRole = currentRow.roleName;
        //console.log('this.currentRecordProfile--------------------'+this.currentRecordRole);
        this.currentRecordImage = currentRow.SmallPhotoUrl;
        //console.log('curnt rcd NAmeeeeeeeeeeeeeeeeeeeee'+this.currentRecordImage);
        this.currentRecordFirstName = currentRow.FirstName;
        //console.log('curnt rcd FirstName'+this.currentRecordFirstName);
        this.currentRecordLastName = currentRow.LastName;
        //console.log('curnt rcd LastName'+this.currentRecordLastName);
        this.currentRecordEmail = currentRow.Email;
        //console.log('Email id '+this.currentRecordEmail);
    }

    @track openmodel = false;
    openmodal(currentRow) {
        this.record = currentRow;
        //console.log('------curntRow Data in OpenModal------'+JSON.stringify(this.record));
        this.storeUsersEmailId = currentRow.Id;
        console.log('this.storeUSersEmailId'+this.storeUsersEmailId);
        this.currentRowEmail = currentRow.Email;
        this.openmodel = true;
    }
 
    closeModal() {
        this.openmodel = false;
        this.bShowModal = false;
        this.createtUsrModel = false;
    }
    
    /*@track openmodel1 = false;
    openmodal1(currentRow) {
        this.record = currentRow;
        //console.log('------curntRow Data in OpenModal------'+JSON.stringify(this.record));
        this.storeUsersEmailId = currentRow.Id;
        //this.currentRowEmail = currentRow.Email;
        this.openmodel1 = true;
    }
 
    closeModal1() {
        this.openmodel1 = false;
        this.bShowModal1 = false;
        this.createtUsrModel1 = false;
    }

    get recordId(){
        console.log('curnt usr id'+this.storeUsersEmailId);
        return this.storeUsersEmailId;
        
        //'5006F00002bef2cQAA';
    }
   
    // accepted parameters
    get acceptedFormats() {
        return ['.pdf', '.png','.jpg','.jpeg','.doc','.csv'];
    }
    handleUploadFinished(event) {
        let strFileNames = '';
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;

        for(let i = 0; i < uploadedFiles.length; i++) {
            strFileNames += uploadedFiles[i].name + ', ';
        }
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success!!',
                message: strFileNames + ' Files uploaded Successfully!!!',
                variant: 'success',
            }),
        );
    }*/

    createUserModal(){
        console.log('inside createUsr');
        this.createtUsrModel = true
    }
    
    //Event to track the current action
    handleRowActions(event) {
        let actionName = event.detail.action.name;
        console.log('actionName'+actionName);
        let row = event.detail.row;
        window.console.log('row ====> ' + JSON.stringify(row));
        // eslint-disable-next-line default-case
        switch (actionName) {
            case 'edit':
                this.editCurrentRecord(row);
                break;
            case 'record_details':
                this.viewCurrentRecord(row);
                break;
            case 'reset':
                this.openmodal(row);
                break;
            case 'deactivate':
                this.deactivateUser(row);
                break;
            case 'activate':
                this.deactivateUser(row);
                break; 
            case 'upload':
                this.openmodal1(row);; 
        }
    }

    handleSubmit(event) {       
        console.log(event.detail);   
        this.successToast();
       }    
       handleSuccess(event) {       
        console.log('Record iD' + event.detail.id);    
    }

    //Method is used for displaying data in Lazy Loading
    loadMoreData(event) {
        console.log('inside loadMoreData');
        this.loadMoreStatus = 'Loading';
        //let showLoadingSpinner = true;
        let currentPageData = this.data;
        let lastRecId = currentPageData[currentPageData.length - 1].Id;
        console.log('-showing lastRecord of the user--'+lastRecId);
        moreDataLoad({recordId: lastRecId})
            .then(result =>{
                let currentPageNewData = result;
                console.log('--currentPageNewData--'+JSON.stringify(currentPageData));
                let newData = currentPageData.concat(currentPageNewData);
                console.log('-concatedData display of org---'+newData);
                console.log('---concatedData length---'+newData);
                this.data = newData;
                this.currentPageData = this.data;
                console.log('--this.currentPageData--'+this.data);
                //console.log('--concated data display--'+newData);
                //this.data = newData;
                //console.log('--currentPageData--'+currentPageData);
                //this.currentPageData = this.data;
                //console.log('All data after append------'+JSON.stringify(this.currentPageData));
            })            
        }
        /*const currentRecord = this.data;
        const lastRecId = currentRecord[currentRecord.length - 1].Id;
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
        });*/
    }