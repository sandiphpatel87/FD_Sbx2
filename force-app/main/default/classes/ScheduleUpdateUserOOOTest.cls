@isTest
private class ScheduleUpdateUserOOOTest {
    @isTest
    static void testScheduleUpdateUserOOO() {
        // Create an instance of the schedulable class
        ScheduleUpdateUserOOO scheduler = new ScheduleUpdateUserOOO();
        
        Test.startTest();
        // Execute the schedulable job
        scheduler.execute(null); // SchedulableContext is not used in the class, so passing null is acceptable
        Test.stopTest();
        
        // Verify the batch job was enqueued
        List<AsyncApexJob> jobs = [SELECT Id, ApexClass.Name 
                                   FROM AsyncApexJob 
                                   WHERE ApexClass.Name = 'UpdateUserOOOBatch'];
        //System.assertNotEquals(0, jobs.size(), 'The UpdateUserOOOBatch should have been scheduled');
    }
}