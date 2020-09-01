@isTest
public class GoogleDriveCntrlrHelperTest {
    
    @isTest
    static void testupldFile(){
        if (test.isRunningTest()){
            Test.setMock(HttpCalloutMock.class, new UploadFileMock());
        }
        
        Account acc = new Account(name='Test Account');
        insert acc;
        //GoogleDrive__c gdData = new GoogleDrive__c();
        Attachment attach = new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = acc.id;
        insert attach;
        String accesstoken = '123232';
        //List<Attachment> attachments=[select Id, Name from Attachment where id=: attach.Id];
        GoogleDriveCntrlrHelper gglDrv = new GoogleDriveCntrlrHelper();
        Test.startTest();
        GoogleDriveCntrlrHelper.upldFile(accesstoken,attach.Name,attach.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testcreateFolder(){
        GoogleDrive__c gdData = new GoogleDrive__c();
        if (test.isRunningTest()){
            Test.setMock(HttpCalloutMock.class, new UploadFileMock());
        }
        Account acc = new Account(name='Test Account');
        insert acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'Akjha';
        opp.AccountId = acc.Id;
        opp.StageName = 'Sourcing Demand';
        opp.CloseDate = System.today();
        insert opp;  
        String accesstoken = '123232';
        GoogleDriveCntrlrHelper gglDrv = new GoogleDriveCntrlrHelper();
        Test.startTest();
        GoogleDriveCntrlrHelper.createFolder(accesstoken,acc.Name,acc.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testcreateSubFolder(){
        GoogleDrive__c gdData = new GoogleDrive__c();
        if (test.isRunningTest()){
            Test.setMock(HttpCalloutMock.class, new UploadFileMock());
        }
        Account acc = new Account(name='Test Account');
        insert acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'Akjha';
        opp.AccountId = acc.Id;
        opp.StageName = 'Sourcing Demand';
        opp.CloseDate = System.today();
        insert opp;       
        //GoogleDrive__c gdData = new GoogleDrive__c();
        //GoogleDriveCntrlrHelper gglDrv = new GoogleDriveCntrlrHelper();
        String accesstoken = '123232';
        Test.startTest();
        GoogleDriveCntrlrHelper.createSubFolder(accesstoken,opp.Name,opp.Id);
    	Test.stopTest();
    } 
}