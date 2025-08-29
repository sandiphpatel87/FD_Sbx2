@isTest
public class budgetsOfAccount_Test {

    @isTest public static void testMediabudgets(){
        test.startTest();
        DateTime dt = Datetime.now();
        String Month = dt.format('MMM');
        String Year = String.valueOf(dt.format('YYYY'));
        
        Account a2 = new Account(Name ='icrm testing mediaAcc');
    	insert a2;
        Media_Budget__c mb= new Media_Budget__c();
        List<Media_Budget__c> mbList = new List<Media_Budget__c>();
        mb.Account__c = a2.id;
        mb.Budget_Month__c = Month;
        mb.Budget_Year__c = Year;
        mb.Used_Search__c = 3000;
        insert mb;
        mbList.add(mb);
        budgetsOfAccount act = new budgetsOfAccount();
        act.accountId = a2.id;
        Account acts = act.account;
        mbList = act.Opps;
        mbList = act.newOpps;
        String str = act.NewLine;
        test.stopTest();
    }
}