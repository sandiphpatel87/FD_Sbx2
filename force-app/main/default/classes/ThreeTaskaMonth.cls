public class ThreeTaskaMonth implements Database.Batchable<sObject>, Schedulable {
public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select id,UserRoleId, UserRole.Name from user where IsActive = true and UserRole.Name =\'Account Technician\'' );
    }
    public void execute(Database.BatchableContext bc, List<user> scope){
        list<Task> TaskList = new list<Task>();
        for(user obj :scope){
            Task tsk = new Task();
            tsk.Status = 'Open';
            tsk.Subject = 'Facebook pacing';
            tsk.Priority = 'Normal';
            tsk.OwnerId = obj.Id;
            tsk.Notes__c = 'https://foundationdirect.lightning.force.com/lightning/r/Report/00O4W000008IF7FUAW/view?queryScope=userFolders';
            tsk.ActivityDate = system.today().adddays(2);
            TaskList.add(tsk);
        }
        database.Insert(TaskList);
    }
    public void finish(Database.BatchableContext bc){}
    public void execute(SchedulableContext sc) {
        ThreeTaskaMonth batch = new ThreeTaskaMonth(); 
        database.executebatch(batch);
    }
}