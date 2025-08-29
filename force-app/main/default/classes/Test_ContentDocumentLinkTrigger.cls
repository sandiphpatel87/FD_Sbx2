@isTest
public class Test_ContentDocumentLinkTrigger 
{
    @isTest
    public static void testContentDocumentLinkTrigger()
    {
        Test.StartTest();
        
        User objUser = new User();
        objUser.Id = UserInfo.getUserId();
        objUser.Email = 'test@gmail.com';
        UPDATE objUser;
        
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        INSERT objAccount;
        
        // Create a Case record
        Case objCase = new Case();
        objCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('NCM_Meetings').getRecordTypeId();
        objCase.AccountId = objAccount.Id;
        objCase.Subject = 'Test Case';
        objCase.Case_Assign_To__c = objUser.Id;
        INSERT objCase;
        
        objCase.Case_Assign_To__c = objUser.Id;
        UPDATE objCase;
        
        ContentVersion objContentVersion = new ContentVersion(); 
        objContentVersion.Title = 'NCMAgenda_Header_Picture1'; 
        objContentVersion.PathOnClient = '/' + objContentVersion.Title + '.jpg'; 
        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body'); 
        objContentVersion.VersionData = bodyBlob;
        objContentVersion.origin = 'H';
        INSERT objContentVersion;
        
        ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
        objContentDocumentLink.LinkedEntityId = objCase.Id;
        objContentDocumentLink.contentdocumentid = [SELECT contentdocumentid FROM contentversion WHERE id =: objContentVersion.id].contentdocumentid;
        objContentDocumentLink.ShareType = 'I';
        objContentDocumentLink.Visibility = 'AllUsers'; 
        INSERT objContentDocumentLink;
        
        Test.StopTest();
    }
}