public class MonthlyTaskForATAcc_Batch implements Database.Batchable<sObject>, Schedulable {
public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select id,Rollback_Payments__c,Account_Technician__c from Account where Active__c = true and Rollback_Payments__c =true and Account_Technician__c != null and Account_Technician__r.IsActive = true' );
    }
    public void execute(Database.BatchableContext bc, List<Account> scope){
        list<Task> TaskList = new list<Task>();
        for(Account obj :scope){
            Task tsk = new Task();
            tsk.Status = 'Open';
            tsk.Subject = 'Rollbacks';
            tsk.Priority = 'Normal';
            tsk.OwnerId = obj.Account_Technician__c;
            tsk.Notes__c = 'https://foundationdirect.lightning.force.com/lightning/r/Report/00O4W000008I9mQUAS/view?queryScope=userFolders';
            tsk.ActivityDate = system.today().adddays(4);
            tsk.WhatId = obj.id;
            TaskList.add(tsk);
        }
        database.Insert(TaskList);
    }
    public void finish(Database.BatchableContext bc){}
    public void execute(SchedulableContext sc) {
        MonthlyTaskForATAcc_Batch batch = new MonthlyTaskForATAcc_Batch(); 
        database.executebatch(batch);
    }
}