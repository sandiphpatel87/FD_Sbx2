public class SecondMondayTaskForAT implements Database.Batchable<sObject>, Schedulable {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select id,Rollback_Payments__c,Account_Technician__c from Account where Active__c = true and Account_Technician__c != null and Account_Technician__r.IsActive = true' );
    }
    public void execute(Database.BatchableContext bc, List<Account> scope){
        list<Task> TaskList = new list<Task>();
        for(Account obj :scope){
            Task tsk = new Task();
            tsk.Status = 'Open';
            tsk.Subject = 'Google Optimization Score Review';
            tsk.Priority = 'Normal';
            tsk.OwnerId = obj.Account_Technician__c;
            tsk.ActivityDate = system.today().adddays(4);
            tsk.WhatId = obj.id;
            TaskList.add(tsk);
        }
        database.Insert(TaskList);
    }
    public void finish(Database.BatchableContext bc){}
    public void execute(SchedulableContext sc) {
        SecondMondayTaskForAT batch = new SecondMondayTaskForAT(); 
        database.executebatch(batch);
    }
}