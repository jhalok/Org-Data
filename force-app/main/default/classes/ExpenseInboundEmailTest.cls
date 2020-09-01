/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 /**
    * Description   :   This class is used to test the different test cases of expense Email handler service. 
    *
    * Created By    :   Alok kumar
    *
    * Created Date  :   29/8/2018
    * 
    *  Version      :   V.0 Created         
    **/
@isTest(SeeAllData = false)
public class ExpenseInboundEmailTest {

    /* 
	*	Description     :	Define test setup method to define data.
	*
	*	@argument		:		
	*
	*	Revision Logs   : 	V_1.0 - Created
	*/
    
    @TestSetup 
    Static void testSetup() {
        
       //List to hold house records
        List<House__c> houses = new List<House__c>();
        
        //Add data in list 
        houses.add(new House__c(Name = 'Briskminds', Address__c = 'Mansarovar'));
        
        //insert records of house
        insert houses;
        
        //This list hold persons
        List<Person__c> persons = new List<Person__c>();
        
        persons.add(new Person__c(Name = 'Alok', Gender__c = 'Male', Email__c = 'alok.kumar@briskminds.com'));
        persons.add(new Person__c(Name = 'Mayank', Gender__c = 'Male', Email__c = 'alok.kumar@briskminds.com'));
  
        insert persons;
        
        List<Member__c> members = new List<Member__c>();
        
        members.add(new Member__c(Name = 'Alok', Person__c = persons[0].Id, House__c = houses[0].Id));
        members.add(new Member__c(Name = 'Mayank', Person__c = persons[1].Id, House__c = houses[0].Id));
        insert members;
        
        List<Expense__c> yearlyExpenses = new List<Expense__c>();
        
        yearlyExpenses.add(new Expense__c(Name = 'Alok', Short_Name__c = '2018', Member__c = members[1].Id, Type__c = 'Yearly', Date__c = Date.today(), Total_Balance__c = 100000, Client__c='Rai'));

        insert yearlyExpenses;
        
        List<Expense__c> MonthlyExpenses = new List<Expense__c>();
        
        MonthlyExpenses.add(new Expense__c(Name = 'Alok', Short_Name__c = 'Aug', Client__c='joy', Member__c = members[1].Id, Food_Expenses__c = 0, Fuel_Expenses__c = 0, Other_Expenses__c = 0, Type__c = 'Monthly', Date__c = Date.today(),Total_Balance__c = 1000,  Yearly_Expense__c = yearlyExpenses[0].Id ));
        insert MonthlyExpenses;
        
    }
    /* 
	*	Description     :	Define test method to process and test data.
	*
	*	@argument		:		
	*
	*	Revision Logs   : 	V_1.0 - Created
	*/
    static testMethod void testEmailAttachment() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        Messaging.InboundEmail.BinaryAttachment binaryAtt = new Messaging.InboundEmail.BinaryAttachment();
        
        email.subject = 'Expense Details';
        
       env.fromAddress = 'alok.kumar@briskminds.com';
        // set the body of the attachment
        String csvContent = 'Date,Amount,Description,Bill Number,House,Person'+'\n'+'2018-08-10,500,Food,101,Briskminds,Alok'+'\n'+'2018-08-10,200,Fuel,101,Briskminds,Mayank';
        
        
        binaryAtt.body = blob.valueOf(csvContent);
        
        binaryAtt.fileName = 'Expense Items';
        
        binaryAtt.mimeTypeSubType = 'plain/txt';
        
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {binaryAtt };
            
           // call the class and test it with the data in the testMethod
          ExpenseInboundEmail expInbEmail = new ExpenseInboundEmail();
          expInbEmail.handleInboundEmail(email, env);
        
 
        String sub = 'Expense Details';
        System.assert(email.subject.equalsIgnoreCase(sub));
        List<Expense_Item__c> expItem = new List<Expense_Item__c>();
        expItem = [Select id from Expense_Item__c];
        System.assertEquals(2, expItem.size());
        List<Expense__c> exp = new List<Expense__c>();
        List<Expense__c> expYearly = new List<Expense__c>();
        List<Expense__c> expMonthly = new List<Expense__c>();
        exp = [Select id from Expense__c];
        System.assertEquals(6, exp.size());
        expYearly = [Select id from Expense__c where Type__c = 'Yearly'];
        expMonthly = [Select id from Expense__c where Type__c = 'Monthly'];
        System.assertEquals(3, expYearly.size());
        System.assertEquals(3, expMonthly.size());
    }
}