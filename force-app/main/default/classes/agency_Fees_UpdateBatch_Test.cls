@isTest(seeAllData =false)
public class agency_Fees_UpdateBatch_Test {

    @isTest static void agency_Fees_UpdateBatch_TestMethod(){
            Date closeDt = Date.Today();
            date myDate = date.today();
        
        	DateTime dt = Datetime.now();
            String Month = dt.format('MMM');
            String Year = String.valueOf(dt.format('YYYY'));
        
            test.startTest();
            Account a2 = new Account(Name ='testing acc');
            insert a2;
            
            Media_Budget__c mb= new Media_Budget__c();
            List<Media_Budget__c> mbList = new List<Media_Budget__c>();
            mb.Account__c = a2.id;
            mb.Budget_Month__c = Month;
            mb.Budget_Year__c = Year;
            mb.Used_Search__c = 3000;
            insert mb;
            mbList.add(mb);
        
            Pricebook2 pb22 = new Pricebook2(Name='testOppPBs', isActive=true);
            insert pb22;
            
            Product2 pro2 = new Product2(Name=System.Label.AgencyFee_ProductName, isActive=true,Percentage__c =5);
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
        	
        	//agency_Fees_UpdateBatch b = new agency_Fees_UpdateBatch(); //ur batch class
        	//database.executebatch(b);
            
            agency_Fees_UpdateBatch m = new agency_Fees_UpdateBatch();
            String sch = '20 30 8 10 2 ?';
            String jobID = system.schedule('Merge Job', sch, m);
        	test.stopTest();
        }
}