public class productListController {
	
    private string APIkey = '85uCz9GNs';
	private string transKey = '9TzEt3P75t5kw2MT';
	private string Amt = '5';
    private string cardNum = '5424000000000015';
	private string expdate = '1220';
	private string cvvCode = '999';
    
    @AuraEnabled
    public static List<Product2> getItems(){
        
        List<Product2> prodItem=[Select Name,Quantity__c,Description,(Select UnitPrice From PricebookEntries limit 1) From Product2];
        
        return prodItem;
    }
    
    @AuraEnabled
    public static void makePayment(String jsonStr){
      
    Http h = new Http();
	HttpRequest req = new HttpRequest();
	req.setEndpoint('https://apitest.authorize.net/xml/v1/request.api');
	req.setMethod('POST');
    req.setHeader('Content-Length', '512'); 
	req.setBody(jsonStr);
	HttpResponse res = h.send(req);
	system.debug('response ' + res);
	system.debug('response body ' + res.getBody());
    }
}