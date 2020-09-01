/**
* 
* Description   - This class is used to upsert the record in the object. 
* 
* Created By    - Alok kumar
* 
* Created Date  - 10/07/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/ 
public class UpsertRecord {
    
/**
* 
* @description - upsertContact() is used to insert the record if it doesn't exist or if the record 
* exist then it updates the record .
* 
* @args        - 
*
* @return 	   - void 
* 
*/
    public void upsertContact(){
        
        //Creted contact object having ref name BhawnaInfo to store the contact details
        Contact BhawnaInfo = new Contact(FirstName ='Bhawna_1',LastName ='Pareek_1', Email = 'Bhawna@gmail.comtest');
       
        //Inserted the Bhawna details in the contact
        insert BhawnaInfo;
        
     	//Upate the Records of the BhwanaInfo ref
        BhawnaInfo.Department ='Computer Science';
        
        //Creted contact object having ref name AmarInfo to store the contact details
        Contact AmarInfo = new Contact (FirstName ='Amar_1',LastName = 'Digvijay Patil_1', Email = 'Amar@gmail.comtest' );
       
        AmarInfo.Department ='IT';
        //List to store the contact data
        List<Contact> listOfContact = new List<Contact>();
        
        //Adding contacts to the list
        listOfContact.add(BhawnaInfo);    
        
        //Adding contacts to the list
        listOfContact.add(AmarInfo);
     	
  
        //Performing upsert operation to add the contact details exists in the List To contact object.
        upsert listOfContact;
        
        //To print on the console
        System.debug(listOfContact);
    }
}