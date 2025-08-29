public class UpcomingCoopTaskBatch implements Database.Batchable<sObject>, Schedulable {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select id,coop__c from Account where coop__c = true and Active__c = true');
    }
    public void execute(Database.BatchableContext bc, List<Account> scope){
        list<Task> TaskList = new list<Task>();
        for(Account obj :scope){
            Task tsk = new Task();
            tsk.whatId = obj.Id;
            tsk.Status = 'Open';
            tsk.ActivityDate = system.today();
            tsk.Subject = 'Coop';
            tsk.Priority = 'Normal';
            tsk.OwnerId = '0054W00000DIMXzQAP';
            TaskList.add(tsk);
        }
        Insert TaskList;
    }
    public void finish(Database.BatchableContext bc){}
    public void execute(SchedulableContext sc) {
        UpcomingCoopTaskBatch batch = new UpcomingCoopTaskBatch(); 
        database.executebatch(batch);
    }

}