public class Th_ContentDocumentLinkTrigger 
{
    public static void onBeforeInsert(List<ContentDocumentLink> listContentDocumentLinks)
    {
        //Checking the listContentDocumentLinks is not empty.
        If(!listContentDocumentLinks.isEmpty())
        {
            //Iterating the ContentDocumentLink list of records.
            For(ContentDocumentLink objContentDocumentLink : listContentDocumentLinks)
            {
                objContentDocumentLink.Visibility = 'AllUsers';
            }
        }
    }
    
    public static void onAfterInsert(List<ContentDocumentLink> listContentDocumentLinks)
    {
        If(!listContentDocumentLinks.isEmpty())
        {
            Set<String> setCaseIds = new Set<String>();
            Set<String> setContentDocumentLinkIds = new Set<String>();
            
            For(ContentDocumentLink objContentDocumentLink : listContentDocumentLinks)
            {
                setCaseIds.add(objContentDocumentLink.LinkedEntityId);
                setContentDocumentLinkIds.add(objContentDocumentLink.Id);
            }
            
            Map<Id, Case> mapCases = new Map<Id, Case>([SELECT Id, Case_Assign_To__c, Case_Assign_To__r.Email, Account.Name, 
                                                        (SELECT Id, ContentDocument.LatestPublishedVersion.VersionData, 
                                                         ContentDocument.LatestPublishedVersion.Title,
                                                         ContentDocument.LatestPublishedVersion.FileExtension
                                                         FROM ContentDocumentLinks 
                                                         WHERE Id IN : setContentDocumentLinkIds
                                                         LIMIT 1
                                                        ) 
                                                        FROM Case 
                                                        WHERE Id IN : setCaseIds
                                                        AND RecordType.DeveloperName = 'NCM_Meetings'
                                                       ]);
            
            If(!mapCases.isEmpty())
            {
                // Prepare email notifications
                List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                
                OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'support@info.foundationdirect.com'];
                
                For(Id caseId : mapCases.keySet())
                {
                    If(!mapCases.get(caseId).ContentDocumentLinks.isEmpty() && mapCases.get(caseId).ContentDocumentLinks[0].ContentDocument.LatestPublishedVersion.Title.contains('NCMAgenda') && mapCases.get(caseId).Case_Assign_To__c != null && mapCases.get(caseId).Case_Assign_To__r.Email != null)
                    {
                        Messaging.EmailFileAttachment emlAtt = new Messaging.EmailFileAttachment();
                        emlAtt.setFilename(mapCases.get(caseId).ContentDocumentLinks[0].ContentDocument.LatestPublishedVersion.Title + '.' + mapCases.get(caseId).ContentDocumentLinks[0].ContentDocument.LatestPublishedVersion.FileExtension);
                        emlAtt.setBody(mapCases.get(caseId).ContentDocumentLinks[0].ContentDocument.LatestPublishedVersion.VersionData);
                        
                        // Prepare email
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(new String[] {mapCases.get(caseId).Case_Assign_To__r.Email});//mapCases.get(caseId).Owner.Email
                        email.setSubject(mapCases.get(caseId).Account.Name + ' NCM Meeting Agenda is Now Available');
                        email.setPlainTextBody('The NCM Meeting Agenda is now available for your upcoming meeting. The file is attached below.\n\n');
                        email.setFileAttachments(new Messaging.EmailFileAttachment[] { emlAtt });
                        email.setOrgWideEmailAddressId(owea.get(0).Id);
                        emails.add(email);
                    }
                }
                
                // Send emails
                If(!emails.isEmpty()) 
                {
                    Messaging.sendEmail(emails);
                }
            }
        }
    }
}