@isTest

public class AttachmentTriggerHelper_Test {
    
    @isTest Static Void createAttachOppFiles()
    {
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
            Email = 'test.contact@test.com',
            AccountId = testAccount.Id
        );
        insert testContact1;
        Profile p = [SELECT Id FROM Profile WHERE Name='Foundation Partner Community']; 
        User u = new User(Alias = 'standt', Email='test.contact@test.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, ContactID=testContact1.ID,
            TimeZoneSidKey='America/Los_Angeles', UserName='test.contact123@test.com');
        Insert u;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Live',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            Contract_Signer_Email__c = 'test.contact@test.com'
        );
        insert testOpp;
      
        Opportunity_Attachment_Email_Content__c setting = new Opportunity_Attachment_Email_Content__c();
        setting.Name ='Opportunity Signed Contract';
        setting.Email_Body__c = 'Please view attached document.';
        setting.Email_Subject__c = 'Opportunity Signed Contract';
        insert setting;
        
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.ParentId = testOpp.Id;
        attachment.Name = 'Signature Capture.png';
        attachment.Body = b;
        
        insert attachment;
    }
    
    @isTest Static Void createAttachCoopFiles(){
        coop__c obj = new coop__c();
        obj.Bing_Final_URL_Report__c = true;
        obj.Date__c = Date.today();
        obj.Month__c='Feb';
        obj.Year__c ='2024';
        insert obj;

		 Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.ParentId = obj.Id;
        attachment.Name = 'Test';
        attachment.Body = b;
        
        insert attachment;        
    }
}