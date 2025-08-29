@isTest
public class SLARemainingTimeSendEmailBatchTest {
    
    @isTest
    public static void testMethod1(){
        Account ac = new Account();
        ac.Name = 'Test Acc';
        ac.Account_Technician__c = system.UserInfo.getUserId();
        ac.Regional_performance_manager__c = system.UserInfo.getUserId();
        insert ac;
        
        case cs = new case();
        cs.AccountId = ac.Id;
        insert cs;
        test.startTest();
        SLARemainingTimeSendEmailBatch obj = new SLARemainingTimeSendEmailBatch();
        DataBase.executeBatch(obj); 
        
        SLARemainingTimeSendEmailBatchSchedule sh1 = new SLARemainingTimeSendEmailBatchSchedule();
        String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1);
 
        test.stopTest();
    }
}