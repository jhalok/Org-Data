import { LightningElement,track } from 'lwc';
import getAccounts from '@salesforce/apex/LMS_AccountController.getAccounts';
import { createMessageContext, releaseMessageContext,publish} from 'lightning/messageService';
import SAMPLEMC from "@salesforce/messageChannel/SampleMessageChannel__c";

export default class Publisher_LMS_LWC extends LightningElement {
    context = createMessageContext();
    @track accountList;
    connectedCallback(){
        getAccounts()
            .then(result =>{
                this.accountList = result;
            })
            .catch(error=>{
                this.accountList = error;
            });
    }
    handleClick(event) {
        event.preventDefault();                
        const message = {
            recordId: event.target.dataset.value,
            recordData: { value: "message from Lightning Web Component" }
        };
        publish(this.context, SAMPLEMC, message);
    }
}