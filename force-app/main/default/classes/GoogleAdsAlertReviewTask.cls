public class GoogleAdsAlertReviewTask implements Database.Batchable<sObject>, Schedulable {
public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select id,UserRoleId, UserRole.Name from user where IsActive = true and UserRole.Name =\'Account Technician\'' );
    }
    public void execute(Database.BatchableContext bc, List<user> scope){
         list<Task> TaskList = new list<Task>();
        for(user obj :scope){
         Task tsk = new Task();
            tsk.Status = 'Open';
            tsk.Subject = 'Weekly Google Ads Alert Review';
            tsk.Priority = 'Normal';
            tsk.OwnerId = obj.Id;
            tsk.Notes__c = 'Trademark Issues \n 0 Impressions \n Zero Calls On Dealership Name \n New/Service IS < 45% \n Dealership Name IS <80% \n Conversion Tracking Issue \n Used Impression Share <40% \n Service Spend < $10 Last Week';
            tsk.ActivityDate = system.today().adddays(4);
            TaskList.add(tsk);
        }
        database.Insert(TaskList);
    }
    public void finish(Database.BatchableContext bc){}
    public void execute(SchedulableContext sc) {
        GoogleAdsAlertReviewTask batch = new GoogleAdsAlertReviewTask(); 
        database.executebatch(batch);
    }
    
}