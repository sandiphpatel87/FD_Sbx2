public class MonthlyTaskForAT implements Database.Batchable<sObject>, Schedulable {
public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select id,UserRoleId, UserRole.Name from user where IsActive = true and UserRole.Name =\'Account Technician\'' );
    }
    public void execute(Database.BatchableContext bc, List<user> scope){
        list<Task> TaskList = new list<Task>();
        for(user obj :scope){
            Task tsk = new Task();
            tsk.Status = 'Open';
            tsk.Subject = 'Rollbacks';
            tsk.Priority = 'Normal';
            tsk.OwnerId = obj.Id;
            tsk.Notes__c = 'https://foundationdirect.lightning.force.com/lightning/r/Report/00O4W000008I9mQUAS/view?queryScope=userFolders';
            tsk.ActivityDate = system.today().adddays(4);
            TaskList.add(tsk);
        }
        database.Insert(TaskList);
    }
    public void finish(Database.BatchableContext bc){}
    public void execute(SchedulableContext sc) {
        MonthlyTaskForAT batch = new MonthlyTaskForAT(); 
        database.executebatch(batch);
    }
}