@isTest
public class DeactiveUserForCommunityBatch_Test {
 @isTest Static Void createOpp()
    {
        UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'COO' Limit 1];
        
        User adminUser = [Select Id, UserRoleId,IsActive From User Where Profile.Name='System Administrator' AND IsActive= TRUE Limit 1];
        
        adminUser.UserRoleId = userRole.Id;
        update adminUser;
        
        System.runAs(adminUser){
            
            // create test data
            Account testAccount = new Account(Name = 'Test Account');
            insert testAccount;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Email = 'standarduser@testorg.com',
                AccountId = testAccount.Id
            );
            insert testContact;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Foundation Partner Community']; 
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, ContactId = testContact.Id,
                              TimeZoneSidKey='America/Los_Angeles', UserName='Foundation_Partner_Community@testorg.com');
            insert u;
            
            Opportunity testOpp = new Opportunity(
                Name = 'Test Opp',
                StageName = 'Closed Won',
                CloseDate = Date.today(),
                AccountId = testAccount.Id,
                Type__c = 'NCM',
                Contract_Signer_Email__c = 'standarduser@testorg.com',
                Need_To_Send_welcome_Email__c= TRUE,
                Contract_Sent_Date__c = Date.Today().addDays(-2)
            );
            insert testOpp;
            
          
            
            Test.startTest();
            
            DeactiveUserForCommunityBatchSchedule abs= new DeactiveUserForCommunityBatchSchedule();
        String jobId = System.schedule('DeactiveUserForCommunityBatchSchedule Hourly', '0 0 * * * ?', abs);
            
            Database.executeBatch(new DeactiveUserForCommunityBatch());
            
            Test.stopTest();
        }
        
    }
}