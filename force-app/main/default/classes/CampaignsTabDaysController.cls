public class CampaignsTabDaysController {
    @AuraEnabled
    public static List <Campaign_List_Item__c> getCheckbox(String campaignId){
        map<string,string> mapOfCheckboxField = new map<String,string>();
        map<string,Boolean> mapOfWCoopField = new map<String,Boolean>();
        DescribeSObjectResult describeResult = Campaign_List_Item__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query =    ' SELECT Campaigns__r.opportunity__c,'+String.join( fieldNames, ',') +' FROM Campaign_List_Item__c where Campaigns__c =: campaignId';
        List <Campaign_List_Item__c> obj =   Database.query( query ); 
        return obj;   
    }
    @AuraEnabled 
    public static List<Campaign_List_Item__c> saveCampaign(List<Campaign_List_Item__c> campaignRecord,string tab){
        update campaignRecord;
        String campListName ='';
        List<Campaign_List_Item__c>campItemList = new List<Campaign_List_Item__c>();
        set<Id> oppId = new set<Id>();
         list<Task> taskList = new list<Task>();
       
        BusinessHours defaultBH = [SELECT Id FROM BusinessHours WHERE IsDefault = true Limit 1];
        if(defaultBH != NULL){
            for(Campaign_List_Item__c camListObj : campaignRecord){
                oppId.add(camListObj.Campaigns__r.opportunity__c);
                //Making sure that closed date field is populated and is updated
                if(camListObj.Date_4__c != NULL && camListObj.Type__c == tab && tab != 'Standard' && camListObj.Date_3__c != null){
                    //For BH method we assign (BH record id, start time field, end time field)
                    decimal result = BusinessHours.diff(defaultBH.Id, camListObj.Date_3__c, camListObj.Date_4__c );
                    //Result from the method is divided by 60*60*100 (milliseconds to be then converted into hours)
                    Decimal resultingHours = result/(60*60*1000);
                    //Populating result into our custom field & setting number of decimals
                    //  camListObj.Spend_Time__c = resultingHours.setScale(1); 
                    if(resultingHours.setScale(1) > camListObj.SLA__c ){
                        campListName =  camListObj.Name__c +'<br>'+campListName  ;
                    }
                }
                if(camListObj.Type__c == tab && camListObj.Type__c != 'Standard' && camListObj.Date_3__c != null && camListObj.Task_Created__c == false ){
                   Integer sla= Integer.valueOf(camListObj.SLA__c/8);
                    Task tsk = new Task();
                    tsk.Subject = 'Campaign Task-'+camListObj.Name__c;
                    tsk.Priority = 'Normal';
                    tsk.ActivityDate = Date.valueOf(camListObj.Date_3__c).addDays(sla);
                    tsk.Status = 'Open';
                    tsk.OwnerId = camListObj.Account_Technician__c;
                    tsk.WhatId = camListObj.Account_Id__c;
                    taskList.add(tsk);
                    Campaign_List_Item__c obj = new Campaign_List_Item__c();
                    obj.Task_Created__c = true;
                    obj.Id = camListObj.Id;
                    campItemList.add(obj);
                }
            } 
            database.Insert(taskList,true);
            update campItemList;
           
        } 
        System.debug('=======oppId==='+ oppId.size());
        if(campListName != null && campListName != '' && oppId != null && !oppId.isEmpty() ){
            
            opportunity opp = new opportunity();
            opp = [select id,AccountId from opportunity where Id In:oppId limit 1]; 
            if(opp.AccountId != null ){
                Account acc = new Account();
                acc = [Select id,Name,Regional_performance_manager__c,Account_Technician__r.Name,Account_Technician__r.Email,Regional_performance_manager__r.Email  from Account where Id =: opp.AccountId ];
                String body =  '<html><body>Hi ' + acc.Account_Technician__r.Name + ',<br>This is a friendly reminder to activate the following campaign(s):<br>'+campListName+'<br>Please prioritize your tasks accordingly. <br><br>Foundation Support </body></html>';
                List<Messaging.SingleEmailMessage> masterListMails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                List<String> sendTo = new List<String>();
                if(acc.Account_Technician__r.Email != null && acc.Account_Technician__r.Email != ''){
                    sendTo.add(acc.Account_Technician__r.Email);
                }
                if(acc.Regional_performance_manager__r.Email != null && acc.Regional_performance_manager__r.Email != ''){
                    sendTo.add(acc.Regional_performance_manager__r.Email);
                }
                sendTo.add('support@info.foundationdirect.com');
                email.setToAddresses(sendTo);
                // Sets the paramaters of the email
                email.setSubject( acc.Name+' - SLA Breech' ); 
                email.setHtmlBody( body );
                
                // Add your email address into the master list
                masterListMails.add(email);
                Messaging.sendEmail(masterListMails);
            }
        }
        return campaignRecord;
    }
}