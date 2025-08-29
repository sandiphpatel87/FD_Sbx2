@isTest
public class FetchMissingMediaBudgetAccount_Test {
@isTest
    public static void test(){
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Active__c = true;
        acc.Type = 'Dealer Group';
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
       // acc.Exclude_for_Media_Budget_Email__c = false;
        insert acc;
        Contact con = new Contact();
        con.LastName = 'test1';
        con.Email ='test@gmail.com';
       con.AccountId = acc.id;
        insert con;
         Account accRecord2=new account();
        accRecord2.Name='Test Acc2';
         accRecord2.BillingCity ='indore';
        accRecord2.BillingStreet = 'test';
        accRecord2.BillingCountry = 'india';
        accRecord2.BillingState = 'mp';
        accRecord2.BillingPostalCode ='480221';
        accRecord2.ShippingCity = 'indore';
        accRecord2.ShippingCountry = 'india';
        accRecord2.ShippingState = 'mp';
        accRecord2.ShippingStreet = 'test';
        accRecord2.ShippingPostalCode = '480221';
        insert accRecord2;
        AccountContactRelation  accCon = new AccountContactRelation ();
        accCon.AccountId = accRecord2.id;
        accCon.ContactId = con.Id;
        accCon.Roles = 'All';
       
        insert accCon;
        FetchMissingMediaBudgetAccount.fetchAccount();
           
    }
}