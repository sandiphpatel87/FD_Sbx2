public class OpportunityPdfGenerateForNCM {
    
    @Future(callout=true)
    public static void GeneratePDF(Id parentId, String contractSignerEmail,String accName) 
    {
        PageReference myPage = Page.OpportunityVfFile;
        myPage.getParameters().put('isPdf', 'true');
        myPage.getParameters().put('recordId',parentId);
        Blob reportPdf;
        if(Test.isRunningTest()) { 
            reportPdf = blob.valueOf('Test');
        } else {
            reportPdf = myPage.getContentAsPDF();
        }
        
        Attachment att = new Attachment(parentId =parentId,ContentType='application/pdf',Body=reportPdf);
        Date d = date.today();
        String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('d-MM-YYYY');
        att.Name='NCM Digital Composite_'+accName+'_'+dt+'_Completed'+'.pdf';
        insert att;
        
        List<Opportunity> listOpportunities = [SELECT Id,PDF_File_ID__c
                                                   FROM Opportunity 
                                                   WHERE Id = : parentId];
        if(listOpportunities.size() > 0)
        {
            listOpportunities[0].PDF_File_ID__c = att.Id;
        }
        update listOpportunities;
        
        if(!String.isBlank(contractSignerEmail))
        {
            List<User> user=[SELECT Id,FirstName, LastName, UserName,IsActive,ContactId
                             From User 
                             WHERE Email =: contractSignerEmail AND IsActive = TRUE];
            if(user.size()>0)
            {
                List<EmailTemplate> CustomEmailTemplate = [SELECT Subject,HtmlValue,Body,Id 
                                                           FROM EmailTemplate
                                                           WHERE Name ='Community Contract Attachment'];
                
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ncmsupport@foundationdirect.com'];
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] ccAddresses = new String[] {'contracts@foundationdirect.com'};
                    
                    if ( owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                mail.setCcAddresses(ccAddresses);
                List<String> getEmailList = new List<String>();
                getEmailList.add(contractSignerEmail);
                
                List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
                Messaging.Emailfileattachment efa1 = new Messaging.Emailfileattachment();
                
                efa1.setBody(reportPdf);
                efa1.setFileName(att.Name);
                efa1.setContentType('application/pdf');
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
                /*String subject = CustomEmailTemplate[0].Subject;
subject = subject.replace ( '{!Opportunity.Account}' , accName);
mail.setSubject(subject);

String emailBody = CustomEmailTemplate[0].HtmlValue ;
emailBody = emailBody.replace('{!Opportunity.NCM_20_Group_Code__c}',NCM20GroupCode);
mail.setHtmlBody(emailBody); 


String plainBody = CustomEmailTemplate[0].Body;
plainBody = plainBody.replace('{!Opportunity.NCM_20_Group_Code__c}',NCM20GroupCode);
mail.setPlainTextBody(plainBody);*/
                
                mail.setToAddresses(getEmailList);
                mail.setTemplateId(CustomEmailTemplate[0].ID);
                mail.setWhatId(parentId);
                mail.setTargetObjectId(user[0].ContactId);
                mail.setSaveAsActivity(FALSE);
                
                messages.add(mail); 
                
                 
                          List<Email_Log__c> logList= new List<Email_Log__c>();
                        
                        If(messages.size() > 0)
                        {
                            Messaging.sendEmailResult[] sendEmailResults = Messaging.sendEmail(messages);
                            system.debug('sendEmailResults : ' + sendEmailResults);
                           
                            for (Messaging.SendEmailResult mr : sendEmailResults) 
                            {
                                Email_Log__c el= new Email_Log__c();
                                if (mr.isSuccess()) {
                                  
                                    
                                     el.Email_Sent__c ='Success';
                                    el.User_Creation_Status__c ='N/A';
                                    el.Opportunity__c = parentId;
                                    el.From_Email_Address__c = 'ncmsupport@foundationdirect.com';
                                    el.To_Email_Address__c = contractSignerEmail;
                                    el.Subject__c ='Community Contract Attachment';
                                    
                                } 
                                else {
                                    // Operation failed, so get all errors                
                                    for(Messaging.SendEmailError err : mr.getErrors()) {
                                        System.debug('The following error has occurred.');                    
                                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                        System.debug('fields that affected this error: ' + err.getFields());
                                        
                                        el.Email_Sent__c ='Error';
                                        el.User_Creation_Status__c ='N/A';
                                        el.Opportunity__c = parentId;
                                        el.From_Email_Address__c = 'ncmsupport@foundationdirect.com';
                                        el.To_Email_Address__c = contractSignerEmail;
                                        el.Subject__c ='Community Contract Attachment';
                                        el.Error_Message__c = err.getMessage() ;
                                    }
                                }
                                logList.add(el);
                            }
                        }
                        
                        insert logList;
            }
        }
    }
}