import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Contact_OBJECT from '@salesforce/schema/Contact';
import FirstName from '@salesforce/schema/Contact.FirstName';
import LastName from '@salesforce/schema/Contact.LastName';
import Email from '@salesforce/schema/Contact.Email';
export default class ContactCreator extends LightningElement {
    objectApiName = Contact_OBJECT;
    fields = [FirstName, LastName, Email];
    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Contact created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    }
}