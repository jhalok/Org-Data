import { LightningElement, api , wire} from 'lwc';
import queryAccountsByRevenue from '@salesforce/apex/AccountListControllerLwc.queryAccountsByRevenue';

export default class AccountFinder extends LightningElement {

    @api annualRevenue;

    @wire(queryAccountsByRevenue, { annualRevenue: '$annualRevenue' })
    accounts;

    handleChange(event) {
        this.annualRevenue = event.detail.value;
    }

    reset() {
        this.annualRevenue = null;
    }

}