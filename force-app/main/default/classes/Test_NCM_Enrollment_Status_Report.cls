@isTest
public class Test_NCM_Enrollment_Status_Report 
{
	@isTest
	public static void testNCMEnrollmentStatusReportController()
    {
        Test.startTest();
        
        // Create a test Account
        Account testAccount = new Account(Name = 'Test Account');
        INSERT testAccount;

        // Create an Opportunity record related to the test Account
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Onboarding',
            Type__c = 'NCM',
            CloseDate = Date.today(),
            Amount = 10000.00,
            AccountId = testAccount.Id,
            NCM_20_Group_Code__c = '12134',
            NCM_20_Group__c = 'Test'
        );
        INSERT testOpportunity;
        
        testOpportunity.StageName = 'Onboarding';
        
        UPDATE testOpportunity;
        
        NCM_Enrollment_Status_Report_Controller.getAccountRelatedOpportunityAndContact(testOpportunity.NCM_20_Group_Code__c, testOpportunity.NCM_20_Group__c);
        
        Test.stopTest();
    }
}