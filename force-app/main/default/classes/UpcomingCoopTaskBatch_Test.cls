@isTest
public class UpcomingCoopTaskBatch_Test {
@isTest
    public static void test(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Coop__c = true;
        acc.Active__c = true;
        insert acc;
        user usr = [select id,UserRoleId, UserRole.Name from user where UserRole.Name ='Account Technician' limit 1];
        /*RecurringTasksForATBatch batch1 = new RecurringTasksForATBatch(); 
        database.executebatch(batch1);
        UpcomingCoopTaskBatch batch = new UpcomingCoopTaskBatch(); 
        database.executebatch(batch);
        ThreeTaskaMonth batch2 = new ThreeTaskaMonth();
        database.executebatch(batch2);
        MonthlyBudgetsTask batch3 = new MonthlyBudgetsTask();
        database.executebatch(batch3);*/
        GoogleAdsAlertReviewTask batch4 = new GoogleAdsAlertReviewTask();
         database.executebatch(batch4);
    }
}