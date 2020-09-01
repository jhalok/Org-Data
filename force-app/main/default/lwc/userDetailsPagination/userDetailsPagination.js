import { LightningElement, track, wire } from 'lwc';

import fetchUserData from '@salesforce/apex/fetchUserData.fetchUsers';
// Declaring the columns in the datatable
const columns = [{
    label: '',
    type: 'button-icon',
    initialWidth: 75,
    typeAttributes: {
        iconName: 'action:preview',
        title: 'Preview',
        //variant: 'border-filled',
        alternativeText: 'View'
        
    }
},
{
    label: 'Name',
    fieldName: 'Name'
},
{
    label: 'Email',
    fieldName: 'Email'
},
{
    label: 'User Profile',
    fieldName: 'Profile.Name'
},
{
    label: 'User Role',
    fieldName: 'UserRole.Name'
}
];

export default class UserDetailsPagination extends LightningElement {
    @track columns = columns;
    @track record = {};
    @track rowOffset = 0;
    @track data = {};
    @track bShowModal = false;
    @wire(fetchUserData) parameters;
 
    // Row Action event to show the details of the record
    handleRowAction(event) {
        const row = event.detail.row;
        this.record = row;
        this.bShowModal = true; // display modal window
    }
 
    // to close modal window set 'bShowModal' tarck value as false
    closeModal() {
        this.bShowModal = false;
    }
    
    @track selectedTab;

    tabselect(event) {
        this.selectedTab =  event.target.label;
    }
}