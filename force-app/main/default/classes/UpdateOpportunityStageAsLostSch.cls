global class UpdateOpportunityStageAsLostSch implements Schedulable {
    global void execute(SchedulableContext sc) {
        UpdateOpportunityStageAsLostBatch batchJob = new UpdateOpportunityStageAsLostBatch();
        // The second parameter specifies the batch size (up to 200)
        Database.executeBatch(batchJob, 1);
    }
}