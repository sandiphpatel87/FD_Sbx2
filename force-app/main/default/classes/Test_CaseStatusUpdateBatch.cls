@IsTest
public class Test_CaseStatusUpdateBatch 
{
    @IsTest
    static void testCalculateCaseDueDate() 
    {
        // Create test User
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User']; // Replace 'Standard User' with the actual profile name
        User testUser = new User(
            Alias = 'testuser',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'uniquewuser@example.com'
        );
        insert testUser;
        
        Account acc = new Account();
        acc.name = 'Demo account';
        acc.Regional_performance_manager__c = testUser.Id;
        acc.Account_Technician__c = testUser.Id;
        acc.Secondary_Account_Technician__c = testUser.Id;
        Insert acc;
        
        Case testCase = new Case();
        testCase.AccountId = acc.Id;
        testCase.Priority = 'low';
        testCase.Request_Type__c = 'Future Budget Change';
        testCase.status = 'Future';
        testCase.Origin = 'Google Meet';
        testCase.Subject = 'Test Case';
       	testcase.Start_Month__c = 'June';
        testCase.SLA_Time__c = 8;
        Insert testcase;
        
        test.startTest();
        ScheduleCaseStatusUpdateBatch sc = new ScheduleCaseStatusUpdateBatch();
        String cronExp = '0 0 2 * * ?'; 

        String jobName = 'My Scheduled Job';
        
        System.schedule(jobName, cronExp, sc);
        
        test.stopTest();
    }
}