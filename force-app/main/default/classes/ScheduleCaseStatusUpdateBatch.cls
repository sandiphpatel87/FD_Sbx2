public class ScheduleCaseStatusUpdateBatch implements Schedulable 
{
    public void execute(SchedulableContext context) 
    {
        CaseStatusUpdateBatch batchJob = new CaseStatusUpdateBatch();
        Database.executeBatch(batchJob);
    }
}