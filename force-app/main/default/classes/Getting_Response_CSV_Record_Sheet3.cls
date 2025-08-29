global class Getting_Response_CSV_Record_Sheet3 implements Messaging.InboundEmailHandler 
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
                If(btt.filename.contains('DEALS MARKED LOST') && btt.filename.endsWith('.csv'))
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
                system.debug('------------> ' + csvFieldNames[14]);
                
                system.debug('========================================================================================');
                
                Map<Id, Id> maponBoardingIds = new Map<Id, Id>();
                List<Onboarding__c> listFinalOnboardings = new List<Onboarding__c>();
                
                //get the data from 2nd row
                For (Integer i = 1; i < recordDataLines.size(); i++) 
                {
                    system.debug('Record : ' + recordDataLines[i]);
                    
                    List<String> csvRecordData = recordDataLines[i].split(',');
                    
                    system.debug('Record field data size : ' + csvRecordData.size());
                    
                    If(csvRecordData.size() >= 15)
                    {
                     	If(String.isNotBlank(csvRecordData[14]) && !maponBoardingIds.containsKey(csvRecordData[14]))
                        {
                            maponBoardingIds.put(csvRecordData[14], csvRecordData[14]);
                            
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
                            
                            //CSV Column O.
                            If(String.isNotBlank(csvRecordData[14]))
                            {
                                objOnboarding.Id = csvRecordData[14];
                            }
                            
                            listFinalOnboardings.add(objOnboarding);
                        }
                        
                        If(!listFinalOnboardings.isEmpty())
                        {
                            UPDATE listFinalOnboardings;
                        }
                    }
                }  
            }
        }
        return result;
    }
}