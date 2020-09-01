@isTest
public class CreateUserTest {
    
    static testMethod void testGetMethod()
    {      
        Lead ld = new Lead();
        ld.FirstName='Sachin';
        ld.LastName='Jain';
        ld.Company='Briskminds';
        ld.Email ='alok.akjha33@gmail.com';
        insert ld;
        System.debug('ld insert'+ld);   
        System.assert(ld != null);
        System.assertEquals('Sachin', ld.FirstName);
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Lead/'+ld.Id; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        CreateUser.getLead();
        Test.stopTest();
    }
}