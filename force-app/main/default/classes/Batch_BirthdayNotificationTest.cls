/**
 * This class contains unit tests for validating the behavior of Apex classes
  and triggers.
 
  Unit tests are class methods that verify whether a particular piece
  of code is working properly. Unit test methods take no arguments,
  commit no data to the database, and are flagged with the testMethod
  keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
  to a production organization to confirm correctness, ensure code
  coverage, and prevent regressions. All Apex classes are
  required to have at least 75% code coverage in order to be deployed
  to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
  methods. Classes defined with the @isTest annotation do not count against
  the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
/**
*   Description 	:   This class is Used to test the batch apex to send Birthday email. 
*
*   Created by      :   Alok kumar
*
*   Created Date    :   30/08/2018
*
*   Revision Log    :   V1.0 - Created
*
**/
@isTest
public with sharing class Batch_BirthdayNotificationTest {

	@testSetup
	static void setup(){
		
			//list of object type person is created
		    List<Person__c> persons = new List<Person__c>();
		    //add the record on that list
			persons.add(new Person__c(Name = 'Alok', Birthday__c= Date.today(),Email__c='alok@gmail.com', Gender__c='Male'));
			//query for inserting the record in database
			insert persons;
	}
	
    @isTest
    static void test(){
    	Test.startTest();
        
    	//Instance of batch class
    	Batch_BirthdayNotification brtNoti = new Batch_BirthdayNotification();
    	
    	//store the id of execution of batch 
    	Id batchId = Database.executeBatch(brtNoti);
    	Test.stopTest();
    	
    	//assert to check the actual result is same as expected
    	System.assertEquals(1,[select count() from AsyncApexJob where Id =: batchId]);
    }
}