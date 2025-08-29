@isTest
public class OpportunityTrigger_Test 
{
    //Inventory
    @isTest static void testAfterEmailUpdate() {
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
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            Product_Status__c='New',
            Inventory_Contact_Email__c = 'test.contact@test.com'
        );
        insert testOpp;
        
        ContentVersion objContentVersion = new ContentVersion(); 
        objContentVersion.Title = 'Header_Picture1_Completed'; 
        objContentVersion.PathOnClient = '/' + objContentVersion.Title + '.pdf'; 
        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body'); 
        objContentVersion.VersionData = bodyBlob;
        objContentVersion.origin = 'H';
        INSERT objContentVersion;
        
        ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
        objContentDocumentLink.LinkedEntityId = testOpp.id;
        objContentDocumentLink.contentdocumentid = [SELECT contentdocumentid FROM contentversion WHERE id =: objContentVersion.id].contentdocumentid;
        objContentDocumentLink.ShareType = 'I';
        objContentDocumentLink.Visibility = 'AllUsers'; 
        INSERT objContentDocumentLink;
        
        Opportunity_Attachment_Email_Content__c obj = new Opportunity_Attachment_Email_Content__c();
        obj.Name = 'Test';
        obj.Email_Body__c = 'Test';
        obj.Email_Subject__c = 'Test';
        obj.To_Address__c = 'test@gmail.com';
        INSERT obj;
        
        AccountContactRelation acrObj = [SELECT ID,roles FROM AccountContactRelation Where contactId =:testContact.Id];
        system.debug('acrObj roles -'+acrObj.roles);
        acrObj.roles = 'Coop;Contract Signer';
        Update acrObj;
        
        Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr.Inventory_Contact_Email__c = 'abc1@gmail.com';
        oppr.Contract_Signer_Email__c = 'test@contract.com';
        oppr.Contract_Signer__c='Test ContractSigner';
        oppr.Contract_Signer_Title__c ='CEO';
        
        oppr.Contract_Signed_Date__c = Date.today();
        Update oppr;
        
        
    }
    
   
    
  
    @isTest static void testAfterEmailUpdate2() {
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
        
        Contact testContact1 = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1NCM@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact1;
		Contact testContact2 = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1GA@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact2;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            Product_Status__c='New',
            Onboarding_Contact_Email__c = 'test.contact@test.com',
            NCM_Composite_Email__c = 'test.contactNCM@test.com',
            GA_Contact_Email__c = 'test.contactGA@test.com'
        );
        insert testOpp;
        
        Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr.Onboarding_Contact_Email__c = 'abc1@gmail.com';
 		oppr.NCM_Composite_Email__c = 'abc1NCM@gmail.com';
		oppr.GA_Contact_Email__c = 'abc1GA@gmail.com';
        oppr.Type__c = 'Digital Advertising';
        oppr.StageName ='Lost';
        Update oppr;
    }
    
   
    
    
   
    
    
    //Inventory
    @isTest static void testAfterEmailUpdateIn() {
        //UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'NCM_Partner_User' Limit 1];
        
        User adminUser = [Select Id, UserRoleId,IsActive From User Where Profile.Name='System Administrator' AND IsActive= TRUE Limit 1];
        
        //adminUser.UserRoleId = userRole.Id;
        update adminUser;
        
        System.runAs(adminUser){
            // create test data
            Account testAccount = new Account(Name = 'Test Account (1234)',Type__c='NCM 20 Group');
            insert testAccount;
            Account testAccount1 = new Account(Name = 'Test Account',Sub_Parent__c = testAccount.Id ,
                                               NCM_Management_Group__c = testAccount.Id , 
                                               NCM_20_Group_2__c = testAccount.Id);
            insert testAccount1;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Email = 'abc1@gmail.com',
                AccountId = testAccount.Id
            );
            insert testContact;
            Contact testContact1 = new Contact(
                FirstName = 'Test',
                LastName = '123',
                Email = 'test123@gmail.com',
                AccountId = testAccount1.Id
            );
            insert testContact1;
            Contact testContact2 = new Contact(
                FirstName = 'Test',
                LastName = '123',
                Email = 'sforcedeveloper12345@gmail.com',
                AccountId = testAccount1.Id
            );
            insert testContact2;
            AccountContactRelation ac = [SELECT id FROM AccountContactRelation WHERE AccountId =: testAccount1.Id
                                         									   AND ContactID =: testContact2.Id];
            ac.Roles='Contract Signer';
                update ac;
            Opportunity testOpp = new Opportunity(
                Name = 'Test Opp',
                StageName = 'Prospect',
                CloseDate = Date.today(),
                AccountId = testAccount1.Id,
                Sys_DocuSign_Status__c='',
                Inventory_Contact_Email__c = 'abc12@gmail.com',
                NCM_20_Group_Code__c ='1234',
                Product_Status__c='New',
                Contract_Signer__c='Salesforce Developer12345',
                Contract_Signer_Email__c ='sforcedeveloper12345@gmail.com'
            );
            insert testOpp;
            Test.startTest();
            Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
            oppr.Inventory_Contact_Email__c = 'abc1@gmail.com';
            oppr.Inventory_Contact_Name__c='test abc';
            oppr.Billing_Contact_Email__c ='Test.billing@gmail.com';
            oppr.Billing_Contact_First_Name__c ='Test';
            oppr.Billing_Contact_Last_Name__c ='Billing';
            oppr.GA_Contact_Email__c = 'test123@gmail.com';
            oppr.GA_Contact_Name__c ='Test 123';
            oppr.Onboarding_Contact_Email__c='test12345@gmail.com';
            oppr.Onboarding_Contact_Name__c='Test 12345';
            oppr.Type__c ='NCM';
            oppr.StageName ='Contract Sent';
            Update oppr; 
            Test.stopTest() ;
            
           
            
                 
            OpportunityTriggerHelper.createCommunityUser('Salesforce Developer12345', 'sforcedeveloper@gmail.com', testAccount1.Id, testOpp.ID,adminUser.ID , testAccount1.Name,testAccount1.Name);
            
             OpportunityTriggerHelper.createCommunityUser('Salesforce Developer12345', 'sforcedeveloper12345@gmail.com', testAccount1.Id, testOpp.ID,adminUser.ID , testAccount1.Name,'Test Acc With UName');
            //OpportunityTriggerHelper.sendExceptionEmail(testOpp.Id, 'Error', testAccount1.Name,testContact2.Id);
            
        }
    }
    
   		
    
}