global class Getting_Response_CSV_Record_Sheet2 implements Messaging.InboundEmailHandler 
{
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope)
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        Messaging.InboundEmail.BinaryAttachment[] tAttachments = email.binaryAttachments; // // Since Attachment is CSV we are taking as BinaryAttachments. 
        
        system.debug('---------> ' + tAttachments);
        
        List<String> recordDataLines = new List<String>();//store to CSV's each data lines
        
        If(tAttachments !=null)
        {
            system.debug('tAttachments : ' + tAttachments);
            
            For(Messaging.InboundEmail.BinaryAttachment btt : tAttachments)
            {
                If(btt.filename.contains('ALL ACTIVE CUSTOMERS') && btt.filename.endsWith('.csv'))
                {
                    recordDataLines = btt.body.toString().trim().split('\n');                    
                }
            }
            
            If(!recordDataLines.isEmpty())
            {
                system.debug('Getting First row : ' + recordDataLines[0].split(','));
                
                //get the first row for field headers and get the related field api name from metadata
                List<String> csvFieldNames = recordDataLines[0].split(',');
                
                system.debug('Record field size : ' + csvFieldNames.size());
                
                system.debug('------------> ' + csvFieldNames[0]);
                
                system.debug('========================================================================================');
                
                List<Onboarding__c> listFinalOnboardings = new List<Onboarding__c>();
                Map<String, String> maponBoardingIds = new Map<String, String>();
                
                //get the data from 2nd row
                For (Integer i = 1; i < recordDataLines.size(); i++) 
                {
                    system.debug('Record : ' + recordDataLines[i]);
                    List<String> csvRecordData = new List<String>();
                    
                    IF(recordDataLines[i].contains('['))
                    {
                        String strValue = recordDataLines[i];
                        strValue = strValue.substringBetween('[', ']');
                        
                        If(String.isNotBlank(strValue))
                        {
                            String strstString = String.valueOf(recordDataLines[i]).split(',"\\[').get(0);
                            system.debug('strstString : ' + strstString);
                            
                            String secondString = String.valueOf(recordDataLines[i]).split('\\]",').get(1);
                            system.debug('secondString : ' + secondString);
                            
                            String str = String.valueOf(recordDataLines[i]).split('\\]",').get(0);
                            String str1 = str.split(',"\\[').get(1);
                            
                            system.debug('str1 : ' + str1);
                            str1 = str1.replace('"', '');
                            
                            csvRecordData.addAll(strstString.split(','));
                            csvRecordData.add(str1);
                            csvRecordData.addAll(secondString.split(','));
                        }
                        Else
                        {
                            csvRecordData = recordDataLines[i].split(',');
                        }
                    }
                    
                    system.debug('Record field data size : ' + csvRecordData.size());
                    
                    If(csvRecordData.size() >= 28)
                    {
                        
                        If(String.isNotBlank(csvRecordData[27]) && !maponBoardingIds.containsKey(csvRecordData[27]))
                        {
                            maponBoardingIds.put(csvRecordData[27], csvRecordData[27]);
                            
                            Onboarding__c objOnboarding = new Onboarding__c();
                            
                            //CSV Column A.
                            If(String.isNotBlank(csvRecordData[0]))
                            {
                                If(csvRecordData[0].toUppercase() == 'TRUE')
                                {
                                    objOnboarding.Mutual_Client_with_VistaDash__c = true;
                                }
                                Else If(csvRecordData[0].toUppercase() == 'FALSE')
                                {
                                    objOnboarding.Mutual_Client_with_VistaDash__c = false;
                                }
                            }
                            
                            //CSV Column G.
                            If(String.isNotBlank(csvRecordData[6]))
                            {
                                objOnboarding.GA_Account_Shared__c = csvRecordData[6];
                            }
                            
                            //CSV Column H.
                            If(String.isNotBlank(csvRecordData[7]))
                            {
                                objOnboarding.GTM_ID_provided__c = csvRecordData[7];
                            }
                            
                            //CSV Column I.
                            If(String.isNotBlank(csvRecordData[8]) && csvRecordData[8] != '[]')
                            {
                                List<String> listStrings = new List<String>();
                                String multiValue = csvRecordData[8];
                                
                                If(multiValue.contains(','))
                                {
                                    listStrings.addAll(multiValue.split(','));
                                }
                                Else
                                {
                                    listStrings.add(multiValue);
                                }
                                objOnboarding.Google_Facebook_Pixel_script_added_to_GT__c = String.join(listStrings, ';');
                            }
                            
                            //CSV Column J.
                            If(String.isNotBlank(csvRecordData[9]))
                            {
                                String strDate = csvRecordData[9];
                                List<String> listStringDates = new List<String>();
                                listStringDates.addAll(strDate.split('/'));
                                system.debug('listStringDates : ' + listStringDates);
                                objOnboarding.GTM_on_Site__c = Date.newInstance(Integer.valueOf(listStringDates[2]), Integer.valueOf(listStringDates[0]), Integer.valueOf(listStringDates[1]));
                            }
                            
                            //CSV Column K.
                            If(String.isNotBlank(csvRecordData[10]))
                            {
                                objOnboarding.GA4_Property_Name_from_this_sheet__c = csvRecordData[10];
                            }
                            
                            //CSV Column L.
                            If(String.isNotBlank(csvRecordData[11]))
                            {
                                objOnboarding.GA4_Measurement_ID__c = csvRecordData[11];
                            }
                            
                            //CSV Column M.
                            If(String.isNotBlank(csvRecordData[12]))
                            {
                                objOnboarding.Foundation_GA4_View__c = csvRecordData[12];
                            }
                            
                            //CSV Column N.
                            If(String.isNotBlank(csvRecordData[13]))
                            {
                                String strDate = csvRecordData[13];
                                List<String> listStringDates = new List<String>();
                                listStringDates.addAll(strDate.split('/'));
                                system.debug('listStringDates : ' + listStringDates);
                                objOnboarding.GTM_Container_Updated_for_GA4__c = Date.newInstance(Integer.valueOf(listStringDates[2]), Integer.valueOf(listStringDates[0]), Integer.valueOf(listStringDates[1]));
                            }
                            
                            //CSV Column O.
                            If(String.isNotBlank(csvRecordData[14]))
                            {
                                String strDate = csvRecordData[14];
                                List<String> listStringDates = new List<String>();
                                listStringDates.addAll(strDate.split('/'));
                                system.debug('listStringDates : ' + listStringDates);
                                objOnboarding.Vistadash_Conversions_Configuration_GA4__c = Date.newInstance(Integer.valueOf(listStringDates[2]), Integer.valueOf(listStringDates[0]), Integer.valueOf(listStringDates[1]));
                            }
                            
                            //CSV Column P.
                            If(String.isNotBlank(csvRecordData[15]))
                            {
                                String strDate = csvRecordData[15];
                                List<String> listStringDates = new List<String>();
                                listStringDates.addAll(strDate.split('/'));
                                system.debug('listStringDates : ' + listStringDates);
                                objOnboarding.Custom_Definitions_Configurati__c = Date.newInstance(Integer.valueOf(listStringDates[2]), Integer.valueOf(listStringDates[0]), Integer.valueOf(listStringDates[1]));
                            }
                            
                            //CSV Column Q.
                            If(String.isNotBlank(csvRecordData[16]))
                            {
                                If(csvRecordData[16].toUppercase() == 'TRUE')
                                {
                                    objOnboarding.BigQuery_is_linked_in_GA4__c = true;
                                }
                                Else If(csvRecordData[16].toUppercase() == 'FALSE')
                                {
                                    objOnboarding.BigQuery_is_linked_in_GA4__c = false;
                                }
                            }
                            
                            //CSV Column R.
                            If(String.isNotBlank(csvRecordData[17]))
                            {
                                If(csvRecordData[17].toUppercase() == 'TRUE')
                                {
                                    objOnboarding.Vistadash_Event_Owner_Custom_Dimension_C__c = true;
                                }
                                Else If(csvRecordData[17].toUppercase() == 'FALSE')
                                {
                                    objOnboarding.Vistadash_Event_Owner_Custom_Dimension_C__c = false;
                                }
                            }
                            
                            //CSV Column S.
                            If(String.isNotBlank(csvRecordData[18]))
                            {
                                objOnboarding.GA4_Notes__c = csvRecordData[18];
                            }
                            
                            //CSV Column T.
                            If(String.isNotBlank(csvRecordData[19]))
                            {
                                objOnboarding.Website_Provider__c = csvRecordData[19];
                            }
                            
                            //CSV Column U.
                            If(String.isNotBlank(csvRecordData[20]))
                            {
                                objOnboarding.Digital_Retail_Provider__c = csvRecordData[20];
                            }
                            
                            //CSV Column V.
                            /*If(String.isNotBlank(csvRecordData[21]))
                            {
                                objOnboarding.Service_Scheduler__c = csvRecordData[21];
                            }*/
                            
                            //CSV Column W.
                            If(String.isNotBlank(csvRecordData[21]))
                            {
                                objOnboarding.Chat_Provider__c = csvRecordData[21];
                            }
                            
                            //CSV Column X.
                            If(String.isNotBlank(csvRecordData[22]))
                            {
                                objOnboarding.Chat_Start__c = csvRecordData[22];
                            }
                            
                            //CSV Column Y.
                            If(String.isNotBlank(csvRecordData[23]))
                            {
                                objOnboarding.Click_to_Call__c = csvRecordData[23];
                            }
                            
                            //CSV Column Z.
                            /*If(String.isNotBlank(csvRecordData[24]))
                            {
                                objOnboarding.Contact_Us__c = csvRecordData[24];
                            }*/
                            
                            //CSV Column AA.
                            If(String.isNotBlank(csvRecordData[24]))
                            {
                                objOnboarding.DR_Start__c = csvRecordData[24];
                            }
                            
                            //CSV Column AB.
                            If(String.isNotBlank(csvRecordData[25]))
                            {
                                objOnboarding.Finance_Start__c = csvRecordData[25];
                            }
                            
                            //CSV Column AC.
                            If(String.isNotBlank(csvRecordData[26]))
                            {
                                objOnboarding.Lead_Form__c = csvRecordData[26];
                            }
                            
                            //CSV Column AD.
                            /*If(String.isNotBlank(csvRecordData[28]))
                            {
                                objOnboarding.Print_Service_Coupon__c = csvRecordData[28];
                            }*/
                            
                            //CSV Column AE.
                            /*If(String.isNotBlank(csvRecordData[30]))
                            {
                                objOnboarding.Schedule_Service__c = csvRecordData[30];
                            }*/
                            
                            //CSV Column AF.
                            /*If(String.isNotBlank(csvRecordData[27]))
                            {
                                objOnboarding.Text_Start__c = csvRecordData[27];
                            }*/
                            
                            //CSV Column AG.
                            /*If(String.isNotBlank(csvRecordData[28]))
                            {
                                objOnboarding.Trade_In_Start__c = csvRecordData[28];
                            } */
                            
                            //CSV Column AH.
                            If(String.isNotBlank(csvRecordData[27]))
                            {
                                objOnboarding.Id = csvRecordData[27];
                            } 
                            
                            listFinalOnboardings.add(objOnboarding);
                        }
                    }
                }   
                
                If(!listFinalOnboardings.isEmpty())
                {
                    UPDATE listFinalOnboardings;
                }
            }
        }
        return result;
    }
}