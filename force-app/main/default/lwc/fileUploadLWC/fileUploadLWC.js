import { LightningElement, track, api } from 'lwc';
import insertCase from '@salesforce/apex/LightningFileUpload.insertCase';
import saveChunk from '@salesforce/apex/LightningFileUpload.saveChunk';
//import releatedFiles from '@salesforce/apex/LargeFileUploadLgtng.releatedFiles';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

const columns = [
    {label: 'Title', fieldName: 'Title'}
];

export default class CustomFileUploader extends LightningElement {
    @track startPosition;
    @track endPosition;
    @api recordId;
    @track columns = columns;
    @track parentId;
    @track data;
    @track fileName = '';
    @track UploadFile = 'Upload File';
    @track showLoadingSpinner = false;
    @track isTrue = false;
    startPosition;
    endPosition;
    contentType;
    attachId;
    saveChunk;
    selectedRecords;
    filesUploaded = [];
    file;
    @track getChunk;
    fileContents;
    fileReader;
    fileName;
    content;
    MAX_FILE_SIZE = 4500000; //Max file size 4.5 MB 
    CHUNK_SIZE = 750000;
    //MAX_FILE_SIZE = 4194304; //3805250;3143910;-->


    connectedCallback() {
        this.insertCase();
    }

    insertCase() {
        insertCase()
        .then(data => {
            this.data = data;
            this.parentId = this.data.Id;
            console.log('id----'+this.parentId);
            console.log('LWC data insert case'+JSON.stringify(this.data));
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
    }

     handleFilesChange(event) {
         console.log('inside handleFilesChange LWC');
        if(event.target.files.length > 0) {
            this.filesUploaded = event.target.files;
            this.fileName = event.target.files[0].name;
            this.uploadHelper();
        }
    }

    handleSave() {
        if(this.filesUploaded.length > 0) {
            this.uploadHelper();
        }
        else {
            this.fileName = 'Please select file to upload!!';
        }
    }

    uploadHelper() {
        console.log('inside uploadHelper');
        this.file = this.filesUploaded[0];
        console.log('file data'+this.file);
        if (this.file.size > this.MAX_FILE_SIZE) {
            console.log('file size---'+this.file.size);
            alert('filesize is large to upload');
            //component.set("v.showLoadingSpinner", false);
            //component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
        this.showLoadingSpinner = true;

        this.fileReader = new FileReader();
        // set onload function of FileReader object   
        this.fileReader.onloadend = (() => {
            this.fileContents = this.fileReader.result;
            //console.log('this.fileContents----'+this.fileContents);
            let base64 = 'base64,';
            this.content = this.fileContents.indexOf(base64) + base64.length;
            //console.log('this.content-------'+this.content);
            this.fileContents = this.fileContents.substring(this.content);
            //console.log('this.fileContnets'+this.fileContents);
            // call the uploadProcess method 
            this.uploadProcess(this.file, this.fileContents);
        });
        this.fileReader.readAsDataURL(this.file);       
    }

    uploadProcess(file,fileContents){
        console.log('inside uploadProcess');
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        console.log('endposition---'+endPosition);
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.saveToChunk(this.file,this.fileContents, startPosition, endPosition, '');
    }

    saveToChunk(file,fileContents,startPosition,endPosition,attachId) {
        console.log('inside savetoFile()');
        this.getchunk = fileContents.substring(startPosition, endPosition);
        console.log('getChunk'+this.getChunk);
        saveChunk({ parentId : this.parentId, fileName : this.file.name, base64Data: encodeURIComponent(this.getchunk),contentType:this.file.type, fielId: this.attachId })
        .then(result => {
            console.log('result ====> ' +result);
            // refreshing the datatable
            this.attachId = result;
            this.startPosition = this.endPosition;
            this.endPosition = Math.min(fileContents.length, this.startPosition + this.CHUNK_SIZE);
            console.log('this.endPosition with math.min'+endPosition);
            // check if the start postion is still less then end postion 
            // then call again 'uploadInChunk' method , 
            // else, diaply alert msg and hide the loading spinner
            if (startPosition < endPosition) {
                console.log('startPosition is less then endPosition');
                this.saveToChunk(this.file, this.fileContents, this.startPosition, this.endPosition, this.attachId);
            } else {
                alert('your File is uploaded successfully');
            }
        })
        .catch(error => {
            window.console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while uploading File',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
    }
}