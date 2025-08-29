@isTest
public class AccTechOwnAccountTask_Batch_test {
    @isTest
    public static void test(){
         user usr = [select id,UserRoleId, UserRole.Name,IsActive from user where UserRole.Name ='Account Technician' and IsActive =: true limit 1];
       
        Account acc = new Account();
        acc.Name = 'test';
        acc.Coop__c = true;
        acc.Account_Technician__c = usr.Id;
        acc.Active__c = true;
        insert acc;
        AccTechOwnAccountTask_Batch batch3 = new AccTechOwnAccountTask_Batch();
        database.executebatch(batch3);
    }
}