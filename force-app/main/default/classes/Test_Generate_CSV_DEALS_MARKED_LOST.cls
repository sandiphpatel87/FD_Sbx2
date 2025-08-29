@isTest
public class Test_Generate_CSV_DEALS_MARKED_LOST 
{
    @isTest
    public static void testGenerateCSVForOnboarding() 
    {
        
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        INSERT objAccount;
        
        //Getting record type id for Business Intelligence using developer name.
        Id businessIntelligenceRecordTypeId = Schema.SObjectType.Onboarding__c.getRecordTypeInfosByDeveloperName().get('Business_Intelligence').getRecordTypeId();
        
        //Getting record type id for Digital Advertising using developer name.
        Id digitalAdvertisingRecordTypeId = Schema.SObjectType.Onboarding__c.getRecordTypeInfosByDeveloperName().get('Digital_Advertising').getRecordTypeId();
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Lost',
            CloseDate = Date.today(),
            AccountId = objAccount.Id
        );
        INSERT testOpp;
        
        Onboarding__c obj = new Onboarding__c();
        obj.Facebook_Request_Accepted__c = 'Not Started';
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
        obj.Opportunity__c = testOpp.Id;
                
        INSERT obj;
        
        Onboarding__c obj1 = new Onboarding__c();
        obj1.Facebook_Request_Accepted__c = 'Not Started';
        obj1.Facebook_Request_Sent__c = 'Needs Followup';
        obj1.Facebook_Request_Accepted__c = 'Needs Followup';
        obj1.GMB_Request_Sent__c = 'Needs Followup';
        obj1.GMB_Request_Received__c = 'Needs Followup';
        obj1.Turn_Sitelinks_Off_in_Apollo__c = 'Needs Followup';
        obj1.Add_Sitelinks_to_Google_Ads__c = 'Needs Followup';
        obj1.Budgets_Updated_in_Apollo__c = 'Needs Followup'; 
        obj1.Send_Advertised_Payments_for_Approval__c = 'Needs Followup';
        obj1.Verify_Inventory_Pricing__c = 'Needs Followup';
      //  obj1.Credit_Card_Received__c = 'Needs Followup';
        obj1.Zipcodes_Received__c = 'Needs Followup';
        obj1.Budgets_Confirmed__c = 'Needs Followup';
        obj1.Send_Geo_targeting_for_Approval__c = 'Needs Followup';
        obj1.Send_Advertised_Payments_for_Approval__c = 'Needs Followup';
        obj1.Confirm_Launch_Date_with_Client__c = 'Needs Followup';
        obj1.Add_CC_to_Google__c= 'Needs Followup';
        obj1.Opportunity__c = testOpp.Id;
         obj1.Account__c = objAccount.Id;       
        INSERT obj1;
        
        testOpp.stageName = 'Lost';
        
        UPDATE testOpp;
        
        Test.startTest();
        String cronExp = '0 1 * ? * * *'; 
        System.schedule('MyScheduledJob', cronExp, new Schedule_Generate_CSV_DEALS_MARKED_LOST());
        Test.stopTest();
    }
}