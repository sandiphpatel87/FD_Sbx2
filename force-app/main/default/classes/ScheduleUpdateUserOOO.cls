// Schedulable class to run the batch daily
global class ScheduleUpdateUserOOO implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new UpdateUserOOOBatch(), 200);
    }
}