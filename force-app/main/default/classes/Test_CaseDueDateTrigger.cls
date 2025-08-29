@IsTest
public class Test_CaseDueDateTrigger 
{
    @IsTest
    static void testCalculateCaseDueDate() 
    {
        // Create test User
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User']; // Replace 'Standard User' with the actual profile name
        User testUser = new User(
            Alias = 'testuser',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'uniquewuser@example.com'
        );
        insert testUser;
        
        Account acc = new Account();
        acc.name = 'Demo account';
        acc.Regional_performance_manager__c = testUser.Id;
        acc.Account_Technician__c = testUser.Id;
        acc.Secondary_Account_Technician__c = testUser.Id;
        Insert acc;
        
        List<Case> insertCs = new List<Case>();
        // Create test data
        Case testCase = new Case();
        testCase.AccountId = acc.Id;
        testCase.Priority = 'low';
        testCase.Request_Type__c = 'Bid Change';
        testCase.status = 'new';
        testCase.Origin = 'Google Meet';
        testCase.Subject = 'Test Case';
        testCase.SLA_Time__c = 9;
        insertCs.add(testCase);
        
        // Create test data
        Case testCase1 = new Case();
        testCase1.AccountId = acc.Id;
        testCase1.status = 'Future';
        testCase1.Request_Type__c = 'Future Budget Change';
        //testCase1.Start_Month__c = 'September';
        //testCase1.Future_Start_Year__c = '2032';
        testCase1.Future_Start_Date__c = ((System.today()).addMonths(3));
        testCase1.Origin = 'Google Meet';
        testCase1.Subject = 'Test Case';
        insertCs.add(testCase1);
        
        // Create test data
        Case testCase2 = new Case();
        testCase2.AccountId = acc.Id;
        testCase2.status = 'Future';
        testCase2.Request_Type__c = 'Future Campaign Build - Standard';
        testCase2.Origin = 'Google Meet';
        testCase2.Subject = 'Test Case';
        //testCase2.Future_Start_Year__c = '2032';
        //testCase2.Start_Month__c = 'September';
        testCase2.Future_Start_Date__c = ((System.today()).addMonths(2));
        insertCs.add(testCase2);
        Insert insertCs;
        
        Case updatedCase2 = new Case(Id = insertCs[1].Id);
        updatedCase2.status = 'new';
        updatedCase2.Request_Type__c = 'bid change'; 
        update updatedCase2;
        
        Case updatedCase = new Case(Id = insertCs[1].Id);
        updatedCase.status = 'Future';
        updatedCase.Request_Type__c = 'Future Campaign Build - Standard'; 
        //updatedCase.Future_Start_Year__c = '2032';
        //updatedCase.Start_Month__c = 'September';
        updatedCase.Future_Start_Date__c = ((System.today()).addMonths(1));
        Update updatedCase;
           
        Case updatedCase1 = new Case(Id = insertCs[1].Id);
        updatedCase1.status = 'Future';
        updatedCase1.Request_Type__c = 'Future Budget Change'; 
        //updatedCase1.Future_Start_Year__c = '2032';
        //updatedCase1.Start_Month__c = 'September';
        updatedCase.Future_Start_Date__c = ((System.today()).addMonths(4));
        update updatedCase1;
    }
    @IsTest
    static void testCalculateCaseDueDate1() 
    {
        // Create test User
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User']; // Replace 'Standard User' with the actual profile name
        User testUser = new User(
            Alias = 'testuser',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'uniquewuser@example.com'
        );
        insert testUser;
        
        Account acc = new Account();
        acc.name = 'Demo account';
        acc.Regional_performance_manager__c = testUser.Id;
        acc.Account_Technician__c = testUser.Id;
        acc.Secondary_Account_Technician__c = testUser.Id;
        Insert acc;
        
        List<Case> insertCs = new List<Case>();
        // Create test data
        Case testCase = new Case();
        testCase.AccountId = acc.Id;
        testCase.Priority = 'low';
        testCase.Request_Type__c = 'Performance Review';
        testCase.status = 'new';
        testCase.Origin = 'Google Meet';
        testCase.Subject = 'Test Case';
        testCase.SLA_Time__c = 9;
        testCase.Close_Date__c = System.today()-10;
        insertCs.add(testCase);
        
        // Create test data
        Case testCase1 = new Case();
        testCase1.AccountId = acc.Id;
        testCase1.status = 'New';
        testCase1.Request_Type__c = 'Performance Review';
        testCase1.Origin = 'Google Meet';
        testCase1.Subject = 'Test Case';
        testCase.Close_Date__c = System.today();
        insertCs.add(testCase1);
        //Insert insertCs;
        
       
        Case testCase2 = new Case();
        testCase2.AccountId = acc.Id;
        testCase2.status = 'New';
        testCase2.Request_Type__c = 'Performance Review';
        testCase2.Origin = 'Google Meet';
        testCase2.Subject = 'Test Case';
        testCase2.Close_Date__c = System.today();
        insertCs.add(testCase2);
        
        Case testCase3 = new Case();
        testCase3.AccountId = acc.Id;
        testCase3.status = 'New';
        testCase3.Request_Type__c = 'Geo Change';
        testCase3.Origin = 'Google Meet';
        testCase3.Subject = 'Test Case';
        testCase3.Close_Date__c = System.today();
        insertCs.add(testCase3);
        
        Insert insertCs;
        
        Case updatedCase1 = new Case(Id = insertCs[1].Id);
        updatedCase1.status = 'Closed';
        updatedCase1.Is_the_Dealer_meeting_sales_objectives__c = 'Yes';         
        update updatedCase1;
        
        Case updatedCase3 = new Case(Id = insertCs[3].Id);
        updatedCase3.status = 'Ready for QA';
        //updatedCase3.Is_the_Dealer_meeting_sales_objectives__c = 'Yes';         
        update updatedCase3;
        
        Case updatedCase2 = new Case(Id = insertCs[2].Id);
        updatedCase2.Close_Date__c = System.today() + 1;
        updatedCase2.status = 'Closed';        
        update updatedCase2;
        
    }

}