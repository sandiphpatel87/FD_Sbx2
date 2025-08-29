@isTest
public class CampaignsTabDaysController_Test {
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
        Campaign__c obj = new Campaign__c();
        obj.Name ='test';
        obj.opportunity__c = opp.Id;
        obj.Account__c= acc.Id;
        insert obj;
        Campaign_List_Item__c objList = new Campaign_List_Item__c();
        objList.Name__c = 'test1';
        objList.Type__c ='Upsell';
        objList.Campaigns__c = obj.Id;
        objList.Date_4__c = system.today().adddays(2);
        objList.Date_3__c = DateTime.now().adddays(-1);
        objList.SLA__c = 4;
        objList.Send_Mail__c = false;
        insert objList;
       // list <Campaign_List_Item__c> camList = new list<Campaign_List_Item__c>();
       // camList.add(objList);
        list <Campaign_List_Item__c> camList = CampaignsTabDaysController.getCheckbox(obj.Id);
        CampaignsTabDaysController.saveCampaign(camList,'Upsell');
        CampaignSendMailSLA_Batch batch = new CampaignSendMailSLA_Batch();
        database.executeBatch(batch);
    }
}