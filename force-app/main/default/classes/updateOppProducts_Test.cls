@isTest
public class updateOppProducts_Test {

    // This is how we get the Standard PriceBook Id.  Prior to Summer '14, we needed
    // to use SeeAllData=true, so this is a big improvement
    @isTest public static void test_UpdateOppProductTrigger(){
    Id pricebookId = Test.getStandardPricebookId();
    
    //Create your product
    Product2 prod = new Product2(Name = 'Product Test',ProductCode = 'Pro-001',MRR__c = 200,Set_up_Fee__c = 100,isActive = true);
    test.startTest();
    insert prod;
    
    //Create your pricebook entry
    PricebookEntry pbEntry = new PricebookEntry(
        Pricebook2Id = pricebookId,
        Product2Id = prod.Id,
        UnitPrice = 100.00,
        IsActive = true
    );
    
    insert pbEntry;
    
    Date closeDt = Date.Today();

    Account a2 = new Account(Name ='icrm testing acc');
    insert a2;
    opportunity opp = new opportunity(Name='testing DIE 4/6/2015' ,  AccountId= a2.Id,StageName = 'Prospecting', 
                                   CloseDate = closeDt);
	insert opp;    
        
    //create your opportunity line item.  This assumes you already have an opportunity created, called opp
    OpportunityLineItem oli = new OpportunityLineItem(
        OpportunityId = opp.Id,
        Quantity = 5,
        PricebookEntryId = pbEntry.Id,
        UnitPrice = 25
    );
    insert oli;
        test.stopTest();
    }
}