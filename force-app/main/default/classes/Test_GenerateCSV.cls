@isTest
public class Test_GenerateCSV 
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
            StageName = 'Onboarding',
            CloseDate = Date.today(),
            AccountId = objAccount.Id
        );
        INSERT testOpp;
        
        Account accRecord2=new account();
        accRecord2.Name='Test Acc2';
        insert accRecord2;
        
        Contact objContact = new Contact();
        objContact.LastName = 'Test';
        objContact.AccountId = accRecord2.Id;
        INSERT objContact;
        
        // Create test data for Onboarding__c records
        List<Onboarding__c> testOnboardingList = new List<Onboarding__c>();
        // Add test data for Business Intelligence Onboarding
        testOnboardingList.add(new Onboarding__c(
            RecordTypeId = businessIntelligenceRecordTypeId,
            Opportunity__c = testOpp.Id,
            Account__c = objAccount.Id
        ));
        // Add test data for Digital Advertising Onboarding
        testOnboardingList.add(new Onboarding__c(
            RecordTypeId = digitalAdvertisingRecordTypeId,
            Opportunity__c = testOpp.Id,
            Account__c = accRecord2.Id
        ));
        
        insert testOnboardingList;
        
        // Create test data for Contact records
        List<Contact> testContactList = new List<Contact>();
        testContactList.add(new Contact(
            AccountId = testOnboardingList[0].Account__c,
            LastName = 'Test'
        ));
        testContactList.add(new Contact(
            AccountId = testOnboardingList[1].Account__c,
            LastName = 'Test'
        ));
        
        insert testContactList;
        
        AccountContactRelation  accCon = new AccountContactRelation ();
        accCon.AccountId = accRecord2.id;
        accCon.ContactId = testContactList[0].Id;
        accCon.Roles = 'Onboarding';
       
        insert accCon;
        
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
        
        testOpp.stageName = 'Onboarding';
        
        UPDATE testOpp;
        
        Test.startTest();
        String cronExp = '0 1 * ? * * *'; 
        System.schedule('MyScheduledJob', cronExp, new Schedule_Onboarding_Account_Contact());
        Test.stopTest();
    }
}