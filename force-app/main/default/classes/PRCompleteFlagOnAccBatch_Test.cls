@isTest(seeAllData =false)
public class PRCompleteFlagOnAccBatch_Test {
    
    @isTest static void PRCompleteFlagOnAccBatch_TestMethod(){
        Date closeDt = Date.Today();
        date myDate = date.today();
        
        DateTime dt = Datetime.now();
        String Month = dt.format('MMM');
        String Year = String.valueOf(dt.format('YYYY'));
        
        DateTime lstDt = dt.addMonths(-1);
        String LastMnth = lstDt.format('MMM');
        String LastYear = String.valueOf(lstDt.format('YYYY'));
        
        test.startTest();
        Account a2 = new Account(Name ='testing acc');
        insert a2;
        
        List<Case> caseList = new List<Case>();
        
        Case c1= new Case();
        c1.AccountId = a2.id;
        c1.Request_Type__c = 'Performance Review';
        c1.Close_Date__c = Date.Today();
        caseList.add(c1);
        
        Case c2= new Case();
        c2.AccountId = a2.id;
        c2.Close_Date__c = Date.Today().addMonths(-1);
        c2.Request_Type__c = 'Performance Review';
        caseList.add(c2);
        
        
        Case c3= new Case();
        c3.AccountId = a2.id;
        c3.Close_Date__c = Date.Today();
        c3.Request_Type__c = 'Geo Change';
        caseList.add(c3);
        
        
        insert caseList;
        
        
        PRCompleteFlagOnAccBatch m = new PRCompleteFlagOnAccBatch();
        String sch = '20 30 8 10 2 ?';
        String jobID = system.schedule('Merge Job', sch, m);
        test.stopTest();
    }
}