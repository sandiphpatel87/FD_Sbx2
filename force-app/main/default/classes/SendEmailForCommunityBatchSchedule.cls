global class SendEmailForCommunityBatchSchedule implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        SendEmailForCommunityBatch b = new SendEmailForCommunityBatch(); // Your batch class
        database.executeBatch(b,1);
    }
}