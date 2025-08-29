@isTest(SeeAllData=true)
private class UpdateOpportunityStatusBatch_Test {
    
    
    @isTest static void test() {
       
        List<Opportunity> opp_list =[SELECT Id, StageName, Contract_Signed_Date__c, AccountId, Account.Sub_Parent__c, Account.NCM_Management_Group__c, Account.NCM_20_Group_2__c, NCM_20_Group_Code__c,Account.Sub_Parent__r.Count_NCM_20_Group__c,Account.NCM_Management_Group__r.Count_NCM_Management_Group__c,Account.NCM_20_Group_2__r.Count_NCM_20_Group_2__c,Account.Sub_Parent__r.Type__c,Account.NCM_Management_Group__r.Type__c,Account.NCM_20_Group_2__r.Type__c FROM Opportunity WHERE AccountId!= Null AND Type__c = 'NCM' AND Contract_Signed_Date__c != null AND StageName ='Enrollment Pending'];
        Test.startTest();
        UpdateOpportunityStatusBatch u = new UpdateOpportunityStatusBatch();
        u.execute(null,opp_list);
        Database.executeBatch(u);
        Test.stopTest();
        
    }
    @isTest static void test1() {
        Test.startTest();
        UpdateOpportunityStatusBatchSchedule abs= new UpdateOpportunityStatusBatchSchedule();
        String jobId = System.schedule('UpdateOpportunityStatusBatch Hourly', '0 0 * * * ?', abs);
        Test.stopTest();
        
    }
}
/*public TestMethod static void Class_Test_Method()

{
List<Account> acc_List = New List<Account>();

Account testAccount1 = new Account(Name = 'Test 20(1234)' , Type__c = 'NCM 20 Group');
acc_List.add(testAccount1);

Account testAccount2 = new Account(Name = 'Management Test(2345)', Type__c = 'NCM 20 Group');
acc_List.add(testAccount2);

Account testAccount3 = new Account(Name = '20 Group 2(3456)', Type__c = 'NCM 20 Group');
acc_List.add(testAccount3);


Test.startTest();

Database.DMLOptions dml = new Database.DMLOptions(); 
dml.DuplicateRuleHeader.AllowSave = true;

Database.SaveResult []AccStr = Database.insert(acc_List,dml);

Account testAccount = new Account(Name = 'Test Account', 
Sub_Parent__c = testAccount1.Id ,
NCM_Management_Group__c = testAccount2.Id , 
NCM_20_Group_2__c = testAccount3.Id);
Database.SaveResult sr = Database.insert(testAccount, dml);

List<Opportunity> opp_list = new List<Opportunity>();

if(sr.isSuccess()){

Opportunity testOpp = new Opportunity(
Name = 'Test Opp',
StageName = 'Enrolment Pending',
CloseDate = Date.today(),
AccountId = testAccount.Id,
Type__c = 'NCM',
Contract_Signed_Date__c = Date.today(),
NCM_20_Group_Code__c = '1234'
);
insert testOpp;
opp_list.add(testOpp);

Opportunity testOpp1 = new Opportunity(
Name = 'Test Opp1',
StageName = 'Enrolment Pending',
CloseDate = Date.today(),
AccountId = testAccount.Id,
Type__c = 'NCM',
Contract_Signed_Date__c = Date.today(),
NCM_20_Group_Code__c = '2345'
);
insert testOpp1;
opp_list.add(testOpp1);

Opportunity testOpp2 = new Opportunity(
Name = 'Test Opp2',
StageName = 'Enrolment Pending',
CloseDate = Date.today(),
AccountId = testAccount.Id,
Type__c = 'NCM',
Contract_Signed_Date__c = Date.today(),
NCM_20_Group_Code__c = '3456'
);
insert testOpp2;
opp_list.add(testOpp2);
}


UpdateOpportunityStatusBatch abcd = New UpdateOpportunityStatusBatch();
Database.QueryLocator ql = abcd.start(null);
abcd.execute(null,opp_list);
abcd.Finish(null);
Database.executeBatch(abcd);

Test.stopTest();

}*/