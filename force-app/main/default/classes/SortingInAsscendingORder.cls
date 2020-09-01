/**
* 
* Description   - This class is used to sort the integer value stored in list in Asscending order.
* 
* Created By    - Alok kumar
* 
* Created Date  - 05/07/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/
public class SortingInAsscendingORder {
    
/**
* 
* @description - descending() is used to sort the integer stored in list in descending order.
* 
* @return 		- void 
* 
*/
    public void asscending(){
        
        //List to store the integer values
        LIST <Integer> listOfInt = new LIST<Integer>();{
            
            //adding integer values in the List
            listOfInt .add(64);
            listOfInt .add(45);
            listOfInt .add(23);
            listOfInt .add(44);    
        }
        
        //Iterating the loop till the i value is less then size of loop 
        for(Integer i = 0 ; i < listOfInt.size() ; i ++) {
            
            //Iterating the loop till listOfInt.size() -1
            for(Integer j = i+1 ; j <= listOfInt.size() -1 ; j ++ ){
                
                //Declaration and Initilization of Variable
                Integer tempValue = 0 ;
                
                //If condition to check the value of i is less then j or not
                if(listOfInt[i] >  listOfInt[j]){
                    
                    //Assinging the value of i in the tempValue 
                    tempValue = listOfInt[i]  ;
                    
                    //Assigning the value of j to i
                    listOfInt[i] = listOfInt[j]  ;
                    
                    //Assigning the value of tempValue into j
                    listOfInt[j]  = tempValue;
                }
            }       
        }
        //To print the asscending order on console
        System.debug('Asscending order is'+listOfInt) ;
    }    
}