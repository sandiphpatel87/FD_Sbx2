@isTest
public class OnboardingQACheckList_Test {
    @isTest
    public static void test(){
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        Onboarding__c obj = new Onboarding__c();
        obj.Facebook_Request_Accepted__c = 'Not Started';
        obj.Regional_performance_manager__c = UserInfo.getUserId();
        obj.Account__c = acc.Id;
       
        insert obj;
        task tsk = new task();
        tsk.Subject = '14 Day launch QA';
        tsk.WhatId = acc.Id;
        
        insert tsk;
        
        task tsk1 = new task();
        tsk1.Subject = 'Performance Max';
        tsk1.WhatId = acc.Id;
        
        insert tsk1;
        OnboardingQACheckList.getCheckbox(obj.Id);
        OnboardingQACheckList.saveOnboarding(obj,true,'14 day launch QA');
         OnboardingQACheckList.saveOnboarding(obj,true,'7 day launch QA');
         OnboardingQACheckList.saveOnboarding(obj,true,'Launch Day QA');
        OnboardingQACheckList.saveOnboarding(obj,true,'Performance Max');
    }
}