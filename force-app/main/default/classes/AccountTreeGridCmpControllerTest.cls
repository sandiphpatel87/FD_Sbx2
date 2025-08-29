@isTest
public class AccountTreeGridCmpControllerTest {

    @isTest static void getAccounts_Method(){
        Account accountObj = new Account();
        accountObj.Name = 'AccName';
        insert accountObj;
        Test.startTest();
        AccountTreeGridCmpController.findHierarchyData(accountObj.id);
        AccountTreeGridCmpController.GetUltimateParentId(accountObj.id);
        Test.stopTest();
    }
    
}