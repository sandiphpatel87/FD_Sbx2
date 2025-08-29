@isTest
private class LoadOppConRoleTest {
    static testmethod void test() {
      Account acc = new Account();
        acc.Name = 'test';
        acc.Active__c = true;
        acc.Type = 'Dealer Group';
        
        insert acc;
        Contact con = new Contact();
        con.LastName = 'test1';
        con.Email ='test@gmail.com';
        con.AccountId = acc.id;
        insert con;
        
        Account accRecord2=new account();
        accRecord2.Name='Test Acc2';
        insert accRecord2;
        
        AccountContactRelation  accCon = new AccountContactRelation ();
        accCon.AccountId = accRecord2.id;
        accCon.ContactId = con.Id;
        accCon.Roles = 'Primary Contact';
       
        insert accCon;
        
    LIST<Opportunity> accList = new List<Opportunity>();
    for (Integer i=0;i<2;i++) {
        Opportunity ac = new Opportunity(Name = 'Opportunity ' + i,AccountId = accRecord2.id,StageName='Lost',CloseDate=system.today());
        accList.add(ac);
    }
    insert accList;
 
        Test.startTest();
            LoadOppConRole b = new LoadOppConRole();
        Database.executeBatch(b);
        Test.stopTest();
       
    }
}