@isTest
private class TestRestrictContactByName {
    
    static testMethod void  metodoTest() 
    {        
        List<Contact> listContact= new List<Contact>();
        Contact cont = new Contact(FirstName='Francesco1', LastName = 'INVALIDNAME',email='Test@test.com');
        listContact.add(cont);       
        insert listContact;          
    }  
}