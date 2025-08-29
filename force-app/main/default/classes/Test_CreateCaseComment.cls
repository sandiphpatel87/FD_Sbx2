@isTest
public class Test_CreateCaseComment 
{
    @isTest
    static void testCreateCaseCommentTrigger() 
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
        Insert acc;//Regional Performance Manager,Account Technician,Secondary Account Technician

        
        // Create test Case
        Case testCase = new Case();
        testCase.AccountId = acc.Id;//Case Origin,Request Type,Priority,status
        testCase.Priority = 'low';
        testCase.Request_Type__c = 'Bid Change';
        testCase.status = 'new';
        testCase.Origin = 'Google Meet';
        testCase.Subject = 'Test Case';
        insert testCase;
        
        // Create test Chatter post
        FeedItem testChatterPost = new FeedItem();
        testChatterPost.ParentId = testCase.Id;
        testChatterPost.Body = 'This is a test Chatter post.';
        insert testChatterPost;
    }
}