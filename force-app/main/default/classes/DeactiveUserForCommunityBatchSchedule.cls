global class DeactiveUserForCommunityBatchSchedule implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        DeactiveUserForCommunityBatch b = new DeactiveUserForCommunityBatch(); // Your batch class
        database.executeBatch(b);
    }
}