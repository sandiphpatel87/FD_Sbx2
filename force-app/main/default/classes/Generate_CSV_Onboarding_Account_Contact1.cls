public class Generate_CSV_Onboarding_Account_Contact1 
{
    Public Static Void generateCSVForOnboarding()
    {
        //Getting record type id for Business Intelligence using developer name.
        Id businessIntelligenceRecordTypeId = Schema.SObjectType.Onboarding__c.getRecordTypeInfosByDeveloperName().get('Business_Intelligence').getRecordTypeId();
        
        //Getting record type id for Digital Advertising using developer name.
        Id digitalAdvertisingRecordTypeId = Schema.SObjectType.Onboarding__c.getRecordTypeInfosByDeveloperName().get('Digital_Advertising').getRecordTypeId();
        
        List<Onboarding__c> listOnboardings = [SELECT Id, Name, Mutual_Client_with_VistaDash__c, Touchpoint_Master_ID__c, RecordTypeId, Account__c, Account__r.Name, Account__r.Parent.Name, Website_Provider__c,
                                               Website_URL__c, GA_Account_Shared__c, GTM_ID_provided__c, Google_Facebook_Pixel_script_added_to_GT__c, GTM_on_Site__c, GA4_Property_Name_from_this_sheet__c,
                                               GA4_Measurement_ID__c, Foundation_GA4_View__c, GTM_Container_Updated_for_GA4__c, Vistadash_Conversions_Configuration_GA4__c,
                                               Custom_Definitions_Configurati__c, Vistadash_Event_Owner_Custom_Dimension_C__c, GA4_Notes__c, Digital_Retail_Provider__c,
                                               Chat_Provider__c, Chat_Start__c, Click_to_Call__c, DR_Start__c, Finance_Start__c, Lead_Form__c,
                                               BigQuery_is_linked_in_GA4__c, Opportunity__r.Contract_Signed_Date__c
                                               FROM Onboarding__c
                                               WHERE (RecordTypeId =: businessIntelligenceRecordTypeId
                                                      OR RecordTypeId =: digitalAdvertisingRecordTypeId)
                                               AND (Opportunity__r.StageName = 'Cancellation' OR Opportunity__r.StageName = 'Live')
                                               ORDER BY Opportunity__r.Contract_Signed_Date__c ASC
                                              ];
        
        If(!listOnboardings.isEmpty())
        {
            Map<String, List<Contact>> mapAccountContacts = new Map<String, List<Contact>>();
            
            For(Onboarding__c objOnboarding : listOnboardings)
            {
                If(objOnboarding.Account__c != null && !mapAccountContacts.containsKey(objOnboarding.Account__c))
                {
                    List<Contact> listContacts = new List<Contact>();
                    mapAccountContacts.put(objOnboarding.Account__c, listContacts);
                }
            }
            
            List<AccountContactRelation> listAccountContactRelations = [SELECT Id, AccountId, ContactId, Roles 
                                                                        FROM AccountContactRelation
                                                                        WHERE AccountId IN : mapAccountContacts.keySet()
                                                                        AND Roles INCLUDES ('Analytics','Onboarding')
                                                                        AND ContactId != null
                                                                       ];
            
            Map<String, String> mapContactAndRoles = new Map<String, String>();
            
            If(!listAccountContactRelations.isEmpty())
            {
                For(AccountContactRelation objAccountContactRelation : listAccountContactRelations)
                {
                    mapContactAndRoles.put(objAccountContactRelation.ContactId, objAccountContactRelation.Roles);
                }
            }
            
            List<Contact> listContacts = [SELECT Name, Email, AccountId 
                                          FROM Contact 
                                          WHERE Id IN : mapContactAndRoles.keySet()
                                          AND AccountId != null
                                         ];
            
            If(!listContacts.isEmpty())
            {
                For(Contact objContact : listContacts)
                {
                    If(mapAccountContacts.containskey(objContact.AccountId) && mapAccountContacts.get(objContact.AccountId) != null)
                    {
                        mapAccountContacts.get(objContact.AccountId).add(objContact);
                    }
                }
            }
            
            String contactStr = '';
            Integer maxCountSize = 0;
            
            For(Onboarding__c objOnboarding : listOnboardings)
            {
                //If Account field is not black.
                If(objOnboarding.Account__c != null && mapAccountContacts.containsKey(objOnboarding.Account__c))
                {
                    If(mapAccountContacts.get(objOnboarding.Account__c) != null)
                    {
                        Integer count = 0;
                        count = mapAccountContacts.get(objOnboarding.Account__c).size();
                        If(count > maxCountSize)
                        {
                            maxCountSize = count;
                        }
                    }
                }
            }
            
            For(Integer i = 1; i <= maxCountSize; i++)
            {
                If(i != maxCountSize)
                {
                    contactStr = contactStr + 'Contact Name ' + i + ', Contact Email ' + i + ', Contact Role ' + i + ',';
                }
                Else
                {
                    contactStr = contactStr + 'Contact Name ' + i + ', Contact Email ' + i + ', Contact Role ' + i;
                }
            }
            
            String finalstr = 'Mutual Client with Vistadash, Record Type (Business Intelligence or Digital Advertising), Account Name, Contract Signed Date (Old to New), Parent Account, Website Provider, Website URL, GA Account Access, GTM ID, Pixel script added to GTM Container, GTM on Site, GA4 Property Name, GA4 Measurement ID, GA4 Property ID, GTM Container Updated for GA4, Vistadash Conversions Configuration GA4, Custom Definitions Configuration GA4, Big Query is linked in GA4, Custom Dimension Configuration GA4, GA4 Notes, Digital Retail Provider, Chat Provider, Chat Start, Click to Call, DR Start, Finance Start, Lead Form,Id, Name,Touchpoint Master ID,' + contactStr + ' \n';
            
            For(Onboarding__c objOnboarding : listOnboardings)
            {
                //If Account field is not black.
                If(objOnboarding.Account__c != null && mapAccountContacts.containsKey(objOnboarding.Account__c))
                {
                    If(mapAccountContacts.get(objOnboarding.Account__c) != null)
                    {
                        String contactDetails = '';
                        Integer innerCount = 0;
                        Integer remainCount = 0;
                        
                        For(Contact objContact : mapAccountContacts.get(objOnboarding.Account__c))
                        {
                            innerCount = innerCount + 1;
                            contactDetails = contactDetails + objContact.Name + ',' + objContact.Email + ',' + mapContactAndRoles.get(objContact.Id) + ',';
                        }
                        
                        remainCount = maxCountSize - innerCount;
                        
                        If(remainCount > 0)
                        {
                            For(Integer j = 1; j <= remainCount; j++)
                            {
                                contactDetails = contactDetails + 'null,null,null,';
                            }
                        }
                        For(Contact objContact : mapAccountContacts.get(objOnboarding.Account__c))
                        {
                            finalstr = finalstr + objOnboarding.Mutual_Client_with_VistaDash__c + ',';
                            
                            If(objOnboarding.recordTypeId == businessIntelligenceRecordTypeId)
                            {
                                finalstr = finalstr + 'Business Intelligence,';
                            }
                            If(objOnboarding.recordTypeId == digitalAdvertisingRecordTypeId)
                            {
                                finalstr = finalstr + 'Digital Advertising,';
                            }
                            
                            finalstr = finalstr + objOnboarding.Account__r.Name + ',' + objOnboarding.Opportunity__r.Contract_Signed_Date__c + ',' + objOnboarding.Account__r.Parent.Name + ',';
                            finalstr = finalstr + objOnboarding.Website_URL__c + ',' + objOnboarding.GA_Account_Shared__c + ',' + objOnboarding.GTM_ID_provided__c + ',';
                            finalstr = finalstr + objOnboarding.Google_Facebook_Pixel_script_added_to_GT__c + ',' + objOnboarding.GTM_on_Site__c + ',' + objOnboarding.GA4_Property_Name_from_this_sheet__c + ',';
                            finalstr = finalstr + objOnboarding.GA4_Measurement_ID__c + ',' + objOnboarding.Foundation_GA4_View__c + ',' + objOnboarding.GTM_Container_Updated_for_GA4__c + ',';
                            finalstr = finalstr + objOnboarding.Vistadash_Conversions_Configuration_GA4__c + ',' + objOnboarding.Custom_Definitions_Configurati__c + ',' + objOnboarding.BigQuery_is_linked_in_GA4__c + ',' + objOnboarding.Vistadash_Event_Owner_Custom_Dimension_C__c + ',';
                            finalstr = finalstr + objOnboarding.GA4_Notes__c + ',' + objOnboarding.Website_Provider__c + ',' + objOnboarding.Digital_Retail_Provider__c + ',';// + objOnboarding.Service_Scheduler__c + ',';
                            finalstr = finalstr + objOnboarding.Chat_Provider__c + ',' + objOnboarding.Chat_Start__c + ',' + objOnboarding.Click_to_Call__c + ',';// + objOnboarding.Contact_Us__c + ',';
                            finalstr = finalstr + objOnboarding.DR_Start__c + ',' + objOnboarding.Finance_Start__c + ',' + objOnboarding.Lead_Form__c + ',';// + objOnboarding.Print_Service_Coupon__c + ',';
                            //finalstr = finalstr + objOnboarding.Schedule_Service__c + ',' + objOnboarding.Text_Start__c	 + ',' + objOnboarding.Trade_In_Start__c + ',' + objOnboarding.Id + ',' + objOnboarding.Name + ',' + objOnboarding.Touchpoint_Master_ID__c + ',' + contactDetails + ' \n';
                            finalstr = finalstr + objOnboarding.Id + ',' + objOnboarding.Name + ',' + objOnboarding.Touchpoint_Master_ID__c + ',' + contactDetails + ' \n';
                        }
                    }
                    Else
                    {
                        String contactDetails = '';
                        
                        For(Integer j = 1;j <= maxCountSize; j++)
                        {
                            contactDetails = contactDetails + 'null,null,null,';
                        }
                        
                        finalstr = finalstr + objOnboarding.Mutual_Client_with_VistaDash__c + ',';
                        
                        If(objOnboarding.recordTypeId == businessIntelligenceRecordTypeId)
                        {
                            finalstr = finalstr + 'Business Intelligence,';
                        }
                        If(objOnboarding.recordTypeId == digitalAdvertisingRecordTypeId)
                        {
                            finalstr = finalstr + 'Digital Advertising,';
                        }
                        
                        finalstr = finalstr + objOnboarding.Account__r.Name + ',' + objOnboarding.Opportunity__r.Contract_Signed_Date__c + ',' + objOnboarding.Account__r.Parent.Name + ',';
                        finalstr = finalstr + objOnboarding.Website_URL__c + ',' + objOnboarding.GA_Account_Shared__c + ',' + objOnboarding.GTM_ID_provided__c + ',';
                        finalstr = finalstr + objOnboarding.Google_Facebook_Pixel_script_added_to_GT__c + ',' + objOnboarding.GTM_on_Site__c + ',' + objOnboarding.GA4_Property_Name_from_this_sheet__c + ',';
                        finalstr = finalstr + objOnboarding.GA4_Measurement_ID__c + ',' + objOnboarding.Foundation_GA4_View__c + ',' + objOnboarding.GTM_Container_Updated_for_GA4__c + ',';
                        finalstr = finalstr + objOnboarding.Vistadash_Conversions_Configuration_GA4__c + ',' + objOnboarding.Custom_Definitions_Configurati__c + ',' + objOnboarding.BigQuery_is_linked_in_GA4__c + ',' + objOnboarding.Vistadash_Event_Owner_Custom_Dimension_C__c + ',';
                        finalstr = finalstr + objOnboarding.GA4_Notes__c + ',' + objOnboarding.Website_Provider__c + ',' + objOnboarding.Digital_Retail_Provider__c + ',';// + objOnboarding.Service_Scheduler__c + ',';
                        finalstr = finalstr + objOnboarding.Chat_Provider__c + ',' + objOnboarding.Chat_Start__c + ',' + objOnboarding.Click_to_Call__c + ',';// + objOnboarding.Contact_Us__c + ',';
                        finalstr = finalstr + objOnboarding.DR_Start__c + ',' + objOnboarding.Finance_Start__c + ',' + objOnboarding.Lead_Form__c + ',';// + objOnboarding.Print_Service_Coupon__c + ',';
                        //finalstr = finalstr + objOnboarding.Schedule_Service__c + ',' + objOnboarding.Text_Start__c	 + ',' + objOnboarding.Trade_In_Start__c + ',' + objOnboarding.Id + ',' + objOnboarding.Name + ',' + objOnboarding.Touchpoint_Master_ID__c + ',' + contactDetails + ' \n';
                        finalstr = finalstr + objOnboarding.Id + ',' + objOnboarding.Name + ',' + objOnboarding.Touchpoint_Master_ID__c + ',' + contactDetails + ' \n';
                    }
                }
                Else
                {
                    String contactDetails = '';
                    
                    For(Integer j = 1; j <= maxCountSize; j++)
                    {
                        contactDetails = contactDetails + 'null,null,null,';
                    }
                    
                    finalstr = finalstr + objOnboarding.Mutual_Client_with_VistaDash__c + ',';
                    
                    If(objOnboarding.recordTypeId == businessIntelligenceRecordTypeId)
                    {
                        finalstr = finalstr + 'Business Intelligence,';
                    }
                    If(objOnboarding.recordTypeId == digitalAdvertisingRecordTypeId)
                    {
                        finalstr = finalstr + 'Digital Advertising,';
                    }
                    
                    finalstr = finalstr + 'null' + ',' + objOnboarding.Opportunity__r.Contract_Signed_Date__c + ',' + 'null,';
                    finalstr = finalstr + objOnboarding.Website_URL__c + ',' + objOnboarding.GA_Account_Shared__c + ',' + objOnboarding.GTM_ID_provided__c + ',';
                    finalstr = finalstr + objOnboarding.Google_Facebook_Pixel_script_added_to_GT__c + ',' + objOnboarding.GTM_on_Site__c + ',' + objOnboarding.GA4_Property_Name_from_this_sheet__c + ',';
                    finalstr = finalstr + objOnboarding.GA4_Measurement_ID__c + ',' + objOnboarding.Foundation_GA4_View__c + ',' + objOnboarding.GTM_Container_Updated_for_GA4__c + ',';
                    finalstr = finalstr + objOnboarding.Vistadash_Conversions_Configuration_GA4__c + ',' + objOnboarding.Custom_Definitions_Configurati__c + ',' + objOnboarding.BigQuery_is_linked_in_GA4__c + ',' + objOnboarding.Vistadash_Event_Owner_Custom_Dimension_C__c + ',';
                    finalstr = finalstr + objOnboarding.GA4_Notes__c + ',' + objOnboarding.Website_Provider__c + ',' + objOnboarding.Digital_Retail_Provider__c + ',';// + objOnboarding.Service_Scheduler__c + ',';
                    finalstr = finalstr + objOnboarding.Chat_Provider__c + ',' + objOnboarding.Chat_Start__c + ',' + objOnboarding.Click_to_Call__c + ',';// + objOnboarding.Contact_Us__c + ',';
                    finalstr = finalstr + objOnboarding.DR_Start__c + ',' + objOnboarding.Finance_Start__c + ',' + objOnboarding.Lead_Form__c + ',';// + objOnboarding.Print_Service_Coupon__c + ',';
                    //finalstr = finalstr + objOnboarding.Schedule_Service__c + ',' + objOnboarding.Text_Start__c	 + ',' + objOnboarding.Trade_In_Start__c + ',' + objOnboarding.Id + ',' + objOnboarding.Name + ',' + objOnboarding.Touchpoint_Master_ID__c + ',' + contactDetails + ' \n';
                    finalstr = finalstr + objOnboarding.Id + ',' + objOnboarding.Name + ',' + objOnboarding.Touchpoint_Master_ID__c + ',' + contactDetails + ' \n';
                }
                
            }
            
            String customLabelValue = System.Label.Onboarding_Second_Sheet_Email;
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
            csvFile.setfileName('ALL ACTIVE CUSTOMERS (' + Date.today() + ').csv');
            csvFile.setbody(blob.valueof(fullyFinalStr));
            
            Messaging.SingleEmailMessage emailData = new Messaging.SingleEmailMessage();
            emailData.setToaddresses(listEmails);
            emailData.setSubject('ALL ACTIVE CUSTOMERS');
            emailData.setFileAttachments(new list<Messaging.EmailFileAttachment>{csvFile}); 
            emailData.setPlainTextbody('Please find attached required all active customer details');
            
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{emailData});
        }
    }
}