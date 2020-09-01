/**
* 
* Description   - This class is used as a controller to display the various components when some specific 
* boolean conditions are fullfilled
*
* Created By    - Alok kumar
* 
* Created Date  - 16/08/2018
* 
* Revision Logs - V_1.0 - Created
*       
*/
public class AccCompController {
    
    //Getter Setter 
    public String currentPageId {get;set;}
    public Boolean flag {get; set;}
    public Boolean flag1 {get; set;}
    public Boolean flag2 {get; set;}
    public Boolean flag3 {get; set;}
    public Boolean flag4 {get; set;}
    public Boolean flag5 {get;set;}
    public Boolean editFlag1 {get; set;}
    public Boolean editFlag2 {get; set;}
    public Integer addRowSize {get; set;}
    public Boolean nonEdit {get; set;}
    public Boolean editRecord {get; set;}
    public List<Contact> contacts {get; set;}
    public List<contact> selectedContact {get; set;}
    public List<Contact> insertContactRecord {get; set;}
    public List<WrapContact> wrapContactList {get; set;}
    public Account acc {get; set;}
    public String showMessage{get;set;}
    
    
    //Class Constructor 
    public AccCompController(){
        
        //Getting the current id
        currentPageId = ApexPages.currentPage().getParameters().get('id'); 
        flag = false;
        flag1 = false;
        flag2 = true;
        flag3 = false;
        flag4 = true;
        flag5 = false;
        nonEdit = true;
        editRecord = false;
        editFlag1 = true;
        editFlag2 = false;
        acc = new Account();
        selectedContact = new List<Contact>();
        contacts = new List<Contact>();
        wrapContactList = new List<WrapContact>();
    }
    
    /**
*   Description      :	Method used to move to Account Component
*
*   @argu            : 	Boolean, list
*
*   @return type     : 	void
**/
    public void AccountComponent(){
        flag2 = false;
        flag = true;
        flag3 = false;
        
        //Check Current Page id not null
        if(currentPageId != null){
            
            //Dynamic query
            String queryString = 'select id';
            
            //for loop in  Account fiels set and fatch
            for(Schema.FieldSetMember fld :SObjectType.Account.FieldSets.AccountWiz_FieldSet.getFields()) {
                queryString += ', ' + fld.getFieldPath();
            }
            //Current Page id According get account
            queryString += ' from Account where id =: currentPageId ';
            
            //Add data in account
            acc = Database.query(queryString);
        }
    }
    
    /**
*   Description      :	Method used to move next Contact component 
*
*   @argu            : 	Boolean, WarpperList
*
*   @return type     : 	void
**/
    public void contactNextPage(){
        flag = false;
        flag1 = true;
        flag3 = false;
        if(flag4 != false){
            
            //Check Current Page id not null
            if(currentPageId != null){
                
                //Dynamic query
                String queryString = 'SELECT Id ';
                
                //for loop in  Contact fiels set and fatch
                for(Schema.FieldSetMember FieldSM : SObjectType.Contact.FieldSets.ContactWiz_FieldSet.getFields()){
                    queryString += ', ' + FieldSM.getFieldPath();
                }
                
                //get Contact According Account Id 
                queryString += ' FROM Contact Where AccountID =: currentPageId order by lastModifiedDate Desc LIMIT 5' ;
                contacts = Database.query(queryString);
            }
            //for loop size 5
            for(Integer i =contacts.size() ; i<5 ;i++){
                Contact  con = new Contact();
                //Add contact 
                contacts.add(con);
            }
            //for loop in contact list
            for(Contact c : contacts){
                
                //add data in wrapper contact list
                wrapContactList.add(new WrapContact(c));
            }
        }
    }
    /**
*   Description      :	Method used to move prev page
*
*   @argu            : 	Boolean, WarpperList
*
*   @return type     : 	void
**/
    public void prvPageAccount(){
        flag2 =true;
        flag = false;
    }
    
    /**
*   Description      :	previousPageContact() is used to previous Account component 
*
*   @argu            : 	Boolean, WarpperList
*
*   @return type     : 	void
**/
    public void  prvPageContact(){
        flag3 = false;
        flag1 = false;
        flag = true;
        flag4 = false;
        flag5 = false; 
    }
    /**
*   Description      :	previousPreviewPage() is used to show previous Start page
*
*   @argu            : 	Boolean
*
*   @return type     : 	void
**/
    public void prvPreviewPage(){
        flag3 = false;
        flag1 = true;
    }
    /**
*   Description      :	nextPagePreview() is used to Preview the Account and contact details 
*
*   @argu            : 	Boolean, WarpperList
*
*   @return type     : 	void
**/
    public void nextPagePreview(){
        flag3 = true;
        flag = false;
        flag1 = false;
        flag2 = false;
        flag5 = false;
        //Check current page id not null
        if(currentPageId != null){
            
            //Dynamic query
            String queryString = 'select id';
            
            //for loop in  Account fiels set and fetch
            for(Schema.FieldSetMember fld :SObjectType.Account.FieldSets.AccountWiz_FieldSet.getFields()) {
                queryString += ', ' + fld.getFieldPath();
            }
            //Add data in string type variable
            queryString += ' from Account where id =: currentPageId ';
            acc = Database.query(queryString);
        }
    }
    /**
*   Description      :	editAllRecords() is used to Edit Selected Rows 
*
*   @argu            : 	Boolean, WarpperList
*
*   @return type     : 	void
**/
    public void editAllRecords(){
        Contact cont = new Contact();
        for(Integer i=0; i<wrapContactList.size(); i++ ){
            if(wrapContactList[i].selected == true){
                nonEdit = false;
                editRecord = true;
            }
            else{
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select atleast One contact to Edit.'));
            }
        } 
    }
    /**
*   Description      :	removeAllRecord() is used to remove the selected rows
*
*   @argu            : 	Boolean, WarpperList
*
*   @return type     : 	void
**/
    public void removeAllRecord(){
        
        flag3 = false;
        //If client did't select anything then Error Message Print
        for(WrapContact wrapCon : wrapContactList){
            if(wrapCon.selected == true){
                selectedContact.add(wrapCon.con);
            }
        }
        if(selectedContact.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select atleast One contact to Remove'));  
        }
        Contact cont = new Contact();
        for(Integer i=0; i<wrapContactList.size(); i++ ){
            if(wrapContactList[i].selected == true){
                wrapContactList.remove(i--);
            }
        }
        if(wrapContactList.size()!=5){
            for(Integer i = wrapContactList.size();i<5;i++ ){
                Contact con = new Contact();
                wrapContactList.add(new WrapContact(con)); 
            }
        }
    }
    /**
*   Description      :	addRow() is used to add rows in the contact Table
*
*   @argu            : 	Boolean, WarpperList
*
*   @return type     : 	void
**/
    public void addRow(){
        for(Integer i=0 ; i < addRowSize; i++){
            Contact con = new Contact();
            wrapContactList.add(new WrapContact(con));
        }
    }
    /**
*   Description      :	saveRecord() is used to save insert And update data  
*
*   @argu            : 	Boolean, WarpperList
*
*   @return type     : 	void
**/
    public void saveRecord(){
        flag3 = false;
        flag5 = True;
        insertContactRecord = new List<Contact>();
        if(currentPageId == null){
            insert acc;
        }
        for(WrapContact wrapCon : wrapContactList){
            if(wrapCon.con.LastName != null){
                if(wrapCon.con.Id == null){
                    wrapCon.con.AccountId = acc.Id;
                }
                insertContactRecord.add(wrapCon.con); 
            }
        }
        if(insertContactRecord.size() > 0){
            upsert insertContactRecord;
        }
    }
    
    /**
*   Description      :	cancel() is used to cancel the process and it will bring back to the detail page
*
*   @argu            : 	Boolean, WarpperList
*
*   @return type     : 	void
**/
    public pageReference cancel() {
        PageReference page;
        if(currentPageId != NULL){
            page = new PageReference('/'+currentPageId);
            return page;
        }
        else{
            page =new PageReference('https://ap4.salesforce.com/home/home.jsp?sdtd=1');
            return page;
        }
    }
    
    //wrapper class contact
    public class WrapContact {
        public Contact con {get; set;}
        public Boolean selected {get; set;}
        
        //wrapper constructor
        public wrapContact(Contact c){
            con = c ;
            selected = false;
        }
    }
}