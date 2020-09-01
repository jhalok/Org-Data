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
*   Description 	:   This class is Used to test the DynamicApex to show the object permissions and show it's fields. 
*
*   Created by      :   Alok kumar
*
*   Created Date    :   30/08/2018
*
*   Revision Log    :   V1.0 - Created
*
**/
@isTest(SeeAllData=false)
private class DynamicApexControllerTest {
  
    static TestMethod void Permission_test(){
     
        DynamicApexController obj = new DynamicApexController();
        obj.selectedObject = 'Account';
        obj.objPermission();

        System.assertEquals( 1, obj.objPrmsn.size());
        
        obj.showFields();
        
        System.assertEquals( 65, obj.listField.size());
        obj.getListObjectName();
        System.assertEquals(464, obj.getListObjectName().size());
        obj.InsertRecords();
        System.assertEquals( 65, obj.insertfield.size());

        DynamicApexController obj1 = new DynamicApexController();
        obj1.selectedObject = 'Account';
        obj1.InsertRecords();
        obj1.saveRecords();
        system.assertEquals(1,[select Id from Account].size());
        
        
        DynamicApexController obj2 = new DynamicApexController();
        obj2.selectedObject = 'None';
        obj2.objPermission();

        System.assertEquals( 0, obj.objPrmsn.size());
        
        obj2.showFields();
        System.assertEquals( 0, obj.listField.size());
    }
}