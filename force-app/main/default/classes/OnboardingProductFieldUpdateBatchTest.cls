@isTest
public class OnboardingProductFieldUpdateBatchTest {
    
    static testMethod void testMethod1() 
    {
        Id pricebookId = Test.getStandardPricebookId();
        
        opportunity opp = new opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Onboarding';
        opp.CloseDate = Date.parse('12/15/15');
        insert opp;
        
        Onboarding__c onbor = new Onboarding__c();
        onbor.Opportunity__c = opp.id;
        insert onbor;
        
        
        //Create your product
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 5,
            PricebookEntryId = pbEntry.Id,
            TotalPrice = 1000
        );
        insert oli;
        
        Test.startTest();
        
        OnboardingProductFieldUpdateBatch obj = new OnboardingProductFieldUpdateBatch();
        database.executeBatch(obj); 
        
        Test.stopTest();
    }
    
}