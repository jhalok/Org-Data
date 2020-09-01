public class FileUploadController {  

   @AuraEnabled  

   public static void getClient(string oppid){  

     //set<Id> idset = new set<Id>();  

     String idTest;  
		System.debug('oppid'+oppid);
     Opportunity opp =[Select id,Name from Opportunity];  

     List<ContentDocumentLink> conlink = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: oppid];  
	System.debug('conlink---'+conlink);
     for(ContentDocumentLink conids : conlink){  

       //idset.add(conids.ContentDocumentId);  

       idTest = conids.ContentDocumentId;  

     }  

     ContentDocument contDoc = [Select Id ,Title from ContentDocument Where Id =: idTest];  
	System.debug('contdoc'+contDoc);
     ContentVersion conver = [SELECT VersionData,FileType FROM ContentVersion WHERE ContentDocumentId = :contDoc.Id];  
	System.debug('conver'+conver);
     system.debug('===============conver==============='+conver.VersionData);  

     GoogleDrive__c googleCusSetting = new GoogleDrive__c();  

    googleCusSetting = [Select id,Client_Id__c,FolderId__c,Client_secret__c,Refresh_Token__c,Access_token__c,GoogleAccountDomain__c,Redirect_Url__c from GoogleDrive__c limit 1];  

 

//this code is For Access Token from Refresh token
 

     String accessToken;  

     Http h = new Http();  

     HttpRequest req = new HttpRequest();  

     string endPointValue = 'https://accounts.google.com/o/oauth2/token';    

     req.setEndpoint(endPointValue);  

     string bodyRequest = 'client_id='+googleCusSetting.Client_Id__c+'&client_secret='+googleCusSetting.Client_secret__c+'&refresh_token='+googleCusSetting.Refresh_Token__c+'&grant_type=refresh_token';  

     system.debug('===bodyRequest==='+bodyRequest);  

     req.setBody(bodyRequest);       

     req.setHeader('Content-length', string.ValueOf(bodyRequest.length()));   

     req.setHeader('Content-Type', 'application/x-www-form-urlencoded');  

     req.setMethod('POST');  

     req.setTimeout(10000);  

     HttpResponse res = h.send(req);    

     System.debug('Response Value:'+res.getBody());  

     if(res.getBody() != null && res.getStatusCode()==200){  

       Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());  

       System.debug(' ====You can parse the response to get the access token ==== ' + results);  

       accessToken=string.valueOf(results.get('access_token'));  

       system.debug('====accessToken==='+accessToken);  

     }  

     //this code is for pdf upload  
 

	  if(conver.FileType == 'PDF'){  

       String boundary = '———-9889464542212';  

       String delimiter = '\r\n–' + boundary + '\r\n';  

       String close_delim = '\r\n–' + boundary + '–';  

       system.debug('===================conver.VersionData======================='+conver.VersionData);  

       String bodyEncoded = EncodingUtil.base64Encode( conver.VersionData);  

       String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "title" : "' + contDoc.Title + '",' + ' "mimeType" : "application/' + conver.FileType + '","parents" :[{"id":"'+googleCusSetting.FolderId__c+'"}]}' + delimiter + 'Content-Type: application/' + conver.FileType + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;  

       system.debug('==================body======================'+body);  

       Http http = new Http();  

       HttpRequest req1 = new HttpRequest();  

       req1.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');  

       req1.setHeader('Authorization', 'Bearer ' + accessToken);  

       req1.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');  

       req1.setHeader('Content-length', String.valueOf(body.length()));  

       req1.setBody(body);  

       req1.setMethod('POST');  

       req1.setTimeout(60 * 1000);  

       HttpResponse resp = http.send(req1);  

       system.debug('==============response================'+resp);  

     }  

     //this code is to upload image  
 
  /* 
     if(conver.FileType == ‘JPG’ || conver.FileType == ‘JPEG’ || conver.FileType == ‘PNG’){  

       String boundary2 = ‘———-9889464542212’;  

       String delimiter2 = ‘\r\n–‘ + boundary2 + ‘\r\n’;  

       String close_delim2 = ‘\r\n–‘ + boundary2 + ‘–‘;  

       system.debug(‘===================conver.VersionData=======================’+conver.VersionData);  

       String bodyEncoded2 = EncodingUtil.base64Encode( conver.VersionData);  

       String body2 = delimiter2 + ‘Content-Type: application/json\r\n\r\n’ + ‘{ “title” : “‘ + contDoc.Title + ‘”,’ + ‘ “mimeType” : “image/’ + conver.FileType + ‘”,”parents” :[{“id”:”‘+opp.Client_Collateral_Folder_Id__c+'”}]}’ + delimiter2 + ‘Content-Type: imager/’ + conver.FileType + ‘\r\n’ + ‘Content-Transfer-Encoding: base64\r\n’ + ‘\r\n’ + bodyEncoded2 + close_delim2;  

       system.debug(‘==================body======================’+body2);  

       Http http2 = new Http();  

       HttpRequest req2 = new HttpRequest();  

       req2.setEndpoint(‘https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart’);  

       req2.setHeader(‘Authorization’, ‘Bearer ‘ + accessToken);  

       req2.setHeader(‘Content-Type’, ‘multipart/mixed; boundary=”‘ + boundary2 + ‘”‘);  

       req2.setHeader(‘Content-length’, String.valueOf(body2.length()));  

       req2.setBody(body2);  

       req2.setMethod(‘POST’);  

       req2.setTimeout(60 * 1000);  

       HttpResponse resp2 = http2.send(req2);  

       system.debug(‘==============response================’+resp2);  

     }  

     //this code is for .docx upload  
 

     if(conver.FileType == ‘WORD_X’){  

       String boundary3 = ‘———-9889464542212’;  

       String delimiter3 = ‘\r\n–‘ + boundary3 + ‘\r\n’;  

       String close_delim3 = ‘\r\n–‘ + boundary3 + ‘–‘;  

       system.debug(‘===================conver.VersionData=======================’+conver.VersionData);  

       String bodyEncoded3 = EncodingUtil.base64Encode( conver.VersionData);  

       String body3 = delimiter3 + ‘Content-Type: application/json\r\n\r\n’ + ‘{ “title” : “‘ + contDoc.Title + ‘”,’ + ‘ “mimeType” : “application/vnd.openxmlformats-officedocument.wordprocessingml.document”,”parents” :[{“id”:”‘+opp.Client_Collateral_Folder_Id__c+'”}]}’ + delimiter3 + ‘Content-Type: application/’ + conver.FileType + ‘\r\n’ + ‘Content-Transfer-Encoding: base64\r\n’ + ‘\r\n’ + bodyEncoded3 + close_delim3;  

       system.debug(‘==================body======================’+body3);  

       Http http3 = new Http();  

       HttpRequest req3 = new HttpRequest();  

       req3.setEndpoint(‘https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart’);  

       req3.setHeader(‘Authorization’, ‘Bearer ‘ + accessToken);  

       req3.setHeader(‘Content-Type’, ‘multipart/mixed; boundary=”‘ + boundary3 + ‘”‘);  

       req3.setHeader(‘Content-length’, String.valueOf(body3.length()));  

       req3.setBody(body3);  

       req3.setMethod(‘POST’);  

       req3.setTimeout(60 * 1000);  

       HttpResponse resp3 = http3.send(req3);  

       system.debug(‘==============response================’+resp3);  

     }  

   }  */

 }
}