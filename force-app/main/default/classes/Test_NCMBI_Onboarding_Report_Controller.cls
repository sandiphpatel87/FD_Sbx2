@isTest
public class Test_NCMBI_Onboarding_Report_Controller 
{
    @isTest
	public static void testNCMBIOnboardingReportController()
    {
        Test.startTest();
        
        NCMBI_Onboarding_Report_Controller.fetchOnboarding('Test', '2021', '2023-11-05', '12134', 'Test');
        NCMBI_Onboarding_Report_Controller.fetchOnboarding(null, null, null, '12134', 'Test');
        NCMBI_Onboarding_Report_Controller.getMonthFieldValue();
        
        Test.stopTest();
    }
}