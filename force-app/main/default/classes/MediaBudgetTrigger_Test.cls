@isTest
public class MediaBudgetTrigger_Test {
    @isTest
    public static void test(){
        Media_Budget__c mb= new Media_Budget__c();
        mb.New_Search__c = 12;
        mb.Service_Search__c = 23;
        mb.Facebook_Service__c = 0;
        mb.FB__c = 23;
        insert mb;
        mb.New_Search__c = 0;
        mb.Display__c = 12;
        mb.Service_Search__c = 0;
        mb.Facebook_Service__c = 2;
        mb.Used_Search__c = 5;
        mb.Used_Video__c = 90;
        mb.Used_Display__c =8;
        update mb;
        mb.New_Search__c = 5;
        mb.Display__c = 0;
        mb.Service_Search__c = 9;
        mb.Facebook_Service__c = 0;
        mb.Used_Search__c = 0;
        mb.Used_Video__c = 0;
        update mb;
    }
}