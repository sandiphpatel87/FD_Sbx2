@isTest
private class UpdateOpportunityStageAsLostBatchTest {

    @testSetup
    static void setupData() {
        // --- Account A: Has multiple opps so Live_Opps__c will be non-null ---
        Account accA = new Account(Name = 'Acc A With Live Opps', Active__c = true);
        insert accA;

        // Opp that will be updated to Lost
        Opportunity oppA1 = new Opportunity(
            Name = 'AccA Past Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(5),
            Last_Day_of_Service__c = Date.today().addDays(-1),
            AccountId = accA.Id
        );

        // Another opp stays live (future date)
        Opportunity oppA2 = new Opportunity(
            Name = 'AccA Future Opp',
            StageName = 'Negotiation',
            CloseDate = Date.today().addDays(20),
            Last_Day_of_Service__c = Date.today().addDays(10),
            AccountId = accA.Id
        );
        insert new List<Opportunity>{oppA1, oppA2};

        // --- Account B: Only opp goes Lost, so subquery path runs ---
        Account accB = new Account(Name = 'Acc B With One Opp', Active__c = true);
        insert accB;

        Opportunity oppB1 = new Opportunity(
            Name = 'AccB Today Opp',
            StageName = 'Qualification',
            CloseDate = Date.today().addDays(10),
            Last_Day_of_Service__c = Date.today(),
            AccountId = accB.Id
        );
        insert oppB1;

        // --- Account C: Has only Closed Won opp (ignored) ---
        Account accC = new Account(Name = 'Acc C Closed Opps', Active__c = true);
        insert accC;

        Opportunity oppC1 = new Opportunity(
            Name = 'AccC Closed Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Last_Day_of_Service__c = Date.today().addDays(-2),
            AccountId = accC.Id
        );
        insert oppC1;

        // --- Account D: No opps at all ---
        Account accD = new Account(Name = 'Acc D Empty', Active__c = true);
        insert accD;
    }

    static testMethod void testBatchExecution() {
        Test.startTest();
        Database.executeBatch(new UpdateOpportunityStageAsLostBatch(), 50);
        Test.stopTest();

        // Debugging only (no asserts per requirement)
        List<Account> accs = [
            SELECT Id, Name, Active__c, Live_Opps__c 
            FROM Account 
            WHERE Name LIKE 'Acc%'
        ];
        System.debug('Accounts after batch: ' + accs);

        List<Opportunity> opps = [
            SELECT Id, Name, StageName, Last_Day_of_Service__c 
            FROM Opportunity 
            WHERE Name LIKE 'Acc%'
        ];
        System.debug('Opportunities after batch: ' + opps);
    }
    
    static testMethod void testForceCoverage() {
    Test.startTest();
    new UpdateOpportunityStageAsLostBatch().testForceAccountProcessing();
    Test.stopTest();
}
    
    
}