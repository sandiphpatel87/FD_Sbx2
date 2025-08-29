@isTest
public class MonthlyBudgetsTask_Test {
    @isTest
    public static void test(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Coop__c = true;
        insert acc;
        user usr = [select id,UserRoleId, UserRole.Name from user where UserRole.Name ='Account Technician' limit 1];
        MonthlyBudgetsTask batch3 = new MonthlyBudgetsTask();
        database.executebatch(batch3);
    }
}