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
@isTest
private class Case_FutureTriggerHelperTest {
    @testSetup static void setup(){
        List<Case> casesList = new List<Case>();
       	casesList.add(new Case(SuppliedEmail = 'alokjha@briskminds.com', Origin = 'ATM' , subject = 'Test'));
       	casesList.add(new Case(SuppliedEmail = 'alokjha@briskminds.com', Origin = 'Web' , subject = 'Test'));
        casesList.add(new Case(SuppliedEmail = 'alokjha@briskminds.com', Origin = 'Phone' , subject = 'Out Of Office'));
        casesList.add(new Case(SuppliedEmail = 'alokjha@briskminds.com', Origin = 'Email' , subject = 'Test'));
        casesList.add(new Case(SuppliedEmail = 'alokjha@briskminds.com', Origin = 'ATM' , subject = 'Test'));
        
        insert casesList;   
    }
    public static testMethod void deleteCase_Test(){
        List<Case> caseData = new List<Case>([SELECT Id ,Origin,Type FROM Case]);
        If(caseData.Size()>0){
            System.assertEquals(4,caseData.Size()); 
           
        }
    }
    public static testMethod void updateType_Test(){
        List<Case> caseData = new List<Case>([SELECT Id ,Origin,Type FROM Case]);
        If(caseData.Size()>0){
           
            System.assertEquals( caseData[0].Type, caseData[0].Origin);
            System.assertEquals( caseData[1].Type, caseData[1].Origin);
            System.assertEquals( caseData[2].Type, caseData[2].Origin);
            System.assertEquals( caseData[3].Type, caseData[3].Origin);
        }
    }
}