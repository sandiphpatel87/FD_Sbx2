@isTest

public class OpportunityVfFileController_Test {
    
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
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
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
        
        //SignatureComponentController sc = new SignatureComponentController();
        //sc.objParentId = testOpp.Id;
         //SignatureComponentController.saveSignature('Test', testOpp.Id);
        
        Test.startTest();
        
        OpportunityVfFileController opp = new OpportunityVfFileController();
        opp.objParentId = testOpp.Id;
        PageReference pageRef = Page.OpportunityVfFile;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('isPdf', 'true');
        ApexPages.currentPage().getParameters().put('recordId',testOpp.Id);
        
        opp.onLoadGetOppData();
        opp.updateRecord();
        OpportunityVfFileController.saveSignature('Test', testOpp.Id);
        Test.stopTest();
        
    }
}