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
 *  Purpose         :   This class is used to test the various string functionality
 *
 *  Create By       :   Alok Kumar
 *
 *  Created Date    :   20/07/2018
 *
 *  Revision Logs   :   V_1.0 - Created
 **/
 
@IsTest(SeeAllData=False)
private class StringMethodsExecutionTest {
    
    /**
* 
* @description  - revStr() is used to test the string reverse functionality
* 
* @return 		- string
* 
*/
public static testMethod void revStr(){
    
    System.assertEquals('sihT',StringMethodsExecution.revStr('This'));
    System.assertEquals('enter the valid String',StringMethodsExecution.revStr('') );
}


/**
* 
* @description  - concatStr() is used to test the concation functionality of the two string
* 
* @return 		- String
* 
*/
public static testMethod void concateStr_test(){
    
    StringMethodsExecution strEmpRef = new StringMethodsExecution();
    
    Test.startTest();
    
    //Null Check
    String Output = strEmpRef.concatStr('','');
    
    //Checking the excepted value and actual value
    System.assertEquals('enter the valid String',Output);
    
    //Space Check
    Output = strEmpRef.concatStr(' ',' ');
    
    //Checking the excepted value and actual value
    System.assertEquals('enter the valid String',Output);
    
    //Final Concanate String
    Output = strEmpRef.concatStr('Alok','Jha');
    
    //Checking the excepted value and actual value
    System.assertEquals('AlokJha',Output);
    
    test.stopTest();
}

/**
* 
* @description - emptyString() is used to test the functionality that string is empty or not
* 
* @return 		- string
* 
*/
    public static testMethod void emptyString_test(){

		//Initilization of the class StringMethodsExecution to bind the         
        StringMethodsExecution strEmpRef = new StringMethodsExecution();
        
        test.startTest();
 
        //Conditon to Check Null
        String Output = strEmpRef.emptyString('');
        
        //Checking the excepted value and actual value
        System.assertEquals('String is empty' ,Output);
        
        //Conditon to Space check
        Output = strEmpRef.emptyString(' ');
        
        //Checking the excepted value and actual value
        System.assertEquals('String is empty' ,Output);
        
        //Conditon to Check String
        Output = strEmpRef.emptyString('Alok jha');
        
        //Checking the excepted value and actual value
        System.assertEquals('String is not empty' ,Output);
        
        test.stopTest();
    }
}