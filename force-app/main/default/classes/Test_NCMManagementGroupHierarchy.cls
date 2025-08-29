@isTest
public class Test_NCMManagementGroupHierarchy {
	@isTest static void getAccounts_Method(){
        Account accountObj = new Account();
        accountObj.Name = 'AccName';
        insert accountObj;
        
        
        Account accountObj2 = new Account();
        accountObj2.Name = 'AccName2';
        accountObj2.NCM_Management_Group__c = accountObj.Id;
        insert accountObj2;
        
        Test.startTest();
        NCMManagementGroupHierarchyController.findHierarchyData(accountObj2.id);
        NCMManagementGroupHierarchyController.GetUltimateParentId(accountObj2.id);
        Test.stopTest();
    }
}