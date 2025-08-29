@IsTest
public class CaseAssignmentBatchTest 
{
    @IsTest
    public static void testCaseAssignmentBatchTest() 
    {
        Test.startTest();
        
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
        
        List<Case> insertCs = new List<Case>();
        // Create test data
        Case testCase = new Case();
        testCase.AccountId = acc.Id;
        testCase.Priority = 'low';
        testCase.Request_Type__c = 'Performance Review';
        testCase.status = 'new';
        testCase.Origin = 'Google Meet';
        testCase.Subject = 'Test Case';
        testCase.SLA_Time__c = 9;
        testCase.Close_Date__c = System.today()-10;
        insertCs.add(testCase);
                
        Case testCase3 = new Case();
        testCase3.AccountId = acc.Id;
        testCase3.status = 'New';
        testCase3.Request_Type__c = 'Weekly QA';
        testCase3.Origin = 'Google Meet';
        testCase3.Subject = 'Test Case';
        testCase3.Close_Date__c = System.today();
        insertCs.add(testCase3);
        
        Insert insertCs;
        
        Case updatedCase3 = new Case(Id = insertCs[1].Id);
        updatedCase3.Case_Assign_To__c = null;
        updatedCase3.Case_Assignment_Queue__c = 'Helpware';         
        update updatedCase3;
        
        CaseAssignmentBatch b = new CaseAssignmentBatch(); 
        Database.executeBatch(b);
        
        Test.stopTest();
    }
}