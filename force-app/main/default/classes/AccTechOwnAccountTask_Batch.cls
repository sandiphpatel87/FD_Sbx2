public class AccTechOwnAccountTask_Batch implements Database.Batchable<sObject>, Schedulable {
public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select id,Account_Technician__c,Name from Account where Account_Technician__c != null and Account_Technician__r.IsActive = true and Active__c = true' );
    }
    public void execute(Database.BatchableContext bc, List<Account> scope){
        list<Task> TaskList = new list<Task>();
        for(Account obj :scope){
            Task tsk = new Task();
            tsk.Status = 'Open';
            tsk.Subject = 'Weekly QA -'+ obj.Name;
            tsk.Priority = 'Normal';
            tsk.WhatId = obj.Id;
            tsk.OwnerId = obj.Account_Technician__c;
            tsk.ActivityDate = system.today().adddays(4);
            tsk.Notes__c = 'https://docs.google.com/document/d/1XofcmHRRlDkDyFhdtBuoi2kPfovOFw-189eYP88SI-U/edit';
            TaskList.add(tsk);
        }
        database.Insert(TaskList);
    }
    public void finish(Database.BatchableContext bc){}
    public void execute(SchedulableContext sc) {
        AccTechOwnAccountTask_Batch batch = new AccTechOwnAccountTask_Batch(); 
        database.executebatch(batch);
    }
}