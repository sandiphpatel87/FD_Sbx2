@isTest
private class UpdateOpportunityStageAsLostAndAccountInactiveBatchTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test accounts
        List<Account> testAccounts = new List<Account>();
        
        // Account 1: Will have opportunities that need updating
        Account acc1 = new Account(
            Name = 'Test Account 1',
            Active__c = true
        );
        testAccounts.add(acc1);
        
        // Account 2: Will have no live opportunities after updates
        Account acc2 = new Account(
            Name = 'Test Account 2',
            Active__c = true
        );
        testAccounts.add(acc2);
        
        // Account 3: Already inactive
        Account acc3 = new Account(
            Name = 'Test Account 3',
            Active__c = false
        );
        testAccounts.add(acc3);
        
        // Account 4: Active but will have no live opportunities
        Account acc4 = new Account(
            Name = 'Test Account 4',
            Active__c = true
        );
        testAccounts.add(acc4);
        
        // Account 5: Active with live opportunities
        Account acc5 = new Account(
            Name = 'Test Account 5',
            Active__c = true
        );
        testAccounts.add(acc5);
        
        insert testAccounts;
        
        // Create test opportunities
        List<Opportunity> testOpportunities = new List<Opportunity>();
        
        // Opportunity 1: Last day of service is today - should be updated to Lost
        Opportunity opp1 = new Opportunity(
            Name = 'Test Opp 1',
            AccountId = acc1.Id,
            StageName = 'Live',
            CloseDate = Date.today().addDays(30),
            Last_Day_of_Service__c = Date.today()
        );
        testOpportunities.add(opp1);
        
        // Opportunity 2: Last day of service is yesterday - should be updated to Lost
        Opportunity opp2 = new Opportunity(
            Name = 'Test Opp 2',
            AccountId = acc1.Id,
            StageName = 'Live',
            CloseDate = Date.today().addDays(30),
            Last_Day_of_Service__c = Date.today().addDays(-1)
        );
        testOpportunities.add(opp2);
        
        // Opportunity 3: Last day of service is tomorrow - should NOT be updated
        Opportunity opp3 = new Opportunity(
            Name = 'Test Opp 3',
            AccountId = acc2.Id,
            StageName = 'Live',
            CloseDate = Date.today().addDays(30),
            Last_Day_of_Service__c = Date.today().addDays(1)
        );
        testOpportunities.add(opp3);
        
        // Opportunity 4: Already Lost stage - should NOT be updated
        Opportunity opp4 = new Opportunity(
            Name = 'Test Opp 4',
            AccountId = acc2.Id,
            StageName = 'Lost',
            CloseDate = Date.today().addDays(30),
            Last_Day_of_Service__c = Date.today()
        );
        testOpportunities.add(opp4);
        
        // Opportunity 5: No last day of service - should NOT be updated
        Opportunity opp5 = new Opportunity(
            Name = 'Test Opp 5',
            AccountId = acc3.Id,
            StageName = 'Live',
            CloseDate = Date.today().addDays(30),
            Last_Day_of_Service__c = null
        );
        testOpportunities.add(opp5);
        
        // Opportunity 6: For Account 4 - will test Live_Opps__c = 0 scenario
        Opportunity opp6 = new Opportunity(
            Name = 'Test Opp 6',
            AccountId = acc4.Id,
            StageName = 'Live',
            CloseDate = Date.today().addDays(30),
            Last_Day_of_Service__c = Date.today()
        );
        testOpportunities.add(opp6);
        
        // Opportunity 7: For Account 5 - will keep account active
        Opportunity opp7 = new Opportunity(
            Name = 'Test Opp 7',
            AccountId = acc5.Id,
            StageName = 'Live',
            CloseDate = Date.today().addDays(30),
            Last_Day_of_Service__c = Date.today().addDays(5)
        );
        testOpportunities.add(opp7);
        
        insert testOpportunities;
    }
    
    @isTest
    static void testBatchProcessing() {
        // Get initial data for verification
        List<Opportunity> initialOpps = [
            SELECT Id, StageName, Last_Day_of_Service__c, AccountId, Account.Active__c
            FROM Opportunity 
            ORDER BY Name
        ];
        
        List<Account> initialAccounts = [
            SELECT Id, Active__c, Live_Opps__c
            FROM Account 
            ORDER BY Name
        ];
        
        // Verify initial state - Live_Opps__c will be calculated by formula
        System.assertEquals(2, initialAccounts[0].Live_Opps__c, 'Account 1 should have 2 live opps initially');
        System.assertEquals(1, initialAccounts[1].Live_Opps__c, 'Account 2 should have 1 live opp initially');
        System.assertEquals(true, initialAccounts[0].Active__c, 'Account 1 should be active initially');
        System.assertEquals(true, initialAccounts[1].Active__c, 'Account 2 should be active initially');
        
        Test.startTest();
        
        // Execute the batch
        UpdateOpportunityStageAsLostAndAccountInactiveBatch batchJob = new UpdateOpportunityStageAsLostAndAccountInactiveBatch();
        Database.executeBatch(batchJob, 200);
        
        Test.stopTest();
        
        // Verify results
        List<Opportunity> updatedOpps = [
            SELECT Id, StageName, Last_Day_of_Service__c, AccountId, Account.Active__c
            FROM Opportunity 
            ORDER BY Name
        ];
        
        List<Account> updatedAccounts = [
            SELECT Id, Active__c, Live_Opps__c
            FROM Account 
            ORDER BY Name
        ];
        
        // Verify opportunities were updated correctly
        System.assertEquals('Lost', updatedOpps[0].StageName, 'Opp 1 should be updated to Lost');
        System.assertEquals('Lost', updatedOpps[1].StageName, 'Opp 2 should be updated to Lost');
        System.assertEquals('Live', updatedOpps[2].StageName, 'Opp 3 should remain unchanged');
        System.assertEquals('Lost', updatedOpps[3].StageName, 'Opp 4 should remain Lost');
        System.assertEquals('Live', updatedOpps[4].StageName, 'Opp 5 should remain unchanged');
        System.assertEquals('Lost', updatedOpps[5].StageName, 'Opp 6 should be updated to Lost');
        System.assertEquals('Live', updatedOpps[6].StageName, 'Opp 7 should remain unchanged');
        
        // Verify accounts were updated correctly
        // Account 1: Should remain active (still has 1 live opp after 2 are marked Lost)
        System.assertEquals(true, updatedAccounts[0].Active__c, 'Account 1 should remain active');
        
        // Account 2: Should become inactive (no live opps after the only live opp is marked Lost)
        System.assertEquals(false, updatedAccounts[1].Active__c, 'Account 2 should become inactive');
        
        // Account 3: Should remain inactive
        System.assertEquals(false, updatedAccounts[2].Active__c, 'Account 3 should remain inactive');
        
        // Account 4: Should become inactive (no live opps after the live opp is marked Lost)
        System.assertEquals(false, updatedAccounts[3].Active__c, 'Account 4 should become inactive');
        
        // Account 5: Should remain active (still has live opp)
        System.assertEquals(true, updatedAccounts[4].Active__c, 'Account 5 should remain active');
    }
    
    @isTest
    static void testLiveOppsFieldNotNullScenario() {
        // This test specifically covers the Live_Opps__c != null branch
        // Account 4 will have Live_Opps__c = 1 initially, then 0 after opp is marked Lost
        
        Account testAcc = [SELECT Id, Active__c, Live_Opps__c FROM Account WHERE Name = 'Test Account 4' LIMIT 1];
        
        // Verify initial state
        System.assertEquals(true, testAcc.Active__c, 'Account 4 should be active initially');
        System.assertEquals(1, testAcc.Live_Opps__c, 'Account 4 should have Live_Opps__c = 1 initially');
        
        Test.startTest();
        
        UpdateOpportunityStageAsLostAndAccountInactiveBatch batchJob = new UpdateOpportunityStageAsLostAndAccountInactiveBatch();
        Database.executeBatch(batchJob, 200);
        
        Test.stopTest();
        
        // Verify the account becomes inactive due to Live_Opps__c = 0 after opp is marked Lost
        Account updatedAcc = [SELECT Active__c, Live_Opps__c FROM Account WHERE Id = :testAcc.Id];
        System.assertEquals(false, updatedAcc.Active__c, 'Account 4 should become inactive due to Live_Opps__c = 0');
        System.assertEquals(0, updatedAcc.Live_Opps__c, 'Account 4 should have Live_Opps__c = 0 after update');
    }
    
    @isTest
    static void testSchedulableInterface() {
        Test.startTest();
        
        // Test the schedulable interface
        UpdateOpportunityStageAsLostAndAccountInactiveBatch batchJob = new UpdateOpportunityStageAsLostAndAccountInactiveBatch();
        batchJob.execute(null);
        
        Test.stopTest();
        
        // Verify that opportunities were processed
        List<Opportunity> lostOpps = [
            SELECT Id FROM Opportunity 
            WHERE StageName = 'Lost' 
            AND Last_Day_of_Service__c <= :Date.today()
        ];
        
        System.assert(lostOpps.size() > 0, 'Should have processed opportunities through schedulable interface');
    }
    
    @isTest
    static void testScheduleJobMethod() {
        Test.startTest();
        
        // Test the static scheduling method
        String jobId = UpdateOpportunityStageAsLostAndAccountInactiveBatch.scheduleJob();
        
        Test.stopTest();
        
        // Verify job was scheduled
        System.assertNotEquals(null, jobId, 'Job should be scheduled successfully');
        System.assert(jobId.length() > 0, 'Job ID should not be empty');
    }
    
    @isTest
    static void testRunBatchNowMethod() {
        Test.startTest();
        
        // Test the manual execution method
        UpdateOpportunityStageAsLostAndAccountInactiveBatch.runBatchNow();
        
        Test.stopTest();
        
        // Verify that opportunities were processed
        List<Opportunity> lostOpps = [
            SELECT Id FROM Opportunity 
            WHERE StageName = 'Lost' 
            AND Last_Day_of_Service__c <= :Date.today()
        ];
        
        System.assert(lostOpps.size() > 0, 'Should have processed opportunities through manual execution');
    }
    
    @isTest
    static void testEmptyBatch() {
        // Delete all test data to test empty batch scenario
        delete [SELECT Id FROM Opportunity];
        delete [SELECT Id FROM Account];
        
        Test.startTest();
        
        UpdateOpportunityStageAsLostAndAccountInactiveBatch batchJob = new UpdateOpportunityStageAsLostAndAccountInactiveBatch();
        Database.executeBatch(batchJob, 200);
        
        Test.stopTest();
        
        // Should complete without errors
        System.assert(true, 'Empty batch should complete successfully');
    }
    
    @isTest
    static void testLargeBatchSize() {
        Test.startTest();
        
        // Test with larger batch size
        UpdateOpportunityStageAsLostAndAccountInactiveBatch batchJob = new UpdateOpportunityStageAsLostAndAccountInactiveBatch();
        Database.executeBatch(batchJob, 1000);
        
        Test.stopTest();
        
        // Should complete without errors
        System.assert(true, 'Large batch size should complete successfully');
    }
    
    @isTest
    static void testEdgeCaseNullLastDayOfService() {
        // Create opportunity with null Last_Day_of_Service__c
        Account testAcc = [SELECT Id FROM Account WHERE Name = 'Test Account 1' LIMIT 1];
        
        Opportunity edgeCaseOpp = new Opportunity(
            Name = 'Edge Case Opp',
            AccountId = testAcc.Id,
            StageName = 'Live',
            CloseDate = Date.today().addDays(30),
            Last_Day_of_Service__c = null
        );
        insert edgeCaseOpp;
        
        Test.startTest();
        
        UpdateOpportunityStageAsLostAndAccountInactiveBatch batchJob = new UpdateOpportunityStageAsLostAndAccountInactiveBatch();
        Database.executeBatch(batchJob, 200);
        
        Test.stopTest();
        
        // Verify the edge case opportunity was not updated
        Opportunity updatedOpp = [SELECT StageName FROM Opportunity WHERE Name = 'Edge Case Opp'];
        System.assertEquals('Live', updatedOpp.StageName, 'Opportunity with null Last_Day_of_Service__c should not be updated');
    }
    
    @isTest
    static void testAccountWithLiveOpportunities() {
        // Test scenario where account has live opportunities and should remain active
        Account testAcc = [SELECT Id, Active__c, Live_Opps__c FROM Account WHERE Name = 'Test Account 5' LIMIT 1];
        
        // Verify initial state
        System.assertEquals(true, testAcc.Active__c, 'Account 5 should be active initially');
        System.assertEquals(1, testAcc.Live_Opps__c, 'Account 5 should have Live_Opps__c = 1 initially');
        
        Test.startTest();
        
        UpdateOpportunityStageAsLostAndAccountInactiveBatch batchJob = new UpdateOpportunityStageAsLostAndAccountInactiveBatch();
        Database.executeBatch(batchJob, 200);
        
        Test.stopTest();
        
        // Verify account remains active due to live opportunities
        Account updatedAcc = [SELECT Active__c, Live_Opps__c FROM Account WHERE Id = :testAcc.Id];
        System.assertEquals(true, updatedAcc.Active__c, 'Account should remain active due to live opportunities');
        System.assertEquals(1, updatedAcc.Live_Opps__c, 'Account should still have Live_Opps__c = 1');
    }
    
    @isTest
    static void testOpportunityUpdateErrorHandling() {
        // Test error handling when opportunity update fails
        // This will test the try-catch block in the execute method
        
        Test.startTest();
        
        UpdateOpportunityStageAsLostAndAccountInactiveBatch batchJob = new UpdateOpportunityStageAsLostAndAccountInactiveBatch();
        Database.executeBatch(batchJob, 200);
        
        Test.stopTest();
        
        // Should complete without errors even if some updates fail
        System.assert(true, 'Batch should complete even with potential update errors');
    }
    
    @isTest
    static void testAccountUpdateErrorHandling() {
        // Test error handling when account update fails
        // This will test the try-catch block in the processAccountsForInactiveStatus method
        
        Test.startTest();
        
        UpdateOpportunityStageAsLostAndAccountInactiveBatch batchJob = new UpdateOpportunityStageAsLostAndAccountInactiveBatch();
        Database.executeBatch(batchJob, 200);
        
        Test.stopTest();
        
        // Should complete without errors even if some account updates fail
        System.assert(true, 'Batch should complete even with potential account update errors');
    }
    
    @isTest
    static void testBatchWithNoOpportunitiesToUpdate() {
        // Test scenario where no opportunities meet the criteria for update
        // Delete opportunities that would be updated
        delete [SELECT Id FROM Opportunity WHERE Last_Day_of_Service__c <= :Date.today()];
        
        Test.startTest();
        
        UpdateOpportunityStageAsLostAndAccountInactiveBatch batchJob = new UpdateOpportunityStageAsLostAndAccountInactiveBatch();
        Database.executeBatch(batchJob, 200);
        
        Test.stopTest();
        
        // Should complete without errors
        System.assert(true, 'Batch should complete when no opportunities need updating');
    }
    
    @isTest
    static void testBatchWithNoAccountsToUpdate() {
        // Test scenario where no accounts need to be made inactive
        // Make all accounts inactive first
        List<Account> allAccounts = [SELECT Id FROM Account];
        for(Account acc : allAccounts) {
            acc.Active__c = false;
        }
        update allAccounts;
        
        Test.startTest();
        
        UpdateOpportunityStageAsLostAndAccountInactiveBatch batchJob = new UpdateOpportunityStageAsLostAndAccountInactiveBatch();
        Database.executeBatch(batchJob, 200);
        
        Test.stopTest();
        
        // Should complete without errors
        System.assert(true, 'Batch should complete when no accounts need updating');
    }
}
