/**
* 
* Description   - This class is used to count the number of words in string variable
* 
* Created By    - Alok kumar
* 
* Created Date  - 05/07/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/
public class NumberOfWords {
    
    /**
* 
* @description - concatStr() is used to concat the two string
* 
* @return 	   - void 
* 
*/
    public void countWords() {
        
        //List to store integer
        List<Integer> noOfWords = new List<Integer>();
        
        //Variable declaration 
        Integer words =1;
        String str ='Welcome to briskminds';
        
        for(Integer i = 0 ; i <= str.length() -1 ; i++){
            
            noOfWords.add(str.charAt(i));
        }
        
        for(Integer i = 0 ; i <= str.length() -1 ; i++){
        
            if(String.fromCharArray(noOfWords) =='')
                
                words++; 
        }
        System.debug(words);
        
    }
}