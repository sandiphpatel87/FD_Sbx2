@isTest
public class Test_TestClass 
{
    //Inventory
    @isTest static void testAfterEmailUpdate() {
        // create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            Inventory_Contact_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        
        AccountContactRelation acrObj = [SELECT ID,roles FROM AccountContactRelation Where contactId =:testContact.Id];
        system.debug('acrObj roles -'+acrObj.roles);
        acrObj.roles = 'Coop';
        Update acrObj;
        
        Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr.Inventory_Contact_Email__c = 'abc1@gmail.com';
        Update oppr;
        TestClass.main();
        
    }
    
    @isTest static void testAfterEmailUpdate11() {
        // create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            Inventory_Contact_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        
        
        Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr.Inventory_Contact_Email__c = 'abc1@gmail.com';
        Update oppr;
        
        TestClass.main();
    }
    
    @isTest static void testAfterEmailUpdate1() 
    {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            Inventory_Contact_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        AccountContactRelation acrObj1 = [SELECT ID,roles FROM AccountContactRelation Where contactId =:testContact.Id];
        system.debug('acrObj roles -'+acrObj1.roles);
        acrObj1.roles = 'Primary Contact;Secondary contact';
        Update acrObj1;
        
        Opportunity oppr1 = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr1.Inventory_Contact_Email__c = 'abc1@gmail.com';
        Update oppr1;
        TestClass.main();
    }
    
    //Onboarding
    @isTest static void testAfterEmailUpdate2() {
        // create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            Onboarding_Contact_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        
        Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr.Onboarding_Contact_Email__c = 'abc1@gmail.com';
        Update oppr;
        TestClass.main();
    }
    
    @isTest static void testAfterEmailUpdate33() {
        // create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            Onboarding_Contact_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        
        AccountContactRelation acrObj = [SELECT ID,roles FROM AccountContactRelation Where contactId =:testContact.Id];
        system.debug('acrObj roles -'+acrObj.roles);
        acrObj.roles = 'Coop';
        Update acrObj;
        
        Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr.Onboarding_Contact_Email__c = 'abc1@gmail.com';
        Update oppr;
        TestClass.main();
        
    }
    
    @isTest static void testAfterEmailUpdate3() 
    {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            Onboarding_Contact_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        AccountContactRelation acrObj1 = [SELECT ID,roles FROM AccountContactRelation Where contactId =:testContact.Id];
        system.debug('acrObj roles -'+acrObj1.roles);
        acrObj1.roles = 'Primary Contact;Secondary contact';
        Update acrObj1;
        
        Opportunity oppr1 = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr1.Onboarding_Contact_Email__c = 'abc1@gmail.com';
        Update oppr1;
        
        TestClass.main();
    }
    
    
    //GA
    @isTest static void testAfterEmailUpdate4() {
        // create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            GA_Contact_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        
        Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr.GA_Contact_Email__c = 'abc1@gmail.com';
        Update oppr;
        
        TestClass.main();
    }
    
    @isTest static void testAfterEmailUpdate44() {
        // create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            GA_Contact_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        
        AccountContactRelation acrObj = [SELECT ID,roles FROM AccountContactRelation Where contactId =:testContact.Id];
        system.debug('acrObj roles -'+acrObj.roles);
        acrObj.roles = 'Coop';
        Update acrObj;
        
        Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr.GA_Contact_Email__c = 'abc1@gmail.com';
        Update oppr;
        
        TestClass.main();
    }
    
    @isTest static void testAfterEmailUpdate5() 
    {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            GA_Contact_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        AccountContactRelation acrObj1 = [SELECT ID,roles FROM AccountContactRelation Where contactId =:testContact.Id];
        system.debug('acrObj roles -'+acrObj1.roles);
        acrObj1.roles = 'Primary Contact;Secondary contact';
        Update acrObj1;
        
        Opportunity oppr1 = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr1.GA_Contact_Email__c = 'abc1@gmail.com';
        Update oppr1;
        TestClass.main();
    }
    
    
    
    @isTest static void testAfterEmailUpdate6() {
        // create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            NCM_Composite_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        
        Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr.NCM_Composite_Email__c = 'abc1@gmail.com';
        Update oppr;
        TestClass.main();
    }
    
    
    
    
    @isTest static void testAfterEmailUpdate66() {
        // create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            NCM_Composite_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        
        AccountContactRelation acrObj = [SELECT ID,roles FROM AccountContactRelation Where contactId =:testContact.Id];
        system.debug('acrObj roles -'+acrObj.roles);
        acrObj.roles = 'Coop';
        Update acrObj;
        
        Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr.NCM_Composite_Email__c = 'abc1@gmail.com';
        Update oppr;
        
        TestClass.main();
    }
    
    @isTest static void testAfterEmailUpdate7() 
    {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            NCM_Composite_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        AccountContactRelation acrObj1 = [SELECT ID,roles FROM AccountContactRelation Where contactId =:testContact.Id];
        system.debug('acrObj roles -'+acrObj1.roles);
        acrObj1.roles = 'Primary Contact;Secondary contact';
        Update acrObj1;
        
        Opportunity oppr1 = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr1.NCM_Composite_Email__c = 'abc1@gmail.com';
        Update oppr1;
        TestClass.main();
    }
    
    //Inventory
    @isTest static void testAfterEmailUpdateIn() {
        // create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            Inventory_Contact_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        
        Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr.Inventory_Contact_Email__c = 'abc11@gmail.com';
        Update oppr;
        TestClass.main();
    }
    
    //Onboarding
    @isTest static void testAfterEmailUpdateOn() {
        // create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            Onboarding_Contact_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        
        Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr.Onboarding_Contact_Email__c = 'abc11@gmail.com';
        Update oppr;
        TestClass.main();
    }
    
    //NCM
    @isTest static void testAfterEmailUpdateNCM() {
        // create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            NCM_Composite_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        
        Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr.NCM_Composite_Email__c = 'abc11@gmail.com';
        Update oppr;
        TestClass.main();
    }
    
    //GA
    @isTest static void testAfterEmailUpdateGA() {
        // create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc1@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            GA_Contact_Email__c = 'test.contact@test.com',
            Type__c = 'NCM'
        );
        insert testOpp;
        
        Opportunity oppr = [SELECT ID FROM Opportunity Where Name = 'Test Opp']; 
        oppr.GA_Contact_Email__c = 'abc11@gmail.com';
        Update oppr;
        TestClass.main();
    }
    
}