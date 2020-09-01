import { LightningElement,track,wire,api } from 'lwc';
import My_Resource from '@salesforce/resourceUrl/Kitchen';
import OtherAddress from '@salesforce/schema/Contact.OtherAddress';
import Contact from '@salesforce/schema/Contact';
import LastName from '@salesforce/schema/Contact.LastName';
import FirstName from '@salesforce/schema/Contact.FirstName';
import {createRecord} from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { loadStyle } from 'lightning/platformResourceLoader';
import BookingStyle from '@salesforce/resourceUrl/BookingStyle';
import labelName from '@salesforce/label/c.Thank_you';


export default class Book_an_Online_Planning_Appointment_CA extends LightningElement {
    @api title;
    @api buttonlabel;

    kitchenLogo = My_Resource;
    label = labelName;
    @track createtAppoinmentModel = false;
    @track createtNewAppoinmentModal = false;
    @track selectSlotModal = false;
    @track openThankUScreen = false;
    @track openFinalModal = false;
    @track FirstName;
    @track LastName;
    

    
   /* connectedCallback() {
        console.log('inside connectedCallback');
        Promise.all([
            loadStyle(this, BookingStyle + '/Booking.css'),
        ])
            .then(() => {
                //alert('Files loaded.');
            })
        .catch(error =>{
            //console.log(error);
    });
    }*/ 

  
    openNewAppoinmentModal(){
        this.createtAppoinmentModel = false;
        this.createtNewAppoinmentModal = true;
    }
    closeNewAppoinmentModal(){
        this.createtNewAppoinmentModal = false;
    }
    selectSlot(){
        this.createtNewAppoinmentModal = false;
        this.selectSlotModal = true;
    }
    closeSelectSlotModal(){
        this.selectSlotModal = false;
    }
    selectThankU(){
        this.selectSlotModal = false;
        this.openThankUScreen = true;
    }
    closeThankUModal(){
        this.openThankUScreen = false;
    }
    selectFinalModal(){
        this.openThankUScreen = false;
        this.openFinalModal = true;
    }
    closeFinalModal(){
        this.openFinalModal = false;
    }

    //back button
    backToNewAppoinmentModal(){
        this.selectSlotModal = false;
        this.createtNewAppoinmentModal = true;
        this.LastName;
        this.FirstName;
    }
    backToSlotSelection(){
        this.openThankUScreen = false;
        this.selectSlotModal = true;
    }


    handleChange(event) {
        if (event.target.label === 'LastName') {
            this.LastName = event.target.value;
        }
        if (event.target.label === 'FirstName') {
            this.FirstName = event.target.value;
        }
        console.log('Current value of the input: ' + evt.target.value);

        const allValid = [...this.template.querySelectorAll('lightning-input')]
        .reduce((validSoFar, inputCmp) => {
                    inputCmp.reportValidity();
                    return validSoFar && inputCmp.checkValidity();
        }, true);
        if (allValid) {
            alert('All form entries look valid. Ready to submit!');
        } else {
        alert('Please update the invalid form entries and try again.');
        }
    }
    submitContact() {
        const fields = {};
        fields[LastName.fieldApiName] = this.LastName;
        fields[FirstName.fieldApiName] = this.FirstName;
        if(this.LastName == ''){
            console.log('inside if in submitContact');
            message = 'LastName cannot be Empty';
        }

        const recordInput = {
            apiName: Contact.objectApiName,
            fields
        };
        createRecord(recordInput)
            .then(contact =>{
              
                /*setTimeout(function(){
                    location.reload()
                }, 5000);*/
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Contact is created',
                            variant: 'success',
                        }),
                    );
                   
                })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: message,
                        variant: 'error',
                    }),
                );
            });
    }
    userCreationFields = [LastName,OtherAddress];
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
}