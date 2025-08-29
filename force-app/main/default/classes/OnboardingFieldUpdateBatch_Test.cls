@isTest
public class OnboardingFieldUpdateBatch_Test {
    @isTest
    public static void test(){
        Onboarding__c obj = new Onboarding__c();
        obj.Facebook_Request_Accepted__c = 'Not Started';
        obj.Regional_performance_manager__c = UserInfo.getUserId();
        obj.Facebook_Request_Sent__c = 'Needs Followup';
        obj.Facebook_Request_Accepted__c = 'Needs Followup';
        obj.GMB_Request_Sent__c = 'Needs Followup';
        obj.GMB_Request_Received__c = 'Needs Followup';
        obj.Turn_Sitelinks_Off_in_Apollo__c = 'Needs Followup';
        obj.Add_Sitelinks_to_Google_Ads__c = 'Needs Followup';
        obj.Budgets_Updated_in_Apollo__c = 'Needs Followup'; 
        obj.Send_Advertised_Payments_for_Approval__c = 'Needs Followup';
        obj.Verify_Inventory_Pricing__c = 'Needs Followup';
        // obj.Credit_Card_Received__c = 'Needs Followup';
        obj.Zipcodes_Received__c = 'Needs Followup';
        obj.Budgets_Confirmed__c = 'Needs Followup';
        obj.Send_Geo_targeting_for_Approval__c = 'Needs Followup';
        obj.Send_Advertised_Payments_for_Approval__c = 'Needs Followup';
        obj.Confirm_Launch_Date_with_Client__c = 'Needs Followup';
        obj.Add_CC_to_Google__c= 'Needs Followup';
        obj.Add_CC_to_Facebook__c = 'Needs Followup';
        obj.Add_CC_to_Bing__c = 'Needs Followup';
        insert obj;
        OnboardingFieldUpdateBatch batch = new OnboardingFieldUpdateBatch();
        database.executeBatch(batch);
    }
}