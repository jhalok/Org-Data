@isTest
public class GoogleDriveCntrlrTest{
    
    @isTest 
    static void testgetToken(){
        if (test.isRunningTest()){
            Test.setMock(HttpCalloutMock.class, new UploadFileMock());
        }
        GoogleDriveCntrlr gdCnt = new GoogleDriveCntrlr();    
        gdCnt.getToken();
    }
    
    @isTest
    static void testgetnewToken(){
        if (test.isRunningTest()){
            Test.setMock(HttpCalloutMock.class, new UploadFileMock());
        }
        GoogleDriveCntrlr gdCnt = new GoogleDriveCntrlr();    
        gdCnt.saveToken();
    }
    
    @isTest
    static void testsaveToken(){       
        if (test.isRunningTest()){
            Test.setMock(HttpCalloutMock.class, new UploadFileMock());
        }
        GoogleDriveCntrlr gdCnt = new GoogleDriveCntrlr();
        gdCnt.code = '1234';
        gdCnt.secret = '324324324';
        gdCnt.accessToken = '322453254';
        gdCnt.refresh_token = 'fsdfsdfssd';
        gdCnt.getAccessTokenFromRefreshToken(gdCnt.secret,gdCnt.accessToken,gdCnt.refresh_token);
    }
    
    @isTest
    static void testinit(){
        if (test.isRunningTest()){
            Test.setMock(HttpCalloutMock.class, new UploadFileMock());
        }
        insert new GoogleDrive__c(Client_secret__c = 'Value',Client_Id__c ='12314',Redirect_Url__c='www.google.com');
        GoogleDriveCntrlr ggDrv = new GoogleDriveCntrlr();
        pageReference pager = page.GDriveIntVFPage;
        Test.setCurrentPage(pager);
        ggDrv.code = '1234';
        Account acc = new Account();
        acc.Name = 'TestAccount';
        insert acc;
        ggDrv.init();
    }   
}