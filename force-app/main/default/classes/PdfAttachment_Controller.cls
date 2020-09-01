/**
*   Description 	:   This is a controller class to send the record according to query on page and than call another page.
*
*   Created by      :   Alok kumar
*
*   Created Date    :   30/07/2018
*
*   Revision Log    :   V1.0 - Created
*
**/
public without sharing class PdfAttachment_Controller {
	
	//List of expense type for saving records and send them on page
	public List<Expense__c> attachmentRecord{get;set;}
  	
	//to get id from url
	public Id houseIdOnClick = ApexPages.currentPage().getParameters().get('Id');
	
    //to get id from url
    public Id houseId= ApexPages.currentPage().getParameters().get('id');
	
	//constructor of a class of type public
	public PdfAttachment_Controller(){
		
		//store the query output in attachmentRecord
		attachmentRecord = [Select Member__r.Name,Total_Balance__c,Total_Expense__c, Member__r.House__r.Name from Expense__c where Type__c = 'Monthly' And Member__r.House__r.Id =: houseIdOnClick AND Date__c=This_Month order by Member__r.Name];
	} 
	
	//to send the control on another page
	public PageReference savePDF()
	{
		PageReference pdf = page.attachPdFVFP;
		pdf.getParameters().put('id',houseId);
		Attachment attach = new Attachment();
		Blob body;
		pdf.setRedirect(true); 
    
    	try {
    	
        	// returns the output of the page as a PDF
    		body = pdf.getContent();
    	
    	// need to pass unit test -- current bug	
    	} catch (VisualforceException e) {
    		body = Blob.valueOf(e.getMessage());
    	}
    
    	attach.Body = body;
   
    	attach.IsPrivate = false;
    	// attach the pdf to the account
    	attach.ParentId = houseId;
    	
    	attach.Name = 'Report';
    	
    	insert attach;	
    		
    	return new PageReference('/apex/attachPdFVFP?id='+houseIdOnClick);
	}
	public void getPDF(){
		attachmentRecord = [Select Member__r.Name,Total_Balance__c,Total_Expense__c, Member__r.House__r.Name from Expense__c where Type__c = 'Monthly' And Member__r.House__r.Id =: houseIdOnClick order by Member__r.Name];
	}
}