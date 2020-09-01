/**
* 
* Description   - This class is used to perform the various string functionality
* 
* Created By    - Alok kumar
* 
* Created Date  - 05/07/2018
* 
* Revision Logs - V_1.0 - Created
*       
*/

public class StringMethodsExecution {
/**
* 
* @description - revStr() is used to reverse a string
* 
* @return 		- string
* 
*/
    public static String revStr(String strValue){
         
        //Condition to check the space & NULL
        if(strValue == '' || strValue == ' ') {
            
            return 'enter the valid String';
        }
        //List to store the Ascii value of the characters
        List<Integer> reverseList = new List<Integer>();        
        
        //for loop to itrate string in reverse order
        for (Integer i = strValue.length() - 1; i >= 0; i--) {
            
            //To add the string ascii value to the list
            reverseList.add(strValue.charAt(i));
        }
        
        //To convert the string Ascii value to Character
        String strRevVal = String.fromCharArray(reverseList);
        
        //Return the value of strVal
        return strRevVal;    
    }
    
    
/**
* 
* @description - concatStr() is used to concat the two string
* 
* @return 		- String
* 
*/
    public String concatStr(String First,String Second) {
        
        //Condition to check the space & NULL
        if(First == '' || Second == '' || First == ' ' || second == ' ') {
            
            return 'enter the valid String';
        }
        
        //Concatination of string in third variable
        String strThird = First + Second;
        
        //To print the concatination value of third value on console
        return strThird;
        
    }
        
/**
* 
* @description - emptyString() is used to check string is empty or not
* 
* @return 		- string
* 
*/
    
    public string emptyString(string str){
       
         //Condition to check the space & NULL
         if(str == '' ||  str == ' ' ) {
            
            return 'String is empty';
        }
        else 
            return 'String is not empty';
    }
}