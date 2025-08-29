@isTest

public class NCMObjectReportListController_Test {
    
    @isTest Static Void testMethod1()
    {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount; 
        
        Account testAccount1 = new Account(Name = 'Test Account1', Sub_Parent__c=testAccount.Id);
        insert testAccount1; 
        
        Onboarding__c obj = new Onboarding__c();
        obj.Facebook_Request_Accepted__c = 'Not Started';
        obj.Regional_performance_manager__c = UserInfo.getUserId();
        obj.Account__c =testAccount1.Id;
        insert obj;
        
        
        Test.startTest();
        NCMObjectReportListController.getOnboardingRecords(testAccount.ID);
        NCMObjectReportListController.getOnboardingRecords(testAccount1.ID);
		NCMObjectReportListController.getOpportunityRecords(testAccount1.ID);        
        Test.stopTest();
    }
    
}