@isTest(seeAllData =false)
public class create_OppProduct_History_Test {
	
    @isTest static void OppProduct_History_TestMethod(){
            Date closeDt = Date.Today();
            date myDate = date.today();
            test.startTest();
            Account a2 = new Account(Name ='testing acc');
            insert a2;
            
            Pricebook2 pb22 = new Pricebook2(Name='testOppPBs', isActive=true);
            insert pb22;
            
            Product2 pro2 = new Product2(Name='FEEFUELS', isActive=true);
            insert pro2;
            
            PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),isActive=true,UseStandardPrice = false);
            insert pbe2;
            
            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = pb22.Id, Product2Id = pro2.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice;
            
            opportunity oppr = new opportunity(Name='testing ppp' ,  AccountId= a2.Id,StageName = 'Live',CloseDate = closeDt);
            insert oppr;
        	
        	OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=oppr.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        	insert OPplineitem2;
        	
        	delete OPplineitem2;
            test.stopTest();
        }
}