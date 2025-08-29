@isTest
public class CampaignRecordCreated_test {
@isTest
    public static void test(){
          Account acc  = new Account ();
        acc.Name = 'testacc';
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
        acc.Account_Technician__c = UserInfo.getUserId();
        acc.Regional_performance_manager__c = UserInfo.getUserId();
        insert acc;
        opportunity opp = new opportunity();
        opp.Name='testing' ;
        opp.AccountId= acc.Id;
        opp.StageName = 'Prospecting';
        opp.CloseDate = system.today().adddays(3);
        insert opp; 
        CampaignRecordCreated.createCampaign(opp.Id);
        
    }
}