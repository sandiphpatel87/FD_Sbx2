global class SLARemainingTimeSendEmailBatchSchedule implements Schedulable{
    global void execute(SchedulableContext sc) {
        //invoke the batch class
        Database.executeBatch(new SLARemainingTimeSendEmailBatch());
    }
}