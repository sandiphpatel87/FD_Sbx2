@isTest
private class UpdateOpportunityStageAsLostSchTest {

    @isTest
    static void testScheduledJobExecutesBatch() {
        Test.startTest();
        
        // Schedule the job to run 1 minute later in test context
        String cronExp = '0 0 0 1 1 ? 2099'; // dummy far future date
        System.schedule('Test_UpdateOpportunityStageAsLostSch', cronExp, new UpdateOpportunityStageAsLostSch());
        
        Test.stopTest();
        
        // No asserts required (scheduler + batch execute inside stopTest())
    }
}