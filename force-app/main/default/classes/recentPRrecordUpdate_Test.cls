@isTest
public class recentPRrecordUpdate_Test {

    @isTest
    public static void testrecentPRrecordUpdate(){
        Account acc = new Account();
        acc.Name = 'test PR Create';
        acc.Active__c = true;
        acc.Type = 'Dealer Group';
        insert acc;
        
        //List<Performance_Reviews__c> insrtPR = new List<Performance_Reviews__c>();
        
        Performance_Reviews__c prs = new Performance_Reviews__c();
        prs.Account__c = acc.id;
        prs.Date__c = system.today();
        prs.Month__c = 'Aug';
        prs.Year__c ='2021';
        //insrtPR.add(prs);
        insert prs;
        
        Performance_Reviews__c prs2 = new Performance_Reviews__c();
        prs2.Account__c = acc.id;
        prs2.Date__c = system.today();
        prs2.Month__c = 'Sep';
        //insrtPR.add(prs2);
        insert prs2;
        //insert insrtPR;
    }
    
}