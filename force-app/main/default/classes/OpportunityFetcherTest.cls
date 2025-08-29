@isTest
public class OpportunityFetcherTest {
    @testSetup
    static void setupTestData() {
        // Create Test Accounts
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2')
        };
        insert accounts;

        // Create Test Opportunities related to the above accounts
        List<Opportunity> opportunities = new List<Opportunity>{
            new Opportunity(Name = 'Opportunity 1', StageName = 'New', Amount = 10000, CloseDate = Date.today().addDays(30), AccountId = accounts[0].Id),
            new Opportunity(Name = 'Opportunity 2', StageName = 'New', Amount = 20000, CloseDate = Date.today().addDays(45), AccountId = accounts[1].Id),
            new Opportunity(Name = 'Opportunity 3', StageName = 'New', Amount = 15000, CloseDate = Date.today().addDays(60), AccountId = accounts[0].Id)
        };
        insert opportunities;
    }

    @isTest
    static void testGetOpportunitiesForAccounts() {
        // Retrieve test accounts
        List<Account> testAccounts = [SELECT Id FROM Account];

        // Extract Account Ids
        List<Id> accountIds = new List<Id>();
        for (Account acc : testAccounts) {
            accountIds.add(acc.Id);
        }

        // Call the Apex method
        Test.startTest();
        List<Opportunity> resultOpportunities = OpportunityFetcher.getOpportunitiesForAccounts(accountIds);
        Test.stopTest();
    }

    @isTest
    static void testGetOpportunitiesForAccountsWithNoAccounts() {
        // Call the method with an empty list
        Test.startTest();
        List<Opportunity> resultOpportunities = OpportunityFetcher.getOpportunitiesForAccounts(new List<Id>());
        Test.stopTest();
       
    }
}