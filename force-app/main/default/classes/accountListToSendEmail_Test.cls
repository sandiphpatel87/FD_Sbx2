@isTest
public class accountListToSendEmail_Test {
    @isTest
    public static void test(){
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
        accCon.Roles = 'All';
       
        insert accCon;
        String accId = acc.Id;
        accountListToSendEmail.fetchAccount();
       // accountListToSendEmail.listofEmailTemplates('SAMPLE: New Account Manager',accId,'Media Decision Maker');
        accountListToSendEmail.listofEmailTemplates('SAMPLE: New Account Manager',accId,'All Contacts');
        accountListToSendEmail.getContactRelation(accId,'All Contacts');
        accountListToSendEmail.getContactRelation(accId,'All');
       
    }
}