/**
 * 
 * Description   - This class is used to concat the two string
 * 
 * Created By    - Alok kumar
 * 
 * Created Date  - 06/07/2018
 * 
 * Revision Logs - V_1.0 - Created
 *      
 * 
 */
public class StringConcat {
    
    /**
	 * 
	 * @description - concatStr() is used to concat the two string
	 * 
	 * @return 		- void 
	 * 
	 */
    public void concatStr(String strFirstStr,String strSecondStr){
        
        //String first
        String strFirst = strFirstStr;
        
        //String second
        String strSecond =strSecondStr;
        
        //Concatination of string in third variable
        String strThird = strFirst + strSecond;
        
        //To print the concatination value of third value on console
        System.debug(strThird);
    }
}