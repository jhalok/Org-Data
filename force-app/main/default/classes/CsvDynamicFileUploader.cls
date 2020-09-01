public class CsvDynamicFileUploader {
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    public String selectedObject {get; set;}
    String[] filelines = new String[]{};
    public List<String> headervalues {get;set;}
    List<Sobject> recordstoupload;
 
    //get Object Name //
    public List<SelectOption> getObjectNames(){
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();     
        List<SelectOption> objNames = new List<SelectOption>();
        objNames.add(new SelectOption('','-- Select --'));
        for(Schema.SObjectType f : gd)
        {
           objNames.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getLabel()));
        }
        objNames.sort();
        return objNames;
    }
     
    public Pagereference ReadFile()
    {
        try{
                System.debug('\n Selected Object'+selectedObject);
                if(selectedObject == null)
                {
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Object Should be selected');
                    ApexPages.addMessage(errormsg);
                    return null;
                }
                //Convert the uploaded file which is in BLOB format into a string
                nameFile =blobToString( contentFile,'ISO-8859-1');
                 
                //Now sepatate every row of the excel file
                filelines = nameFile.split('\n');
                Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
                Schema.SObjectType objecttypeinfo=gd.get(selectedObject);
                 
                //Iterate through every line and create a Account record for each row
                recordstoupload= new List<Sobject>();
                headerValues =new List<String>();
                headerValues = filelines[0].trim().split(',');
                for (Integer i=1;i<filelines.size();i++)
                {
                    String[] inputvalues = new String[]{};
                    inputvalues = filelines[i].split(',');
                    sObject sObj = Schema.getGlobalDescribe().get(selectedObject).newSObject() ;  
                    for(Integer j=0;j<headerValues.size();j++){
                        sObj.put(headerValues[j],inputvalues[j]) ;  
                    }
                    recordstoupload.add(sObj);
                }
         }
         catch(Exception e){
                 ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured reading the CSV file'+e.getMessage());
                ApexPages.addMessage(errormsg);
         }       
        //Finally, insert the collected records
        try{
            insert recordstoupload;
        }
        catch (Exception e)
        {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting the records'+e.getMessage());
            ApexPages.addMessage(errormsg);
        }    
        return null;
    }
    
    public List<Sobject> getuploadedAccounts()
    {
        if (recordstoupload!= NULL)
            if (recordstoupload.size() > 0)
                return recordstoupload;
            else
                return null;                    
        else
            return null;
    }  
 
    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }         
}