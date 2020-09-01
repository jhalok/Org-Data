public class StringArrayTest {
    
    public static List<String> generateStringArray(Integer n){
        
        List<String> listOFCandidates = new List<String>();
        for(Integer i=0;i<n;i++){
            listOFCandidates.add('Test '+i);
            System.debug(listOFCandidates[i]);
        }       
        return listOFCandidates;
    }
}