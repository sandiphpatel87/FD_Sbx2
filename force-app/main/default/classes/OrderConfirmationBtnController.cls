public class OrderConfirmationBtnController {
    public ID oppoID {get; set;}
    public String accName; 
    public OrderConfirmationBtnController(ApexPages.StandardController controller){
        
    }
    
    public PageReference  savePDF() {
        
        Id oppId = ApexPages.currentPage().getParameters().get('id');
        
        Pagereference pdfPage = new Pagereference('/apex/OrderConfirmationPDF');
        pdfPage.getParameters().put('id', oppId);
        pdfPage.getParameters().put('renderAs', 'pdf');
        pdfPage.setRedirect(true);
        
        PageReference ret = null;
        
        //try {
        Blob pdfBlob = Test.isRunningTest()
            ? Blob.valueOf('Test PDF Content')
            : pdfPage.getContentAsPDF();
        
        
        Opportunity opp = [SELECT Id, Account.Id, Account.Name, Contract_Signer__c, Contract_Signer_Email__c, Contract_Sent_Date__c,Contract_Signer_Title__c,
                           Contract_Signer_Phone__c, Target_Launch_Month__c, Account.Regional_performance_manager__r.Email, Account.Account_Technician__r.Email
                           FROM Opportunity 
                           WHERE Id = :ApexPages.currentPage().getParameters().get('id') LIMIT 1];
        String dttoday = System.Today().format();
        
        ContentVersion cv = new ContentVersion(                
            Title = 'Order Confirmation ' + opp.Account.Name + ' ' + dttoday,
            PathOnClient = 'Order Confirmation ' + opp.Account.Name + ' ' + dttoday + '.pdf',
            VersionData = pdfBlob,
            FirstPublishLocationId = oppId
        );
        
        insert cv;
        System.debug('ContentVersion inserted: ' + cv);
        
        ret = new ApexPages.StandardController([SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :cv.Id]).view();
        
        AccountContactRelation con = [SELECT Id, AccountId, Contact.Name, Contact.Title__c, Contact.Email, Roles
                                      from AccountContactRelation 
                                      Where AccountId=:opp.AccountId AND Roles includes ('Contract Signer') LIMIT 1];
        
        String productList = '';        	
        for (OpportunityLineItem opli : [Select Id, Product2.Name from OpportunityLineItem where OpportunityId = :oppId]) {
            productList += opli.Product2.Name + '<br/>'; // Use <br/> for line breaks in HTML
        }
        String fromEmail = '';
        if (!String.isEmpty(Label.Contract_Email_Address)) {
            fromEmail = Label.Contract_Email_Address;
        }
        
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Messaging.Emailfileattachment efa1 = new Messaging.Emailfileattachment();
        
        Blob Data = pdfBlob;            
        efa1.setBody(Data);
        efa1.setFileName(cv.Title);
        efa1.setContentType('application/pdf');            
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
        
        mail.setSubject('Revised Foundation Direct Agreement: ' + opp.Account.Name);
        mail.setToAddresses(new String[] {con.Contact.Email});
        
        List<String> ccEmails = new List<String>();
        if (!String.isEmpty(Label.Order_Confirmation_CC_Email_Addr)) {
            ccEmails = Label.Order_Confirmation_CC_Email_Addr.split(',');
        }
        if(opp.Account.Regional_performance_manager__r.Email != null){
            ccEmails.add(opp.Account.Regional_performance_manager__r.Email);	
        }
        if(opp.Account.Account_Technician__r.Email != null){
            ccEmails.add(opp.Account.Account_Technician__r.Email);	
        }        
        
        mail.setCcAddresses(ccEmails);    
        
        if (fromEmail != '') {
            OrgWideEmailAddress[] orgWideEmails = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :fromEmail LIMIT 1];
            mail.setOrgWideEmailAddressId(orgWideEmails[0].id);
        }
        
        String emailBody = 'Hi ' + opp.Account.Name + ',<br/><br/>' +
            'Attached are the agreed upon changes to your Digital Advertisement Agreement. Per your request, your account has been updated to include the following product(s):<br/><br/>' +
            productList + 
            '<br/>These changes are expected to take effect with a target launch of ' + opp.Target_Launch_Month__c + 
            ', pending all required approvals. Timelines may be adjusted based on review processes and implementation requirements; we will keep you informed of any updates.<br/><br/>' +
            'We look forward to supporting your business with this updated service. Thank you for your partnership!<br/><br/>' +
            'Sincerely,<br/>' +
            'contracts@foundationdirect.com';
        
        mail.setHtmlBody(emailBody);            
        messages.add(mail);
        Messaging.sendEmailResult[] sendEmailResults = Messaging.sendEmail(messages);
        system.debug('sendEmailResults : ' + sendEmailResults);
        //add logic to update fields on oppo
        //
        
        if (!sendEmailResults.get(0).isSuccess()) {
            System.StatusCode statusCode = sendEmailResults.get(0).getErrors()[0].getStatusCode();
            String errorMessage = sendEmailResults.get(0).getErrors()[0].getMessage();
            System.debug('An exception occurred while sending email: ' + errorMessage);
        }
        else{
            opp.Contract_Signer__c = con.Contact.Name;
            opp.Contract_Signer_Email__c = con.Contact.Email;
            opp.Contract_Sent_Date__c = system.today();
            opp.Contract_Signer_Title__c = con.Contact.Title__c;
            opp.Order_Conformation_Sent__c = true;
            update opp;
         }
            
            /* } catch (Exception e) {
                        ApexPages.addMessages(e);
                        System.debug('An exception occurred: ' + e.getMessage());
                    } */ 
        
        System.debug('Returning PageReference: ' + ret);
        return ret;
        
        
    }
    
    
    /* public PageReference savePDF() {
oppId = '006U900000HO79pIAD';
PageReference pdfPage = Page.OrderConfirmationPDF;
pdfPage.getParameters().put('Id', oppId);
pdfPage.setRedirect(true);
PageReference ret = null;

try {
Blob pdfBlob = Test.isRunningTest()
? Blob.valueOf('Test PDF Content')
: pdfPage.getContentAsPDF();

ContentVersion cv = new ContentVersion(
Title = 'ORDER CONFIRMATION ' + oppId,
PathOnClient = 'ORDER CONFIRMATION ' + oppId + '.pdf',
VersionData = pdfBlob,
FirstPublishLocationId = oppId
);
insert cv;
System.debug('ContentVersion inserted: ' + cv);

ret = new ApexPages.StandardController([SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :cv.Id]).view();
} catch (Exception e) {
ApexPages.addMessages(e);
System.debug('An exception occurred: ' + e.getMessage());
}
System.debug('Returning PageReference: ' + ret);
return ret;
}*/
    
}