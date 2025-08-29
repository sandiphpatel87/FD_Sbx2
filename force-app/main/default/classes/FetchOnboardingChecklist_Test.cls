@isTest
public class FetchOnboardingChecklist_Test {
@isTest
    public static void test(){
        Onboarding__c obj = new Onboarding__c();
        obj.Add_CC_to_Bing__c = 'Completed';
        insert obj;
        FetchOnboardingChecklist.fetchOnboarding('4', '2022', null);
        FetchOnboardingChecklist.getMonthFieldValue();
        RecentlyLaunchedAccountController.fetchOnboarding('4', '2022', null);
        RecentlyLaunchedAccountController.getMonthFieldValue();
    }
}