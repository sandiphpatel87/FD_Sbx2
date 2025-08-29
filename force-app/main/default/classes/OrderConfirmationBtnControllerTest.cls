@isTest
public class OrderConfirmationBtnControllerTest {
    @testSetup
    static void setupTestData() {
        // Create an Account
        Account acc = new Account(
            Name = 'Test Dealership',
            BillingStreet = '123 Main St',
            BillingCity = 'Los Angeles',
            BillingState = 'CA',
            BillingPostalCode = '90001'
        );
        insert acc;
        
        // Create a Contact
        Contact con = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'johndoe@example.com',
            Title__c = 'Manager',
            AccountId = acc.Id
        );
        insert con;
        
        //AccountContactRelation for Contract Signer
        AccountContactRelation acr = [Select Id from AccountContactRelation where ContactId = :con.id];
        acr.Roles = 'Contract Signer';
        update acr;

        // Create a Regional Manager
        User regionalManager = new User(
            Alias = 'rmgr',
            Email = 'regionalmanager@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Manager',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'regionalmanager@example.com'
        );
        insert regionalManager;

        // Create an Opportunity
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = acc.Id,
            StageName = 'Prospect',
            CloseDate = Date.today(),
            Target_Launch_Month__c = 'March'
        );
        insert opp;

        // Create a Product (Product2)
        Product2 prod = new Product2(
            Name = 'Test Product',
            Addendum_Language__c = 'Test Addendum',
            IsActive = true
        );
        insert prod;

        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
		update standardPricebook;		
        //Create a PricebookEntry
        Pricebook2 standardPriceBook1 = [SELECT Id FROM Pricebook2 WHERE Name = 'Standard Price Book' LIMIT 1];
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPriceBook1.Id,
            Product2Id = prod.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;

        // Create an OpportunityLineItem
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            PricebookEntryId = pbe.Id,
            Product2Id = prod.Id,
            Quantity = 1,
            UnitPrice = 100,
            MRR__c = 50
        );
        insert oli;
    }

    @isTest
    static void testSavePDF() {        
        Opportunity testOpp = [SELECT Id, AccountId FROM Opportunity LIMIT 1];
        
        Test.startTest();
        PageReference pageRef = Page.OrderConfirmationPDF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testOpp.Id);

        ApexPages.StandardController stdController = new ApexPages.StandardController(testOpp);
        OrderConfirmationBtnController controller = new OrderConfirmationBtnController(stdController);

        PageReference result = controller.savePDF();
        Test.stopTest();
    }
}