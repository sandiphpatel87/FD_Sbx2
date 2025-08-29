public class CampaignSendMailSLA_Batch implements Database.Batchable<sObject>, Schedulable{
    public Database.QueryLocator start(Database.BatchableContext bc) {
        DescribeSObjectResult describeResult = Campaign_List_Item__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query =    'SELECT Campaigns__r.opportunity__c,'+String.join( fieldNames, ',') +' FROM Campaign_List_Item__c where Send_Mail__c = false and Date_3__c != null';
        
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Campaign_List_Item__c> scope){
       
        set<Id> accId = new set<Id>();
        Map<account,list<Campaign_List_Item__c>> mapOfAccountCampainItem = new Map<account,list<Campaign_List_Item__c>>();
        for(Campaign_List_Item__c camListObj : scope){
            accId.add(camListObj.Account_Id__c);
        }
        if(accId != null ){
            list<Account> accList = new list<Account>();
            accList = [Select id,Name,Regional_performance_manager__c,Account_Technician__r.Name,Account_Technician__r.Email,Regional_performance_manager__r.Email  from Account where Id =: accId ];
            for(Account acc : accList){
                for(Campaign_List_Item__c camListObj1 : scope){
                    if(camListObj1.Account_Id__c == acc.Id){
                        if(mapOfAccountCampainItem.containsKey(acc)){
                            List<Campaign_List_Item__c> campItem = mapOfAccountCampainItem.get(acc);
                            campItem.add(camListObj1);
                            mapOfAccountCampainItem.put(acc, campItem);
                        }
                        else{
                            mapOfAccountCampainItem.put(acc,new List<Campaign_List_Item__c> {camListObj1}); 
                        }
                    }
                }
            }
        }
        list<Campaign_List_Item__c> updateCampItem = new List<Campaign_List_Item__c>();
        BusinessHours defaultBH = [SELECT Id FROM BusinessHours WHERE IsDefault = true Limit 1];
        if(defaultBH != NULL && scope != null){
            DateTime currentdt = DateTime.now();
            For(Account accObj : mapOfAccountCampainItem.keySet()){
                 String campListName ='';
                for(Campaign_List_Item__c camListObj : mapOfAccountCampainItem.get(accObj)){
                    if(camListObj.Date_3__c != null ){
                        Campaign_List_Item__c campItemNew = new Campaign_List_Item__c();
                        System.debug('==camListObj.Date_3__c==='+camListObj.Date_3__c);
                        System.debug('==currentdt==='+currentdt);
                        decimal result = BusinessHours.diff(defaultBH.Id, camListObj.Date_3__c, currentdt );
                        Decimal resultingHours = result/(60*60*1000);
                        if(resultingHours.setScale(1) > camListObj.SLA__c && camListObj.Type__c != 'Standard'){
                            campListName =  camListObj.Name__c +'<br>'+campListName  ;
                            campItemNew.Send_Mail__c = true;
                            campItemNew.id = camListObj.Id;
                            updateCampItem.add(campItemNew);
                        }
                    }
                }
                if(campListName != null && campListName != '' ){
                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'support@info.foundationdirect.com'];
                    String body =  '<html><body>Hi ' + accObj.Account_Technician__r.Name + ',<br>This is a friendly reminder to activate the following campaign(s):<br>'+campListName+'<br>Please prioritize your tasks accordingly <br><br>Foundation Support </body></html>';
                    List<Messaging.SingleEmailMessage> masterListMails = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                    List<String> sendTo = new List<String>();
                    if(accObj.Account_Technician__r.Email != null && accObj.Account_Technician__r.Email != ''){
                        sendTo.add(accObj.Account_Technician__r.Email);
                    }
                    if(accObj.Regional_performance_manager__r.Email != null && accObj.Regional_performance_manager__r.Email != ''){
                        sendTo.add(accObj.Regional_performance_manager__r.Email);
                    }
                    //sendTo.add(accObj.Account_Technician__r.Email);
                    //sendTo.add(accObj.Regional_performance_manager__r.Email);
                    email.setToAddresses(sendTo);
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                    // Sets the paramaters of the email
                    email.setSubject( accObj.Name+' - SLA Breech' ); 
                    email.setHtmlBody( body );
                    
                    // Add your email address into the master list
                    masterListMails.add(email);
                    Messaging.sendEmail(masterListMails);
                }
            }
        }
        database.update(updateCampItem);
    }
    public void finish(Database.BatchableContext bc){
        
    }
    public void execute(SchedulableContext sc) {
        CampaignSendMailSLA_Batch batch = new CampaignSendMailSLA_Batch(); 
        database.executebatch(batch,50);
    }
}