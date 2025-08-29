@isTest
public class OnboardingTrigger_Test {
    @isTest
    public static void test(){
        Onboarding__c obj = new Onboarding__c();
        obj.Facebook_Request_Accepted__c = 'Not Started';
        obj.Regional_performance_manager__c = UserInfo.getUserId();
        insert obj;
        
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
        
        //Added by Sandip
        obj.Goals_Inactive_at_Dashboard_Call__c ='test';
        obj.Click_to_Call__c = 'Event tracked via tagged triggers';
        obj.Chat_Provider__c ='Gubagoo';
        
        update obj;
    }
    @isTest
    public static void test1(){
        
        Onboarding__c obj = new Onboarding__c();
        obj.Facebook_Request_Accepted__c = 'Not Started';
        obj.Account_Technician__c = UserInfo.getUserId();
        insert obj;
        
        obj.Facebook_Request_Sent__c = 'Needs AT Follow Up';
        obj.Facebook_Request_Accepted__c = 'Needs AT Follow Up';
        obj.GMB_Request_Sent__c = 'Needs AT Follow Up';
        obj.GMB_Request_Received__c = 'Needs AT Follow Up';
        obj.Turn_Sitelinks_Off_in_Apollo__c = 'Needs AT Follow Up';
        obj.Add_Sitelinks_to_Google_Ads__c = 'Needs AT Follow Up';
        obj.Budgets_Updated_in_Apollo__c = 'Needs AT Follow Up'; 
        obj.Send_Advertised_Payments_for_Approval__c = 'Needs AT Follow Up';
        obj.Verify_Inventory_Pricing__c = 'Needs AT Follow Up';
        // obj.Credit_Card_Received__c = 'Needs AT Follow Up';
        obj.Zipcodes_Received__c = 'Needs AT Follow Up';
        obj.Budgets_Confirmed__c = 'Needs AT Follow Up';
        obj.Send_Geo_targeting_for_Approval__c = 'Needs AT Follow Up';
        obj.Send_Advertised_Payments_for_Approval__c = 'Needs AT Follow Up';
        obj.Confirm_Launch_Date_with_Client__c = 'Needs AT Follow Up';
        obj.Add_CC_to_Google__c= 'Needs AT Follow Up';
        
        //Added by Sandip
        obj.Goals_Inactive_at_Dashboard_Call__c ='test';
        obj.Click_to_Call__c = 'Event tracked via tagged triggers';
        
        obj.Schedule_Kickoff_Call__c = 'Needs Followup' ;
        obj.OnboardingPackSent__c = 'Needs Followup';
        obj.Onboarding_Pack_Received__c = 'Needs Followup';
        obj.Create_Google_Account__c = 'Needs Followup';
        obj.Create_Bing_Account__c = 'Needs Followup';
        obj.Create_Facebook_Account__c ='Needs Followup';
        obj.Add_CC_to_Bing__c = 'Needs Followup';
        obj.Add_CC_to_Facebook__c = 'Needs Followup';
        obj.Add_CC_to_Google__c = 'Needs Followup';
        obj.Logo_Received__c = 'Needs Followup';
        obj.Logo_added_to_Compliance_Board__c = 'Needs Followup';
        obj.Logo_approved_by_Compliance_Team__c = 'Needs Followup';
        obj.Link_GMB_for_Location_Extenstions__c = 'Needs Followup';
        obj.Add_to_Measurement_Trix__c = 'Needs Followup';
        update obj;
    }
    @isTest
    public static void test2(){
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
        task tsk = new task();
        tsk.status = 'open';
        tsk.Subject ='Confirm Launch Date and Details';
        tsk.WhatId = acc.id;
        insert tsk;
        
        Onboarding__c obj = new Onboarding__c();
        obj.Facebook_Request_Accepted__c = 'Not Started';
        obj.Account_Technician__c = UserInfo.getUserId();
        
        obj.Account__c = acc.Id;
        obj.Hyundai_Coop__c = true;
        insert obj;
        
        obj.Confirm_Launch_Date_with_Client__c ='Completed';
        
        //Added by Sandip
        obj.Schedule_Kickoff_Call__c = 'Needs AT Follow Up' ;
        obj.OnboardingPackSent__c = 'Needs AT Follow Up';
        obj.Onboarding_Pack_Received__c = 'Needs AT Follow Up';
        obj.Create_Google_Account__c = 'Needs AT Follow Up';
        obj.Create_Bing_Account__c = 'Needs AT Follow Up';
        obj.Create_Facebook_Account__c ='Needs AT Follow Up';
        obj.Add_CC_to_Bing__c = 'Needs AT Follow Up';
        obj.Add_CC_to_Facebook__c = 'Needs AT Follow Up';
        obj.Add_CC_to_Google__c = 'Needs AT Follow Up';
        obj.Logo_Received__c = 'Needs AT Follow Up';
        obj.Logo_added_to_Compliance_Board__c = 'Needs AT Follow Up';
        obj.Logo_approved_by_Compliance_Team__c = 'Needs AT Follow Up';
        obj.Link_GMB_for_Location_Extenstions__c = 'Needs AT Follow Up';
        obj.Add_to_Measurement_Trix__c = 'Needs AT Follow Up';
        update obj;
    }
    
}