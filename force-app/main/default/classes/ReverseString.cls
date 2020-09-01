/**
* 
* Description   - This class is used to reverse the string
* 
* Created By    - Alok kumar
* 
* Created Date  - 05/07/2018
* 
* Revision Logs - V_1.0 - Created
*       
*/
public class ReverseString { 
    
    /**
* 
* @description - revStr() is used to reverse a string
* 
* @return 		- void 
* 
*/
    public String revStr(String strValue){
        
        //List to store the Ascii value of the characters
        List<Integer> reverseList = new List<Integer>();        
        
        //for loop to itrate string in reverse order
        for (Integer i = strValue.length() - 1; i >= 0; i--) {
            
            //To add the string ascii value to the list
            reverseList.add(strValue.charAt(i));
        }
        
        //To convert the string Ascii value to Character
        String strRevVal = String.fromCharArray(reverseList);
        
        //To print the reverse string
        System.debug(strRevVal);
        
        //Return the value of strVal
        return strRevVal;    
    } 
}