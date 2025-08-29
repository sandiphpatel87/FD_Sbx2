@isTest
public class AccountContactRelationTrigger_Test {

    @isTest
    public static void test(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Active__c = true;
        acc.Type = 'Dealer Group';
        test.startTest();
        insert acc;
        Contact con = new Contact();
        con.LastName = 'test1';
        con.Email ='test@gmail.com';
        con.AccountId = acc.id;
        insert con;
        
        Account accRecord2=new account();
        accRecord2.Name='Test Acc2';
        insert accRecord2;
        
         Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = acc.Id);
        insert testOpp;
        
        AccountContactRelation  accCon = new AccountContactRelation ();
        accCon.AccountId = accRecord2.id;
        accCon.ContactId = con.Id;
        accCon.Roles = 'Primary Contact';
       
        insert accCon;
        
        Contact con2 = new Contact();
        con2.LastName = 'test2';
        con2.Email ='test2@gmail.com';
        con2.AccountId = acc.id;
        insert con2;
        
        Account accRecord3=new account();
        accRecord3.Name='Test Acc3';
        insert accRecord3;
        
        AccountContactRelation  accCon2 = new AccountContactRelation ();
        accCon2.AccountId = accRecord3.id;
        accCon2.ContactId = con2.Id;
        accCon2.Roles = 'Secondary contact';
       
        insert accCon2;
       delete accCon;
        
         Account accRecord4=new account();
        accRecord4.Name='Test Acc4';
        insert accRecord4;
        Opportunity testOpp1 = new Opportunity(
            Name = 'Test Opp1',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = accRecord4.Id);
        insert testOpp1;
        
         AccountContactRelation  accCon3 = new AccountContactRelation ();
        accCon3.AccountId = accRecord4.id;
        accCon3.ContactId = con2.Id;
        accCon3.Roles = 'Primary Contact;Secondary contact';
       
        insert accCon3;
         accCon3.Roles = 'coop';
        update accCon3;
        delete accCon3;
        test.stopTest();
    }

    @isTest
    public static void testBilling(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Active__c = true;
        acc.Type = 'Dealer Group';
        test.startTest();
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
        accCon.Roles = 'Billing';
        insert accCon;
        accCon.Roles = '';
        update accCon;
        delete accCon;
        
        Contact con2 = new Contact();
        con2.LastName = 'test2';
        con2.Email ='test2@gmail.com';
        con2.AccountId = acc.id;
        insert con2;
        
        Account accRecord3=new account();
        accRecord3.Name='Test Acc3';
        insert accRecord3;
        
        AccountContactRelation  accCon2 = new AccountContactRelation ();
        accCon2.AccountId = accRecord3.id;
        accCon2.ContactId = con2.Id;
        accCon2.Roles = 'Contract Signer';
        insert accCon2;
        accCon2.Roles = '';
        update accCon2;
       delete accCon2;
        
         Account accRecord4=new account();
        accRecord4.Name='Test Acc4';
        insert accRecord4;
         AccountContactRelation  accCon3 = new AccountContactRelation ();
        accCon3.AccountId = accRecord4.id;
        accCon3.ContactId = con2.Id;
        accCon3.Roles = 'coop';
        insert accCon3;
         accCon3.Roles = 'Contract Signer;Billing';
        update accCon3;
        delete accCon3;
        test.stopTest();
    }
	/*@isTest
    public static void testBilling(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Active__c = true;
        acc.Type = 'Dealer Group';
        test.startTest();
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
        accCon.Roles = 'Billing';
       
        insert accCon;
        accCon.Roles = 'Contract Signer';
        update accCon;
        delete accCon;
        Contact con2 = new Contact();
        con2.LastName = 'test2';
        con2.Email ='test2@gmail.com';
        con2.AccountId = acc.id;
        insert con2;
        
        Contact con3 = new Contact();
        con3.LastName = 'test3';
        con3.Email ='test3@gmail.com';
        con3.AccountId = acc.id;
        insert con3;
        
        Account accRecord3=new account();
        accRecord3.Name='Test Acc3';
        insert accRecord3;
        
        AccountContactRelation  accCon2 = new AccountContactRelation ();
        accCon2.AccountId = accRecord3.id;
        accCon2.ContactId = con2.Id;
        accCon2.Roles = 'Contract Signer';
       
        insert accCon2;
        accCon2.Roles = 'Billing';
        update accCon2;
        delete accCon2;
        
         Account accRecord4=new account();
        accRecord4.Name='Test Acc3';
        insert accRecord4;
         AccountContactRelation  accCon3 = new AccountContactRelation ();
        accCon3.AccountId = accRecord4.id;
        accCon3.ContactId = con2.Id;
        accCon3.Roles = 'Contract Signer;Billing';
       
        insert accCon3;
        accCon3.Roles = 'Billing';
        update accCon3;
		delete accCon3;
        
         AccountContactRelation  accCon4 = new AccountContactRelation ();
        accCon4.AccountId = accRecord4.id;
        accCon4.ContactId = con3.Id;
        accCon4.Roles = 'Contract Signer;Billing';
        insert accCon4;
        accCon4.Roles='Contract Signer';
        update accCon4;
        delete accCon4;
        test.stopTest();
    }*/
}