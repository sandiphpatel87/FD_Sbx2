@isTest
public class BudgetsOfAmount_Test {
@isTest
    public static void test(){
        Media_Budget__c obj = new Media_Budget__c();
        obj.New_Search__c = 10;
        insert obj;
        BudgetsOfAmount budCls = new BudgetsOfAmount();
        budCls.mediaId = obj.Id;
        Media_Budget__c obj1 = new Media_Budget__c();
        obj1 = budCls.MediaObj;
    }
}