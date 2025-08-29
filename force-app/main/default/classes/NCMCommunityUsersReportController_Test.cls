@isTest
public class NCMCommunityUsersReportController_Test {
@isTest
    public static void test(){
        
        Account account = new Account();
        account.Name = 'Test';
        insert account;
        
        Account account1 = new Account();
        account1.Name = 'test corp';
        account1.Sub_Parent__c=account.Id;
        insert account1;
        
        Contact c = new Contact();
        c.AccountId = account1.ID;
        c.FirstName = 'test';
        c.LastName = 'test';
        insert c;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Foundation Partner Community']; 
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, ContactId=c.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');

        NCMCommunityUsersReportController.fetchUsers('');
		NCMCommunityUsersReportController.fetchUsers('Test');
    }
}