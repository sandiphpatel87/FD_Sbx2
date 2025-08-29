@isTest

public class OpportunityListForCommunityCmpCtrl_Test {
    
    @isTest Static Void getOppList()
    {
        //UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'NCM_Partner_User' Limit 1];
        
        User adminUser = [Select Id, UserRoleId,IsActive From User Where Profile.Name='System Administrator' AND IsActive= TRUE Limit 1];
        
        //adminUser.UserRoleId = userRole.Id;
        update adminUser;
        
        System.runAs(adminUser){
            
            // create test data
            Account testAccount = new Account(Name = 'Test Account');
            insert testAccount;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Email = 'abc1@gmail.com',
                AccountId = testAccount.Id
            );
            insert testContact;
            
            AccountContactRelation ac = [SELECT id FROM AccountContactRelation WHERE AccountId =: testAccount.Id 
                                         									   AND ContactID =: testContact.Id];
            ac.Roles='Contract Signer';
                update ac;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Foundation Partner Community']; 
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, ContactId = testContact.Id,
                              TimeZoneSidKey='America/Los_Angeles', UserName='Foundation_Partner_Community@testorg.com');
            insert u;
            
            Opportunity testOpp = new Opportunity(
                Name = 'Test Opp',
                StageName = 'Contract Sent',
                CloseDate = Date.today(),
                AccountId = testAccount.Id,
                Type__c = 'NCM',
                Contract_Signer_Email__c = 'test.contact@test.com'
            );
            insert testOpp;
            
            Test.startTest();
            
            OpportunityListForCommunityCmpController.getOpportunities(u.ID);
            
            Test.stopTest();
        }
        
    }
    
    @isTest Static Void getOppListNotFound()
    {
        //UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'NCM_Partner_User' Limit 1];
        
        User adminUser = [Select Id, UserRoleId,IsActive From User Where Profile.Name='System Administrator' AND IsActive= TRUE Limit 1];
        
        //adminUser.UserRoleId = userRole.Id;
        update adminUser;
        
        System.runAs(adminUser){
            
            // create test data
            Account testAccount = new Account(Name = 'Test Account');
            insert testAccount;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Email = 'abc1@gmail.com',
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
                Contract_Signer_Email__c = 'test.contact@test.com'
            );
            insert testOpp;
            
            Test.startTest();
            
            OpportunityListForCommunityCmpController.getOpportunities(u.ID);
            
            Test.stopTest();
        }
        
    }
	
    
}