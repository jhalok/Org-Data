/*global with sharing class UploadFileMock implements HTTPCalloutMock{
    global HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/JSON');
        res.setBody('Your body');
        res.setStatusCode(201);
        return res;
    }
}*/

@isTest
global class UploadFileMock implements HttpCalloutMock {
    // Implement this interface method 
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://xxxxxxxx.com', req.getEndpoint());
        //System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        return res;
    }
}