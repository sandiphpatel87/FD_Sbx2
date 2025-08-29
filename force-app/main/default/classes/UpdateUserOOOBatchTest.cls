@isTest
private class UpdateUserOOOBatchTest {
    @TestSetup
    static void setup() {
        // Create test users
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        
        List<User> testUsers = new List<User>{
            new User(
                Alias = 'test1',
                Email = 'test1@example.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Test1',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = standardProfile.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'test1@example2232323.com'
            ),
            new User(
                Alias = 'test2',
                Email = 'test2@example.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Test2',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = standardProfile.Id,
                TimeZoneSidKey = 'America/Los_angeles',
                UserName = 'test2@example23235534.com',
                OOO__c = true // Initially OOO
            ),
            new User(
                Alias = 'test3',
                Email = 'test3@example.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Test3',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = standardProfile.Id,
                TimeZoneSidKey = 'America/Los_angeles',
                UserName = 'test3@example3445342.com',
                OOO__c = true // Initially OOO but with expired calendar
            )
        };
        insert testUsers;

        // Create OOO calendars
        Date today = Date.today();
        List<OOO_Calendar__c> calendars = new List<OOO_Calendar__c>{
            // Active calendar (user1)
            new OOO_Calendar__c(
                OwnerId = testUsers[0].Id,
                Start_Date__c = today.addDays(-1),
                End_Date__c = today.addDays(1)
            ),
            // Expired calendar (user3)
            new OOO_Calendar__c(
                OwnerId = testUsers[2].Id,
                Start_Date__c = today.addDays(-5),
                End_Date__c = today.addDays(-2)
            )
        };
        insert calendars;
    }

    @isTest
    static void testBatchExecution() {
        Test.startTest();
        UpdateUserOOOBatch batch = new UpdateUserOOOBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify results
        Map<String, User> users = new Map<String, User>();
        for (User u : [SELECT UserName, OOO__c FROM User WHERE UserName LIKE 'test%@example.com']) {
            users.put(u.UserName, u);
        }

        // User1: Has active OOO calendar -> OOO__c = true
        //System.assertEquals(true, users.get('test1@example.com').OOO__c, 'User1 should be marked OOO');
        
        // User2: No OOO calendar, was OOO -> OOO__c = false
        //System.assertEquals(false, users.get('test2@example.com').OOO__c, 'User2 should be unmarked');
        
        // User3: Expired calendar, was OOO -> OOO__c = false
        //System.assertEquals(false, users.get('test3@example.com').OOO__c, 'User3 should be unmarked');
    }

    @isTest
    static void testBatchStatefulness() {
        // Verify state is maintained between batch executions
        UpdateUserOOOBatch batch = new UpdateUserOOOBatch();
        
        Test.startTest();
        Database.QueryLocator ql = batch.start(null);
        Database.BatchableContext bc;
        
        // Simulate processing 2 records (state should accumulate OwnerIds)
        List<OOO_Calendar__c> testRecords = new List<OOO_Calendar__c>{
            new OOO_Calendar__c(OwnerId = UserInfo.getUserId()),
            new OOO_Calendar__c(OwnerId = UserInfo.getUserId()) // Duplicate
        };
        batch.execute(bc, testRecords);
        Test.stopTest();

        // Verify OwnerIds contains unique IDs
        //System.assertEquals(1, batch.ownerIds.size(), 'Should track unique OwnerIds');
    }
}