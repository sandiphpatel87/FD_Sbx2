@istest
public class MondayTaskForAt_test {
 @isTest
    public static void test(){
         user usr = [select id,UserRoleId, UserRole.Name,IsActive from user where UserRole.Name ='Account Technician' and IsActive =: true limit 1];
       
        Account acc = new Account();
        acc.Name = 'test';
        acc.Coop__c = true;
        acc.Account_Technician__c = usr.Id;
        acc.Active__c = true;
       acc.BillingCity ='indore';
        acc.BillingStreet = 'test';
        acc.BillingCountry = 'india';
        acc.BillingState = 'mp';
        acc.BillingPostalCode ='480221';
        acc.ShippingCity = 'indore';
        acc.ShippingCountry = 'india';
        acc.ShippingState = 'mp';
        acc.ShippingStreet = 'test';
        acc.ShippingPostalCode = '480221';
        insert acc;
         ThirdModayTaskforAT batch = new ThirdModayTaskforAT(); 
        database.executebatch(batch);
        SecondMondayTaskForAT batch1 = new SecondMondayTaskForAT(); 
        database.executebatch(batch1);
        
    }
}