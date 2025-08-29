@isTest
public class getPrimaryContact_Test {

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
}