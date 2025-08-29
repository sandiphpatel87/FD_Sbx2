@isTest
public class Test_Getting_Response_CSV_Record_Sheet3 
{
	@isTest
    public static void EmailAttachmentTester()
    {
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        INSERT objAccount;
        
        //Getting record type id for Business Intelligence using developer name.
        Id businessIntelligenceRecordTypeId = Schema.SObjectType.Onboarding__c.getRecordTypeInfosByDeveloperName().get('Business_Intelligence').getRecordTypeId();
        
        //Getting record type id for Digital Advertising using developer name.
        Id digitalAdvertisingRecordTypeId = Schema.SObjectType.Onboarding__c.getRecordTypeInfosByDeveloperName().get('Digital_Advertising').getRecordTypeId();
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Onboarding',
            CloseDate = Date.today(),
            AccountId = objAccount.Id
        );
        INSERT testOpp;
        
        Account accRecord2=new account();
        accRecord2.Name='Test Acc2';
        insert accRecord2;
        
        Contact objContact1 = new Contact();
        objContact1.LastName = 'Test';
        objContact1.AccountId = accRecord2.Id;
        INSERT objContact1;
        
        // Create test data for Onboarding__c records
        List<Onboarding__c> testOnboardingList = new List<Onboarding__c>();
        // Add test data for Business Intelligence Onboarding
        testOnboardingList.add(new Onboarding__c(
            RecordTypeId = businessIntelligenceRecordTypeId,
            Opportunity__c = testOpp.Id,
            Account__c = objAccount.Id,
            Mutual_Client_with_VistaDash__c = true,
            Foundation_GA4_View__c = 'Test',
            GTM_Container_Updated_for_GA4__c = Date.today(),
            Vistadash_Conversions_Configuration_GA4__c = Date.today(),
            Custom_Definitions_Configurati__c  = Date.today(),
            BigQuery_is_linked_in_GA4__c = true,
            Vistadash_Event_Owner_Custom_Dimension_C__c = true,
            GA4_Notes__c = 'Test',
            Digital_Retail_Provider__c = 'Roadster',
            GA4_Measurement_ID__c = 'Test',
            GA4_Property_Name_from_this_sheet__c = 'Test',
            GA_Account_Shared__c = 'analytics@foundationdirect.com',
            GTM_ID_provided__c = 'Test',
            Google_Facebook_Pixel_script_added_to_GT__c = 'Facebook Pixel',
            GTM_on_Site__c = Date.today(),
            Website_Provider__c = 'ARI',
            Chat_Provider__c = 'Gubagoo',
            Chat_Start__c= 'Event tracked via tagged triggers',
            Click_to_Call__c = 'Event tracked via tagged triggers',
            DR_Start__c = 'Event tracked via tagged triggers',
            Finance_Start__c = 'Event tracked via tagged triggers',
            Lead_Form__c = 'Event tracked via tagged triggers'
        ));
        // Add test data for Digital Advertising Onboarding
        testOnboardingList.add(new Onboarding__c(
            RecordTypeId = digitalAdvertisingRecordTypeId,
            Opportunity__c = testOpp.Id,
            Account__c = accRecord2.Id,
            Foundation_GA4_View__c = 'Test',
            GTM_Container_Updated_for_GA4__c = Date.today(),
            Vistadash_Conversions_Configuration_GA4__c = Date.today(),
            Custom_Definitions_Configurati__c  = Date.today(),
            BigQuery_is_linked_in_GA4__c = false,
            Vistadash_Event_Owner_Custom_Dimension_C__c = false,
            GA4_Notes__c = 'Test',
            Digital_Retail_Provider__c = 'Roadster',
            GA4_Measurement_ID__c = 'Test'
        ));
        
        insert testOnboardingList;
        
        // Create test data for Contact records
        List<Contact> testContactList = new List<Contact>();
        testContactList.add(new Contact(
            AccountId = testOnboardingList[0].Account__c,
            LastName = 'Test'
        ));
        testContactList.add(new Contact(
            AccountId = testOnboardingList[1].Account__c,
            LastName = 'Test'
        ));
        
        insert testContactList;
        
        AccountContactRelation  accCon = new AccountContactRelation ();
        accCon.AccountId = accRecord2.id;
        accCon.ContactId = testContactList[0].Id;
        accCon.Roles = 'Onboarding';
        
        insert accCon;
        
        Onboarding__c obj = new Onboarding__c();
        obj.RecordTypeId = businessIntelligenceRecordTypeId;
        obj.Mutual_Client_with_VistaDash__c = true;
        obj.Opportunity__c = testOpp.Id;
        
        testOpp.stageName = 'Lost';
        
        UPDATE testOpp;
        
         List<Onboarding__c> listOnboardings = [SELECT Id, Name, Mutual_Client_with_VistaDash__c, Touchpoint_Master_ID__c, RecordTypeId, Account__c, Account__r.Name, Account__r.Parent.Name, Opportunity__r.Day_after_last_day_of_service__c, Website_Provider__c,
                                               Website_URL__c, GA_Account_Shared__c, GTM_ID_provided__c, Google_Facebook_Pixel_script_added_to_GT__c, GTM_on_Site__c, GA4_Property_Name_from_this_sheet__c,
                                               GA4_Measurement_ID__c, Foundation_GA4_View__c, GTM_Container_Updated_for_GA4__c, Vistadash_Conversions_Configuration_GA4__c,
                                               Custom_Definitions_Configurati__c, Vistadash_Event_Owner_Custom_Dimension_C__c, GA4_Notes__c, Digital_Retail_Provider__c,
                                               Chat_Provider__c, Chat_Start__c, Click_to_Call__c, DR_Start__c, Finance_Start__c, Lead_Form__c,
                                               BigQuery_is_linked_in_GA4__c, Vistadash_Cancellation_Confirmed__c
                                               FROM Onboarding__c
                                               WHERE (RecordTypeId =: businessIntelligenceRecordTypeId
                                                      OR RecordTypeId =: digitalAdvertisingRecordTypeId)
                                               AND Opportunity__r.StageName = 'Lost'
                                              ];
        
        If(!listOnboardings.isEmpty())
        {
            String finalstr = 'Vistadash Cancellation Confirmed, Mutual Client with Vistadash, Touchpoint Master ID, Record Type (Business Intelligence or Digital Advertising), Account Name, Parent Account, Day After Last Day of Service, Website Provider, Website URL, GTM ID, GTM on Site, GA4 Property Name, GA4 Measurement ID, GA4 Property ID, Id, Name \n';
            
            For(Onboarding__c objOnboarding : listOnboardings)
            {
                //If Account field is not black.
                If(objOnboarding.Account__c != null)
                {
                    finalstr = finalstr + objOnboarding.Vistadash_Cancellation_Confirmed__c + ',' + objOnboarding.Mutual_Client_with_VistaDash__c + ',' + objOnboarding.Touchpoint_Master_ID__c + ',';
                    
                    If(objOnboarding.recordTypeId == businessIntelligenceRecordTypeId)
                    {
                        finalstr = finalstr + 'Business Intelligence,';
                    }
                    If(objOnboarding.recordTypeId == digitalAdvertisingRecordTypeId)
                    {
                        finalstr = finalstr + 'Digital Advertising,';
                    }
                    
                    finalstr = finalstr + objOnboarding.Account__r.Name + ',' + objOnboarding.Account__r.Parent.Name + ',' + objOnboarding.Opportunity__r.Day_after_last_day_of_service__c + ',' + objOnboarding.Website_Provider__c + ',';
                    finalstr = finalstr + objOnboarding.Website_URL__c + ',' + objOnboarding.GTM_ID_provided__c + ',';
                    finalstr = finalstr + objOnboarding.GTM_on_Site__c + ',' + objOnboarding.GA4_Property_Name_from_this_sheet__c + ',';
                    finalstr = finalstr + objOnboarding.GA4_Measurement_ID__c + ',' + objOnboarding.Foundation_GA4_View__c + ',' + objOnboarding.Id + ',' + objOnboarding.Name + ' \n';
                }
                Else
                {
                    finalstr = finalstr + objOnboarding.Vistadash_Cancellation_Confirmed__c + ',' + objOnboarding.Mutual_Client_with_VistaDash__c + ',' + objOnboarding.Touchpoint_Master_ID__c + ',';
                    
                    If(objOnboarding.recordTypeId == businessIntelligenceRecordTypeId)
                    {
                        finalstr = finalstr + 'Business Intelligence,';
                    }
                    If(objOnboarding.recordTypeId == digitalAdvertisingRecordTypeId)
                    {
                        finalstr = finalstr + 'Digital Advertising,';
                    }
                    
                    finalstr = finalstr + 'null,null,' + objOnboarding.Opportunity__r.Day_after_last_day_of_service__c + ',' + objOnboarding.Website_Provider__c + ',';
                    finalstr = finalstr + objOnboarding.Website_URL__c + ',' + objOnboarding.GTM_ID_provided__c + ',';
                    finalstr = finalstr + objOnboarding.GTM_on_Site__c + ',' + objOnboarding.GA4_Property_Name_from_this_sheet__c + ',';
                    finalstr = finalstr + objOnboarding.GA4_Measurement_ID__c + ',' + objOnboarding.Foundation_GA4_View__c + ',' + objOnboarding.Id + ',' + objOnboarding.Name + ' \n';
                }
                
            }
            
            String customLabelValue = System.Label.Onboarding_Third_Sheet_Email;
            List<String> listEmails = new List<String>();
            
            If(customLabelValue.contains(','))
            {
                listEmails.addAll(customLabelValue.split(','));
            }
            Else
            {
                listEmails.add(customLabelValue);
            }
            
            String fullyFinalStr = finalstr.replace('null', '');
            
            Messaging.InboundEmail email = new Messaging.InboundEmail() ;
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            
            // intialize the list string to store emails.
            List<string> emails = new List<string>{'testbandi@gmail.com','testbandi123@gmail.com'};
                
                email.subject = 'Create case';
            email.fromAddress = 'someaddress@email.com';
            
            //assigning the emails to toAddresses 
            email.toAddresses = emails;
            email.plainTextBody = 'email body';
            Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
            attachment.body = blob.valueOf(fullyFinalStr);
            attachment.fileName = 'DEALS MARKED LOST.csv';
            email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
                
                Getting_Response_CSV_Record_Sheet3  testInbound = new Getting_Response_CSV_Record_Sheet3 ();
            testInbound.handleInboundEmail(email, env);
            
        }
    }
}