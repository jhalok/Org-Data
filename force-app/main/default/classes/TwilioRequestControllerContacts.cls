public with sharing class TwilioRequestControllerContacts 
{
    public String fromNumber      = ApexPages.currentPage().getParameters().get('From');
    public String toNumber        = ApexPages.currentPage().getParameters().get('To');
    public String body            = ApexPages.currentPage().getParameters().get('Body');
    
    public PageReference init()
    {
        try
        {           
            System.debug('STEP 0 FROM: ==========>' + fromNumber); 
            System.debug('STEP 1 TO: ===============>' + toNumber);
            System.debug('STEP 2 BODY: ==========>' + body); 
            IF(fromNumber != NULL && toNumber != NULL){
                Case c = new Case(Subject = toNumber+fromNumber,Description =body);
                insert c;
            }
            
        }
        catch(exception e){}
        RETURN null;
    }  
}