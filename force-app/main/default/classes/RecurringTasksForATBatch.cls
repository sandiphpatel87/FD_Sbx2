public class RecurringTasksForATBatch implements Database.Batchable<sObject>, Schedulable {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select id,UserRoleId, UserRole.Name from user where IsActive = true and UserRole.Name =\'Account Technician\'' );
    }
    public void execute(Database.BatchableContext bc, List<user> scope){
        list<Task> TaskList = new list<Task>();
        for(user obj :scope){
            Task tsk = new Task();
            tsk.Status = 'Open';
            tsk.Subject = 'Review Apollo Pacing';
            tsk.Priority = 'Normal';
            tsk.OwnerId = obj.Id;
            tsk.Notes__c = 'https://login.foundationdirect.com/DigitalAdministration#/tier3/setup/dashboard/pacing/report/pacing-report';
            tsk.ActivityDate = system.today();
            TaskList.add(tsk);
            Task tskPriority = new Task();
            tskPriority.Status = 'Open';
            tskPriority.Subject = 'Daily AT Priority Tasks';
            tskPriority.Priority = 'Normal';
            tskPriority.OwnerId = obj.Id;
            tskPriority.Notes__c = 'Paused For Open Targeting \n Budget = $0.10 Google Ad Alert \n Disapproved Ads - Trademarks, Phone Number in Ad Test, Bail Bonds \n Products To Activate in Apollo \n Products Live w/o Budget in Apollo \n Today’s Video Budget Report'; 
            tskPriority.ActivityDate = system.today();
            TaskList.add(tskPriority);
        }
        database.Insert(TaskList);
    }
    public void finish(Database.BatchableContext bc){}
    public void execute(SchedulableContext sc) {
        RecurringTasksForATBatch batch = new RecurringTasksForATBatch(); 
        database.executebatch(batch);
    }
    
}