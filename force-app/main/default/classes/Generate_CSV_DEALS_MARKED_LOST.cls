public class Generate_CSV_DEALS_MARKED_LOST 
{
    Public Static Void generateCSVForOnboarding()
    {
        //Getting record type id for Business Intelligence using developer name.
        Id businessIntelligenceRecordTypeId = Schema.SObjectType.Onboarding__c.getRecordTypeInfosByDeveloperName().get('Business_Intelligence').getRecordTypeId();
        
        //Getting record type id for Digital Advertising using developer name.
        Id digitalAdvertisingRecordTypeId = Schema.SObjectType.Onboarding__c.getRecordTypeInfosByDeveloperName().get('Digital_Advertising').getRecordTypeId();
        
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
        system.debug('listOnboardings : ' + listOnboardings);
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
            
            Messaging.EmailFileAttachment csvFile = new Messaging.EmailFileAttachment();
            csvFile.setfileName('DEALS MARKED LOST (' + Date.today() + ').csv');
            csvFile.setbody(blob.valueof(fullyFinalStr));
            
            Messaging.SingleEmailMessage emailData = new Messaging.SingleEmailMessage();
            emailData.setToaddresses(listEmails);
            emailData.setSubject('DEALS MARKED LOST');
            emailData.setFileAttachments(new list<Messaging.EmailFileAttachment>{csvFile}); 
            emailData.setPlainTextbody('Please find attached required DEALS MARKED LOST details');
            
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{emailData});
        }
    }
}