import { LightningElement,track,wire,api } from 'lwc';
import My_Resource from '@salesforce/resourceUrl/Kitchen';
import OtherAddress from '@salesforce/schema/Contact.OtherAddress';
import Contact from '@salesforce/schema/Contact';
import LastName from '@salesforce/schema/Contact.LastName';
import FirstName from '@salesforce/schema/Contact.FirstName';
import Birthdate from '@salesforce/schema/Contact.Birthdate';
import CurrentDate__c from '@salesforce/schema/Contact.CurrentDate__c';
import {createRecord} from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { loadStyle } from 'lightning/platformResourceLoader';
import BookingStyle from '@salesforce/resourceUrl/BookingStyle';
import labelName from '@salesforce/label/c.Thank_you';

import WorkOrder from '@salesforce/schema/WorkOrder';
import Street from '@salesforce/schema/WorkOrder.Street';
import City from '@salesforce/schema/WorkOrder.City';

import ServiceAppointment from '@salesforce/schema/ServiceAppointment';
import SA_Street from '@salesforce/schema/ServiceAppointment.Street';
import SA_DueDate from '@salesforce/schema/ServiceAppointment.DueDate';
import SA_EarliestStartTime from '@salesforce/schema/ServiceAppointment.EarliestStartTime';
import SA_City from '@salesforce/schema/ServiceAppointment.City';
import SA_Country from '@salesforce/schema/ServiceAppointment.Country';
import SA_PostalCode from '@salesforce/schema/ServiceAppointment.PostalCode';
import SA_ParentRecordId from '@salesforce/schema/ServiceAppointment.ParentRecordId';

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
    @track Birthdate;
    @track CurrentDate__c;

    @track value = "initial value";

    @track curntdate;
    @track curntDate;
    @track afterTwoDay;
    @track DueDate;
    
    

    
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
    selectSlot(event){
        
        var today = new Date(); 
        //const month = today.toLocaleString('default', { month: 'long' });     
        //console.log(month);  
        //var croppedMonthName = month.substring(0, 3);
        //console.log('croppedMonthName'+croppedMonthName);
        var dd = today.getDate();
        console.log('dd--'+dd)
        var mm = today.getMonth() + 1; //January is 0!
        console.log('mm--'+mm);
        var yyyy = today.getFullYear();
        console.log('yyyy--'+yyyy);
        // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
        // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
        var addTwoDay = today.getDate()+2;
        if(addTwoDay < 10){
            addTwoDay = '0' + addTwoDay;
        }
        console.log('addTwoDay'+addTwoDay);
        var afterTwoDay = yyyy+'-'+mm+'-'+addTwoDay;
        console.log('afterTwoDay'+afterTwoDay);
        console.log('afterTwoDay----'+new Date(afterTwoDay).getTime());
        var isFilled = true; 
        var inputCmp = this.template.querySelectorAll("lightning-input");
        var dateInputCmp = this.template.querySelector("inputDate") //getting element
        console.log('dateInputCmp'+dateInputCmp);
        var todayDate = new Date(value).getTime();
        var afterTwoDays = new Date(afterTwoDay).getTime();
        for(var i=0; i < inputCmp.length; i++){
            console.log('inside for loop');
            var value = inputCmp[i].value; //assigning value to variable
                if (value === "") {
                    //adding custom validation
                    inputCmp[i].setCustomValidity("Field is Required!.Please Fill it.");
                    isFilled = false;
                }else if(dateInputCmp === '' || new Date(value).getTime() < new Date(afterTwoDay).getTime()){ //&& (new Date(value).getTime > new Date(afterTwoDay).getTime() || new Date(value).getTime() < new Date(todayFormattedDate).getTime())
                    console.log('first-----'+new Date(value).getTime());
                    console.log('afterTwoDay----'+new Date(afterTwoDay).getTime());
                    //console.log('formatted----'+new Date(todayFormattedDate).getTime());
                    inputCmp[i].setCustomValidity("Earliest possible appointments are accepted two business days from today");
                    isFilled = false;
                }else {
                    //Removing validation error
                    inputCmp[i].setCustomValidity(""); // if there was a custom error before, reset it
                }
            inputCmp[i].reportValidity(); // Tells lightning-input to show the error right away without needing interaction
        }
        if(isFilled){
            this.createtNewAppoinmentModal = false;
            this.selectSlotModal = true;
        }
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
        console.log('inside handleChange');
        if (event.target.label === 'Street') {
            this.Street = event.target.value;
        }
        if (event.target.label === 'City') {
            this.City = event.target.value;
        }
        if (event.target.label === 'Postal Code') {
            this.PostalCode = event.target.value;
        }
        if (event.target.label === 'Country') {
            this.Country = event.target.value;
        }
        if (event.target.label === 'DueDate'){
            this.DueDate = event.target.value;
            console.log('this.DueDate'+this.DueDate);
        }
    }
    @track PostalCode;
    @track Country;
    @track City;

    @track Street;
    @track workOrderId; // to store account recordId
    @track ServiceAppointmentId;
    @track ParentRecordId;
    

    @track SA_City;
    @track SA_Country;
    @track SA_PostalCode;
    @track SA_Street;
    @track SA_EarliestStartTime;
    @track SA_DueDate; // to store contact recordId
   
    handleNameChange(event){
        this.accountName = event.target.value;
    }
 
   // save called on click of save to insert account and contact record with LDS
    save() {
        console.log('Save method has been called');
        this.openFinalModal = false;
        const fields = {};
        fields[Street.fieldApiName] = this.Street;
        const accRecordInput = { apiName: WorkOrder.objectApiName, fields};
       // create account record 
        createRecord(accRecordInput)
            .then(WorkOrder => {
                this.workOrderId = WorkOrder.id;
               // display success toast msg for account
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'WorkOrder created',
                        variant: 'success',
                    }),
                );
               
                console.log('workorderID'+this.workOrderId);
                console.log('this.street'+this.Street);
                var prntId = this.workOrderId;
                console.log('Parent Id for Service App'+prntId);
                // create related contact
                const fields_Contact = {};
                fields_Contact[SA_Street.fieldApiName] = this.Street;
                fields_Contact[SA_City.fieldApiName] = this.City;
                fields_Contact[SA_Country.fieldApiName] = this.Country;
                fields_Contact[SA_PostalCode.fieldApiName] = this.PostalCode;
                //fields_Contact[SA_DueDate.fieldApiName] = this.DueDate; 
                //fields_Contact[SA_EarliestStartTime.fieldApiName] = this.DueDate;// set contact Name same as account name
                fields_Contact[SA_ParentRecordId.fieldApiName] = prntId;//this.workOrderId;//'0WO6F000000hgadWAA';  //set account Id (parentId) in contact
                const recordInput_Contact = { apiName: ServiceAppointment.objectApiName,
                                              fields : fields_Contact};
                 // create contact record using Lightning Data service
                  createRecord(recordInput_Contact)
                    .then(ServiceAppointment => {
                        //this.ServiceAppointmentId = ServiceAppointment.id;
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'ServiceAppointment created',
                                variant: 'success',
                            }),
                        );
                    })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.me,
                        variant: 'error',
                    }),
                );
            });
        })
    }
    submitContact() {
        console.log('Current value of the input:');

        const fields = {};
        fields[LastName.fieldApiName] = this.LastName;
        fields[FirstName.fieldApiName] = this.FirstName;
        fields[Birthdate.fieldApiName] = this.Birthdate;

        const recordInput = {
            apiName: Contact.objectApiName,
            fields
        };
        createRecord(recordInput)
            .then(contact =>{
                setTimeout(function(){
                    location.reload()
                }, 5000);
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
                        message: 'There is some error',
                        variant: 'error',
                    }),
                );
            });
        }

    
}