global class ScheduleCaseAssignmentBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CaseAssignmentBatch(), 200);
    }
}