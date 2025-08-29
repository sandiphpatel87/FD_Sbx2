global class SendEmailForCommunityBatch implements Database.Batchable<sObject> 
{
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        String query = 'SELECT Id,Contract_Signer_Email__c FROM Opportunity WHERE Need_To_Send_welcome_Email__c = TRUE AND Sys_DocuSign_Status__c =NULL ANd Contract_Signer_Email__c !=null  LIMIT 10';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> listOpportunities) 
    {
        If(!listOpportunities.isEmpty()){
            For(Opportunity objOpportunity : listOpportunities)
            {
                List<User> user=[SELECT Id,FirstName, LastName, UserName,IsActive,ContactId,LastModifiedDate,CreatedDate
                                 From User 
                                 WHERE Email =: objOpportunity.Contract_Signer_Email__c AND IsActive = TRUE AND IsPortalEnabled = TRUE];
                
                /*String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
String hexDigest = EncodingUtil.convertToHex(hash);
String pwd = user[0].FirstName+'@'+user[0].LastName+ hexDigest;*/
                
                if(user.size() > 0 )
                {
                    String pwd = System.Label.Password_for_community_user;
                    System.setPassword(user[0].Id,pwd);
                    objOpportunity.Need_To_Send_welcome_Email__c = FALSE;
                    /*if(!String.isBlank(objOpportunity.Contract_Signer_Email__c))
                    {
                        List<EmailTemplate> CustomEmailTemplate = [SELECT Subject,HtmlValue,Body,ID 
                                                                   FROM EmailTemplate
                                                                   WHERE Name ='Community Welcome Email'];
                        
                        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ncmsupport@foundationdirect.com'];
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        if ( owea.size() > 0 ) {
                            mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        
                        List<String> getEmailList = new List<String>();
                        getEmailList.add(objOpportunity.Contract_Signer_Email__c);
                        
                        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
                        
                        
                        mail.setToAddresses(getEmailList);
                      
                        mail.setTemplateId(CustomEmailTemplate[0].ID);
                        mail.setWhatId(objOpportunity.ID);
                        mail.setTargetObjectId(user[0].ContactId);
                        mail.setSaveAsActivity(FALSE);
                        messages.add(mail); 
                        List<Email_Log__c> logList= new List<Email_Log__c>();
						List<Email_Log__c> insertlogList= new List<Email_Log__c>();
                        If(messages.size() > 0)
                        {
                            Messaging.sendEmailResult[] sendEmailResults = Messaging.sendEmail(messages);
                            system.debug('sendEmailResults : ' + sendEmailResults);
                            
                            
                            for (Messaging.SendEmailResult mr : sendEmailResults) 
                            {
                                logList=[SELECT Id, User_Creation_Status__c,Error_Message__c,Email_Sent__c FROM Email_Log__c 
                                         WHERE Opportunity__c=: objOpportunity.ID AND Subject__c='Community Welcome Email With User Creation'];
                                if (mr.isSuccess()) {
                                    if(logList.size()>0){
                                        objOpportunity.Need_To_Send_welcome_Email__c = FALSE;
                                        logList[0].Email_Sent__c ='Success';
                                        logList[0].User_Creation_Status__c = 'Success';
                                        logList[0].From_Email_Address__c = 'ncmsupport@foundationdirect.com';
                                        logList[0].To_Email_Address__c = objOpportunity.Contract_Signer_Email__c;
                                        logList[0].Error_Message__c='';
                                    }
                                    else{
                                        objOpportunity.Need_To_Send_welcome_Email__c = FALSE;

                                        Email_Log__c el= new Email_Log__c();
                                        el.Email_Sent__c ='Success';
                                        el.User_Creation_Status__c = 'Success';
                                        if(user[0].CreatedDate == user[0].LastModifiedDate)
                                        {
                                            el.Error_Message__c = 'User created successfully';
                                        }
                                        else
                                        {
                                            el.Error_Message__c = 'User activated successfully';
                                        }
                                        el.Opportunity__c = objOpportunity.Id;
                                        el.From_Email_Address__c = 'ncmsupport@foundationdirect.com';
                                        el.To_Email_Address__c =objOpportunity.Contract_Signer_Email__c;
                                        el.Subject__c ='Community Welcome Email With User Creation';
                                        insertlogList.add(el);
                                    }
                                } 
                                else {
                                    // Operation failed, so get all errors                
                                    for(Messaging.SendEmailError err : mr.getErrors()) {
                                        System.debug('The following error has occurred.');                    
                                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                        System.debug('fields that affected this error: ' + err.getFields());
                                        
                                        if(logList.size()>0){
                                            logList[0].Email_Sent__c ='Error';
                                            logList[0].Error_Message__c = err.getMessage() ;
                                        }
                                        else{
                                            Email_Log__c el= new Email_Log__c();
                                            el.Email_Sent__c ='Error';
                                            el.Error_Message__c = err.getMessage() ;
                                            el.Opportunity__c= objOpportunity.Id;
                                            el.From_Email_Address__c = 'ncmsupport@foundationdirect.com';
                                            el.To_Email_Address__c = System.Label.Send_Error_Email_To;
                                            el.Subject__c ='Community Welcome Email With User Creation';
                                            insertlogList.add(el);
                                        }
                                    }
                                }
                                 update logList;
                            }
                        }
                        insert insertlogList;
                    }*/
                }
            }
            UPDATE listOpportunities;
        }
        
    }
    global void finish(Database.BatchableContext BC) 
    {
        // execute any post-processing operations
    }
}