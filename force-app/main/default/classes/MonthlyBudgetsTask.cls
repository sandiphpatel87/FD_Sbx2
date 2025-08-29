public class MonthlyBudgetsTask implements Database.Batchable<sObject>, Schedulable {
public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select id,UserRoleId, UserRole.Name from user where IsActive = true and UserRole.Name =\'Account Technician\'' );
    }
    public void execute(Database.BatchableContext bc, List<user> scope){
        list<Task> TaskList = new list<Task>();
        for(user obj :scope){
            Task tsk = new Task();
            tsk.Status = 'Open';
            tsk.Subject = 'Update Monthly Budgets in the Budget Planner';
            tsk.Priority = 'Normal';
            tsk.OwnerId = obj.Id;
            tsk.Notes__c = 'https://login.foundationdirect.com/budget/'+'\n'+'https://foundationdirect.lightning.force.com/lightning/r/Report/00O4W000008I9qvUAC/view?queryScope=userFolders';
            tsk.ActivityDate = system.today().adddays(4);
            TaskList.add(tsk);
        }
        database.Insert(TaskList);
    }
    public void finish(Database.BatchableContext bc){}
    public void execute(SchedulableContext sc) {
        MonthlyBudgetsTask batch = new MonthlyBudgetsTask(); 
        database.executebatch(batch);
    }
}