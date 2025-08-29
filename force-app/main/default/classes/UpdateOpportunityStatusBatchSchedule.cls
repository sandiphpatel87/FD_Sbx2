global class UpdateOpportunityStatusBatchSchedule implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        UpdateOpportunityStatusBatch b = new UpdateOpportunityStatusBatch(); // Your batch class
        database.executeBatch(b);
    }
}