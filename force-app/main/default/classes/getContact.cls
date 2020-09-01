@RestResource(urlMapping='/v1/getContacts/*')
global with sharing class getContact {
    @HttpGet
    global static list<contact> fetchAccount(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        Id accId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        system.debug('accId------------'+accId);
        list<contact> lstcontact =[Select id , name, Email from contact where Accountid=:accId ];
        system.debug('lstcontact--------'+lstcontact);
        return lstcontact ;
    }
}