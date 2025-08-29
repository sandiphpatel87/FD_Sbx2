@istest
public class ContactTrigger_Test {
    @istest
    public static void test(){
         String customLabelValue = Label.InActive_Contact;
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
        con.Active__c = true;
        insert con;
       Account acc1 = new Account();
         acc1.Name='Inactive Contacts';
        insert acc1;
        Account accRecord2=new account();
        accRecord2.Name='Test Acc2';
        insert accRecord2;
        
        AccountContactRelation  accCon = new AccountContactRelation ();
        accCon.AccountId = accRecord2.id;
        accCon.ContactId = con.Id;
       accCon.Roles = 'Primary Contact';
        insert accCon;
        
        con.Active__c = false;
        update con;
        
    }
     @istest
    public static void test1(){
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
        con.Active__c = true;
        insert con;
        Account acc1 = new Account();
         acc1.Name='Inactive Contacts';
        insert acc1;
        
        Account accRecord2=new account();
        accRecord2.Name='Test Acc2';
        insert accRecord2;
        
        AccountContactRelation  accCon = new AccountContactRelation ();
        accCon.AccountId = acc.id;
        accCon.ContactId = con.Id;
        accCon.Roles = 'Primary Contact';
      //  accCon.IsDirect = true;
       // insert accCon;
        
        con.Active__c = false;
        update con;
        
    }
}