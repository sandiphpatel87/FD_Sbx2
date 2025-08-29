@isTest
public class EmailToCaseServiceTest {

    @isTest
    static void testHandleInboundEmail_Success() {
        // Create test data for custom setting
        Email_Service_Case_Assignment__c userConfig = new Email_Service_Case_Assignment__c(
            Name = 'TVM Tagging Case',
            OwnerId__c = UserInfo.getUserId(), // Use current user as Owner
            AssignedToId__c = UserInfo.getUserId() // Use current user as Assigned To
        );
        insert userConfig;

        // Create a test email
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Case Subject';
        email.plainTextBody = 'TVM TPID: 12345\n' +
                              'FD TPID: 23456\n' +
                              'Dealer Name: DC Kia\n' +
                              'Analytics Franchise: KIA\n' +
                              'Apollo Website URL: test.url.com\n' +
                              'Apollo Website Staging URL: test.url.com\n' +
                              'Address Street: 512 Bristol Way\n' +
                              'Address City: Alpharetta\n' +
                              'Address State: GA\n' +
                              'Address Zip: 30022';

        // Create a test envelope
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();

        // Instantiate the EmailToCaseService class
        EmailToCaseService emailService = new EmailToCaseService();

        // Call the handleInboundEmail method
        Test.startTest();
        Messaging.InboundEmailResult result = emailService.handleInboundEmail(email, envelope);
        Test.stopTest();

        // Query the created Case record
        Case createdCase = [SELECT Id, Subject, TVM_TPID__c, FD_TPID__c, Dealer_Name__c, 
                                   Analytics_Franchise__c, Apollo_Website_URL__c, 
                                   Apollo_Website_Staging_URL__c, Address_Street__c, 
                                   Address_City__c, Address_State__c, Address_Zip__c, 
                                   Request_Type__c, Priority, Status, OwnerId, Case_Assign_To__c 
                            FROM Case 
                            LIMIT 1];
    }

    @isTest
    static void testHandleInboundEmail_Error() {
        // Create a test email with missing required fields
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Case Subject';
        email.plainTextBody = 'TVM TPID: 12345\n'; // Incomplete email body

        // Create a test envelope
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();

        // Instantiate the EmailToCaseService class
        EmailToCaseService emailService = new EmailToCaseService();

        // Call the handleInboundEmail method
        Test.startTest();
        Messaging.InboundEmailResult result = emailService.handleInboundEmail(email, envelope);
        Test.stopTest();
    }

    @isTest
    static void testParseEmailBody() {
        // Instantiate the EmailToCaseService class
        EmailToCaseService emailService = new EmailToCaseService();

        // Test email body
        String emailBody = 'TVM TPID: 12345\n' +
                           'FD TPID: 23456\n' +
                           'Dealer Name: DC Kia\n' +
                           'Analytics Franchise: KIA\n' +
                           'Apollo Website URL: test.url.com\n' +
                           'Apollo Website Staging URL: test.url.com\n' +
                           'Address Street: 512 Bristol Way\n' +
                           'Address City: Alpharetta\n' +
                           'Address State: GA\n' +
                           'Address Zip: 30022';

        // Call the parseEmailBody method
        Test.startTest();
        Map<String, String> fieldMap = emailService.parseEmailBody(emailBody);
        Test.stopTest();
    }
}