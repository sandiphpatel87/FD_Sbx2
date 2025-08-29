@isTest(seeAllData =false)
public class mediaBudgetFlagOnAccBatch_Test {

    @isTest static void mediaBudgetFlagOnAccBatch_TestMethod(){
            Date closeDt = Date.Today();
            date myDate = date.today();
        
        	DateTime dt = Datetime.now();
            String Month = dt.format('MMM');
            String Year = String.valueOf(dt.format('YYYY'));
        	
             DateTime lstDt = dt.addMonths(-1);
            String LastMnth = lstDt.format('MMM');
            String LastYear = String.valueOf(lstDt.format('YYYY'));
        
        	DateTime dt2 = dt.addMonths(1);
        	String Monthnxt = dt2.format('MMM');
            String Yearnxt = String.valueOf(dt2.format('YYYY'));
        
            test.startTest();
            Account a2 = new Account(Name ='testing acc',Active__c=true,Type__c='Digital Advertising',Total_MRR__c=5000);
            insert a2;
            
            Media_Budget__c mb= new Media_Budget__c();
            List<Media_Budget__c> mbList = new List<Media_Budget__c>();
            mb.Account__c = a2.id;
            mb.Budget_Month__c = Month;
            mb.Budget_Year__c = Year;
            mb.Used_Search__c = 3000;
        	mb.New_Search__c  = 0;
            insert mb;
            mbList.add(mb);
        
            Media_Budget__c mb2= new Media_Budget__c();
            mb2.Account__c = a2.id;
            mb2.Budget_Month__c = Monthnxt;
            mb2.Budget_Year__c = Yearnxt;
            mb2.Used_Search__c = 3000;
        	mb2.New_Search__c  =1000;
            insert mb2;
            
           	Media_Budget__c mb3= new Media_Budget__c();
            mb3.Account__c = a2.id;
            mb3.Budget_Month__c = LastMnth;
            mb3.Budget_Year__c = LastYear;
            mb3.Used_Search__c = 3000;
            insert mb3;
        	
        	
            mediaBudgetFlagOnAccBatch m = new mediaBudgetFlagOnAccBatch();
            String sch = '20 30 8 10 2 ?';
            String jobID = system.schedule('Merge Job', sch, m);
        	test.stopTest();
        }
}