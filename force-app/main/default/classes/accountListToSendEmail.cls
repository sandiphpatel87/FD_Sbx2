public class accountListToSendEmail {
    
    @AuraEnabled
    public static List <Account> fetchAccount() {
        String excludeAcc = Label.Exclude_account;
        string[] splitVal = excludeAcc.split(',');
        list<string> accName = new list<String>();
        for(String str : splitVal){
         accName.add(str);   
        }
        List<String> filterForType = new List<String>{'Dealer Group','NCM','Business Intelligence'};
        return [SELECT Id, Name, Type__c,Health_Flag__c,Health_flag_color__c,Current_Month_Budget__c,New_Month_Budget__c,All_Opportunities__c 
               FROM Account 
               Where 
               (Active__c = TRUE AND Type__c INCLUDES('Digital Advertising') AND Name NOT IN :accName AND Exclude_for_Media_Budget_Email__c = FALSE) 
               OR 
               (Active__c = TRUE AND Name NOT IN :accName AND Hybrid_TVM_Executed_Strategy__c = true) 
               Order By 
               createdDate DESC];
    }
    
    @AuraEnabled
    public static String listofEmailTemplates(String emailTempName, String accIds, String roleType) {       
        system.debug('Temp before >>> '+ emailTempName +' ACC ID > '+accIds); 
        List<Account> accList = new List<Account>();
        //List<Contact> conList = new List<Contact>();
        String retrnMessage;
        List<String> contactRoleType = new List<String>();
        system.debug('Role Type >>> '+ roleType);
        if(roleType == 'Media Decision Maker'){
            contactRoleType.add('Media Budget Decision Maker');
        }else if(roleType == 'Primary/Secondray') {
            contactRoleType.add('Primary Contact');
            contactRoleType.add('Secondary contact');
        }else if(roleType == 'All Contacts'){
            contactRoleType.add('All');
        }
        
        
        
        Type idArrType = Type.forName('List<string>');
        List<string> wrapperList = new  List<string> ();
        if(!test.isRunningTest()){
            wrapperList = (List<string>) JSON.deserialize(accIds, idArrType);
        }
        else{
            String accId = accIds;
            wrapperList.add(accId);
        }
        
        EmailTemplate  tempList = [Select Id,Name from EmailTemplate  where Name =: emailTempName];
        system.debug('Temp after Query >>> '+ tempList+'wraplist >>'+wrapperList); 
       
        if(contactRoleType.contains('All')){
            accList = [SELECT Id, (SELECT ContactID,Contact.Name,Contact.Email,Roles FROM AccountContactRelations) FROM Account WHERE Id IN:wrapperList];    
        }
        else if(contactRoleType.contains('Media Budget Decision Maker')){
         accList = [SELECT Id, (SELECT ContactID,Contact.Name,Contact.Email,Roles FROM AccountContactRelations Where Roles includes ('Media Budget Decision Maker')) FROM Account WHERE Id IN:wrapperList];    
        }
        else{
        accList = [SELECT Id, (SELECT ContactID,Contact.Name,Contact.Email,Roles FROM AccountContactRelations Where Roles includes ('Primary Contact','Secondary contact')) FROM Account WHERE Id IN:wrapperList];    
        }
        
      /*  else{
            accList = [SELECT Id, (SELECT ContactID,Contact.Name,Contact.Email,Roles FROM AccountContactRelations Where Roles =:contactRoleType) FROM Account WHERE Id IN:wrapperList];    
        }*/
        system.debug('account query >> '+accList);
        List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'support@info.foundationdirect.com'];
        
        for(Account acc:accList){
            for(AccountContactRelation con: acc.AccountContactRelations){
                try{
                    String[] toAddress = new String[] {con.Contact.Email};
                    String[] bccAddress = new String[] {'Budgets@foundationdirect.com'};
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(tempList.Id);
                    mail.saveAsActivity = false;
                    mail.setTargetObjectId(con.ContactID);// Any contact or User id of your record
                    mail.setToAddresses(toAddress);
                    mail.setBccAddresses(bccAddress) ;
                    mail.setWhatId(acc.ID); // Enter your record Id whose merge field you want to add in template
                    //mail.setSenderDisplayName('Foundation Direct Support');
                    //mail.setReplyTo('support@info.foundationdirect.com');
                    if (owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }                    
                    mail.setTreatTargetObjectAsRecipient(false); // set this to stop sending email to target object id(contact ID).
                    mailsToSend.add(mail);
                    System.debug('email body >>>> ');
                }catch(exception e){
                    retrnMessage = 'Exception Occured...';
                }
            }//Contact for loop
        }//Account for loop
        //Send Email
        if(mailsToSend.size() > 0){
            Messaging.sendEmail(mailsToSend);
            retrnMessage = 'Success';
        }
       
        return retrnMessage;     
    }
   @AuraEnabled
    public static list<AccountContactRelation> getContactRelation( String accIds, String roleType){
        system.debug(' ACC ID > '+accIds); 
        List<AccountContactRelation> accConRelationList = new List<AccountContactRelation>();
        //List<Contact> conList = new List<Contact>();
        String retrnMessage;
        List<String> contactRoleType = new List<String>();
        system.debug('Role Type >>> '+ roleType);
        if(roleType == 'Media Decision Maker'){
            contactRoleType.add('Media Budget Decision Maker');
        }else if(roleType == 'Primary/Secondray') {
            contactRoleType.add('Primary Contact');
            contactRoleType.add('Secondary contact');
        }else if(roleType == 'All Contacts'){
            contactRoleType.add('All');
        }
        
        
        
        Type idArrType = Type.forName('List<string>');
        List<string> wrapperList = new  List<string> ();
        if(!test.isRunningTest()){
            wrapperList = (List<string>) JSON.deserialize(accIds, idArrType);
        }
        else{
            String accId = accIds;
            wrapperList.add(accId);
        }
        
       
        if(contactRoleType.contains('All')){
            accConRelationList = [SELECT ContactID,Contact.Name,Contact.Email,Roles FROM AccountContactRelation WHERE AccountId IN:wrapperList order by Contact.Name];    
        }
        else if(contactRoleType.contains('Media Budget Decision Maker')){
            accConRelationList = [SELECT ContactID,Contact.Name,Contact.Email,Roles FROM AccountContactRelation Where Roles includes ('Media Budget Decision Maker') and AccountId IN:wrapperList order by Contact.Name];    
        }
        else{
            accConRelationList = [SELECT ContactID,Contact.Name,Contact.Email,Roles FROM AccountContactRelation Where Roles includes ('Primary Contact','Secondary contact') and AccountId IN:wrapperList order by Contact.Name];    
        }
        system.debug('account query >> '+accConRelationList);
         return accConRelationList;
    }
}