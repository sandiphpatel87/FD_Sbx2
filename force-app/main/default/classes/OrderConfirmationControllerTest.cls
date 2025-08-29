@isTest
public class OrderConfirmationControllerTest {
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
        
        AccountContactRelation acr = [Select Id from AccountContactRelation where ContactId = :con.id];
        acr.Roles = 'Contract Signer';
        update acr;

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
            MRR__c = 50,
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
            MRR__c = 50,
            Quantity = 1,
            UnitPrice = 100           
        );
        insert oli;
    }

    @isTest
    static void testOrderConfirmationController() {
        // Fetch the Opportunity
        Opportunity testOpp = [SELECT Id FROM Opportunity LIMIT 1];

        // Set the ApexPages parameters
        Test.startTest();
        Map<String, String> params = new Map<String, String>();
        params.put('id', testOpp.Id);
        params.put('renderAs', 'PDF');
        Test.setCurrentPageReference(new PageReference('/apex/OrderConfirmation'));
        ApexPages.currentPage().getParameters().putAll(params);

        // Instantiate the Controller
        OrderConfirmationController controller = new OrderConfirmationController();

        Test.stopTest();
    }
}