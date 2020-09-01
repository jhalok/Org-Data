@isTest
private class Scheduler_SendEmailNotificationTest {
    
        public testMethod static void scheduleEmail_Test(){
          
            Test.startTest();
            String jobId=Scheduler_SendEmailNotification.scheduleEmail();
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(0, ct.TimesTriggered);
            System.assertEquals('2018-08-06 00:00:00', String.valueOf(ct.NextFireTime));   
            Test.stopTest();
            system.debug('String.valueOf(ct.NextFireTime)'+String.valueOf(ct.NextFireTime));
            
        }
    }