@isTest
public class MediaBudgetLoadedBatch_Test {
    @isTest
    public static void test(){
        DateTime dT = System.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        
        user ur = [select id from user where UserRole.Name = 'Account Technician' and IsActive = true limit 1];
        Media_Budgets_Loaded1__c media = new Media_Budgets_Loaded1__c();
        media.Budget_Email_Task__c = myDate;
        media.Task_for_AT__c = myDate;
        media.Name = 'test';
        media.Event_Reminder__c = System.now();
        insert media;
        MediaBudgetLoadedBatch b = new MediaBudgetLoadedBatch(); //ur batch class
        database.executebatch(b);
    }
}