trigger OnboardingTrigger on Onboarding__c (before insert,before update, after update, after insert) {
    
    if(Trigger.isUpdate && Trigger.isAfter){ 
        if(OnboardingTriggerHandler.isFirstTime)
        {
            OnboardingTriggerHandler.isFirstTime = false;
            OnboardingTriggerHandler.AfterUpdateOnboardingFieldOfSameAccount(Trigger.old,Trigger.new,Trigger.oldMap,Trigger.newMap);
        }
    }
    
    if(Trigger.IsBefore && Trigger.IsInsert){
        set<Id> oppId = new set<Id>();
        for(Onboarding__c obj: Trigger.new){
            oppId.add(obj.Opportunity__c);
        }
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
        for(Opportunity opp : [Select Id,Name, (Select Id from Onboardings__r where Active__c = true ) from Opportunity where Id in :oppId]){
            oppMap.put(opp.Id,opp);
        }
        System.debug('==oppMap==='+oppMap);
        
        for(Onboarding__c obj: Trigger.new){
            if(oppMap.containsKey(obj.Opportunity__c)){
                if(oppMap.get(obj.Opportunity__c).Onboardings__r != null && oppMap.get(obj.Opportunity__c).Onboardings__r.size()>0){// If greater than 0, throw error
                    System.debug('====='+oppMap.get(obj.Opportunity__c).Onboardings__r);
                    //obj.addError('There is already active onboarding for this '+ oppMap.get(obj.Opportunity__c).Name +' opportunity. Please inactive current onboarding record and try again' );
                }
            }
        }
        
    }
    if(Trigger.isInsert && Trigger.isAfter){
        set<Account> accIdHyundai = new set<Account>();
        for(Onboarding__c obj :trigger.new){
            if(obj.Hyundai_Coop__c == true && obj.Account__c != null){
                Account acc = new Account();
                acc.Id = obj.Account__c;
                acc.Hyundai_Coop__c = obj.Hyundai_Coop__c;
                accIdHyundai.add(acc);
            }
        }
        if(accIdHyundai != null && !accIdHyundai.isEmpty()){
            database.update(new list<Account>(accIdHyundai),false);
        }
        
    }
    if(Trigger.isUpdate && Trigger.isBefore){
        for(Onboarding__c obj : Trigger.new){
            String followUp = '';
            String ATFollowUp ='';
            if(Trigger.newMap.get(obj.Id).Facebook_Request_Sent__c != Trigger.OldMap.get(obj.Id).Facebook_Request_Sent__c && obj.Facebook_Request_Sent__c == 'Needs Followup'){
                followUp = 'Facebook Request Sent';
            }
            if(Trigger.newMap.get(obj.Id).Facebook_Request_Accepted__c != Trigger.OldMap.get(obj.Id).Facebook_Request_Accepted__c && obj.Facebook_Request_Accepted__c == 'Needs Followup'){
                followUp = 'Facebook Request Accepted'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).GMB_Request_Sent__c != Trigger.OldMap.get(obj.Id).GMB_Request_Sent__c && obj.GMB_Request_Sent__c == 'Needs Followup'){
                followUp = 'GMB Request Sent'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).GMB_Request_Received__c != Trigger.OldMap.get(obj.Id).GMB_Request_Received__c && obj.GMB_Request_Received__c== 'Needs Followup'){
                followUp = 'GMB Request Received'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Turn_Sitelinks_Off_in_Apollo__c != Trigger.OldMap.get(obj.Id).Turn_Sitelinks_Off_in_Apollo__c && obj.Turn_Sitelinks_Off_in_Apollo__c == 'Needs Followup'){
                followUp = 'Turn Sitelinks Off in Apollo'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Add_Sitelinks_to_Google_Ads__c != Trigger.OldMap.get(obj.Id).Add_Sitelinks_to_Google_Ads__c && obj.Add_Sitelinks_to_Google_Ads__c == 'Needs Followup'){
                followUp = 'Add Sitelinks to Google Ads'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Zipcodes_Received__c != Trigger.OldMap.get(obj.Id).Zipcodes_Received__c && obj.Zipcodes_Received__c == 'Needs Followup'){
                followUp = 'Zipcodes Received'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Budgets_Confirmed__c != Trigger.OldMap.get(obj.Id).Budgets_Confirmed__c && obj.Budgets_Confirmed__c == 'Needs Followup'){
                followUp = 'Budgets Confirmed'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Budgets_Updated_in_Apollo__c != Trigger.OldMap.get(obj.Id).Budgets_Updated_in_Apollo__c && obj.Budgets_Updated_in_Apollo__c == 'Needs Followup'){
                followUp = 'Budgets Updated in Apollo'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Schedule_Kickoff_Call__c != Trigger.OldMap.get(obj.Id).Schedule_Kickoff_Call__c && obj.Schedule_Kickoff_Call__c == 'Needs Followup'){
                followUp = 'Schedule Kickoff Call'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Send_Geo_targeting_for_Approval__c != Trigger.OldMap.get(obj.Id).Send_Geo_targeting_for_Approval__c && obj.Send_Geo_targeting_for_Approval__c == 'Needs Followup'){
                followUp = 'Send Geo-targeting for Client Approval'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Send_Advertised_Payments_for_Approval__c != Trigger.OldMap.get(obj.Id).Send_Advertised_Payments_for_Approval__c && obj.Send_Advertised_Payments_for_Approval__c == 'Needs Followup'){
                followUp = 'Send Ad Payments for Client Approval'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Confirm_Launch_Date_with_Client__c != Trigger.OldMap.get(obj.Id).Confirm_Launch_Date_with_Client__c && obj.Confirm_Launch_Date_with_Client__c == 'Needs Followup'){
                followUp = 'Confirm Launch Date with Client'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Verify_Inventory_Pricing__c    != Trigger.OldMap.get(obj.Id).Verify_Inventory_Pricing__c   && obj.Verify_Inventory_Pricing__c  == 'Needs Followup'){
                followUp = 'Verify Inventory Pricing'+','+followUp;
            } 
            /*if(Trigger.newMap.get(obj.Id).Inventory_Ordered__c != Trigger.OldMap.get(obj.Id).Inventory_Ordered__c && obj.Inventory_Ordered__c == 'Needs Followup'){
followUp = 'Inventory Ordered'+','+followUp;
} */
            if(Trigger.newMap.get(obj.Id).OnboardingPackSent__c != Trigger.OldMap.get(obj.Id).OnboardingPackSent__c && obj.OnboardingPackSent__c == 'Needs Followup'){
                followUp = 'Onboarding Pack Sent'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Onboarding_Pack_Received__c != Trigger.OldMap.get(obj.Id).Onboarding_Pack_Received__c && obj.Onboarding_Pack_Received__c == 'Needs Followup'){
                followUp = 'Onboarding Pack Received'+','+followUp;
            }
            if(Trigger.newMap.get(obj.Id).Create_Google_Account__c != Trigger.OldMap.get(obj.Id).Create_Google_Account__c && obj.Create_Google_Account__c == 'Needs Followup'){
                followUp = 'Create Google Account'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Create_Bing_Account__c != Trigger.OldMap.get(obj.Id).Create_Bing_Account__c && obj.Create_Bing_Account__c == 'Needs Followup'){
                followUp = 'Create Bing Account'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Create_Facebook_Account__c != Trigger.OldMap.get(obj.Id).Create_Facebook_Account__c && obj.Create_Facebook_Account__c == 'Needs Followup'){
                followUp = 'Create Facebook Account'+','+followUp;
            } 
            /*if(Trigger.newMap.get(obj.Id).CreditCardAuthSent__c != Trigger.OldMap.get(obj.Id).CreditCardAuthSent__c && obj.CreditCardAuthSent__c == 'Needs Followup'){
followUp = 'Credit Card Auth Sent'+','+followUp;
} 
if(Trigger.newMap.get(obj.Id).Credit_Card_Received__c != Trigger.OldMap.get(obj.Id).Credit_Card_Received__c && obj.Credit_Card_Received__c == 'Needs Followup'){
followUp = 'Credit Card Received'+','+followUp;
} */
            if(Trigger.newMap.get(obj.Id).Add_CC_to_Google__c    != Trigger.OldMap.get(obj.Id).Add_CC_to_Google__c   && obj.Add_CC_to_Google__c  == 'Needs Followup'){
                followUp = 'Add CC to Google'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Add_CC_to_Bing__c != Trigger.OldMap.get(obj.Id).Add_CC_to_Bing__c && obj.Add_CC_to_Bing__c == 'Needs Followup'){
                followUp = 'Add CC to Bing'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Add_CC_to_Facebook__c != Trigger.OldMap.get(obj.Id).Add_CC_to_Facebook__c && obj.Add_CC_to_Facebook__c == 'Needs Followup'){
                followUp = 'Add CC to Facebook'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Logo_Received__c != Trigger.OldMap.get(obj.Id).Logo_Received__c && obj.Logo_Received__c == 'Needs Followup'){
                followUp = 'Logo Received'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Logo_added_to_Compliance_Board__c != Trigger.OldMap.get(obj.Id).Logo_added_to_Compliance_Board__c && obj.Logo_added_to_Compliance_Board__c == 'Needs Followup'){
                followUp = 'Logo Added to Compliance Board'+','+followUp;
            } 
            if(Trigger.newMap.get(obj.Id).Logo_approved_by_Compliance_Team__c != Trigger.OldMap.get(obj.Id).Logo_approved_by_Compliance_Team__c && obj.Logo_approved_by_Compliance_Team__c == 'Needs Followup'){
                followUp = 'Logo Approved by Compliance Team'+','+followUp;
            }
            if(Trigger.newMap.get(obj.Id).Link_GMB_for_Location_Extenstions__c != Trigger.OldMap.get(obj.Id).Link_GMB_for_Location_Extenstions__c && obj.Link_GMB_for_Location_Extenstions__c == 'Needs Followup'){
                followUp = 'Link GMB for Location Extenstions'+','+followUp;
            }
            if(Trigger.newMap.get(obj.Id).Add_to_Measurement_Trix__c != Trigger.OldMap.get(obj.Id).Add_to_Measurement_Trix__c && obj.Add_to_Measurement_Trix__c == 'Needs Followup'){
                followUp = 'Add to Measurement Trix'+','+followUp;
            }
            
            //=================================AT follow up
            if(Trigger.newMap.get(obj.Id).Facebook_Request_Sent__c != Trigger.OldMap.get(obj.Id).Facebook_Request_Sent__c && obj.Facebook_Request_Sent__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Facebook Request Sent';
            }
            if(Trigger.newMap.get(obj.Id).Facebook_Request_Accepted__c != Trigger.OldMap.get(obj.Id).Facebook_Request_Accepted__c && obj.Facebook_Request_Accepted__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Facebook Request Accepted'+','+ATFollowUp ;
            } 
            if(Trigger.newMap.get(obj.Id).GMB_Request_Sent__c != Trigger.OldMap.get(obj.Id).GMB_Request_Sent__c && obj.GMB_Request_Sent__c == 'Needs AT Follow Up'){
                ATFollowUp = 'GMB Request Sent'+','+ATFollowUp ;
            } 
            if(Trigger.newMap.get(obj.Id).GMB_Request_Received__c != Trigger.OldMap.get(obj.Id).GMB_Request_Received__c && obj.GMB_Request_Received__c== 'Needs AT Follow Up'){
                ATFollowUp = 'GMB Request Received'+','+ATFollowUp ;
            } 
            if(Trigger.newMap.get(obj.Id).Turn_Sitelinks_Off_in_Apollo__c != Trigger.OldMap.get(obj.Id).Turn_Sitelinks_Off_in_Apollo__c && obj.Turn_Sitelinks_Off_in_Apollo__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Turn Sitelinks Off in Apollo'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Add_Sitelinks_to_Google_Ads__c != Trigger.OldMap.get(obj.Id).Add_Sitelinks_to_Google_Ads__c && obj.Add_Sitelinks_to_Google_Ads__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Add Sitelinks to Google Ads'+','+ATFollowUp ;
            } 
            if(Trigger.newMap.get(obj.Id).Zipcodes_Received__c != Trigger.OldMap.get(obj.Id).Zipcodes_Received__c && obj.Zipcodes_Received__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Zipcodes Received'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Budgets_Confirmed__c != Trigger.OldMap.get(obj.Id).Budgets_Confirmed__c && obj.Budgets_Confirmed__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Budgets Confirmed'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Budgets_Updated_in_Apollo__c != Trigger.OldMap.get(obj.Id).Budgets_Updated_in_Apollo__c && obj.Budgets_Updated_in_Apollo__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Budgets Updated in Apollo'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Schedule_Kickoff_Call__c != Trigger.OldMap.get(obj.Id).Schedule_Kickoff_Call__c && obj.Schedule_Kickoff_Call__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Schedule Kickoff Call'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Send_Geo_targeting_for_Approval__c != Trigger.OldMap.get(obj.Id).Send_Geo_targeting_for_Approval__c && obj.Send_Geo_targeting_for_Approval__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Send Geo-targeting for Client Approval'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Send_Advertised_Payments_for_Approval__c != Trigger.OldMap.get(obj.Id).Send_Advertised_Payments_for_Approval__c && obj.Send_Advertised_Payments_for_Approval__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Send Ad Payments for Client Approval'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Confirm_Launch_Date_with_Client__c != Trigger.OldMap.get(obj.Id).Confirm_Launch_Date_with_Client__c && obj.Confirm_Launch_Date_with_Client__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Confirm Launch Date with Client'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Verify_Inventory_Pricing__c    != Trigger.OldMap.get(obj.Id).Verify_Inventory_Pricing__c   && obj.Verify_Inventory_Pricing__c  == 'Needs AT Follow Up'){
                ATFollowUp = 'Verify Inventory Pricing'+','+ATFollowUp;
            } 
            /*if(Trigger.newMap.get(obj.Id).Inventory_Ordered__c != Trigger.OldMap.get(obj.Id).Inventory_Ordered__c && obj.Inventory_Ordered__c == 'Needs AT Follow Up'){
ATFollowUp = 'Inventory Ordered'+','+ATFollowUp;
} */
            if(Trigger.newMap.get(obj.Id).OnboardingPackSent__c != Trigger.OldMap.get(obj.Id).OnboardingPackSent__c && obj.OnboardingPackSent__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Onboarding Pack Sent'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Onboarding_Pack_Received__c != Trigger.OldMap.get(obj.Id).Onboarding_Pack_Received__c && obj.Onboarding_Pack_Received__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Onboarding Pack Received'+','+ATFollowUp;
            }
            if(Trigger.newMap.get(obj.Id).Create_Google_Account__c != Trigger.OldMap.get(obj.Id).Create_Google_Account__c && obj.Create_Google_Account__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Create Google Account'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Create_Bing_Account__c != Trigger.OldMap.get(obj.Id).Create_Bing_Account__c && obj.Create_Bing_Account__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Create Bing Account'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Create_Facebook_Account__c != Trigger.OldMap.get(obj.Id).Create_Facebook_Account__c && obj.Create_Facebook_Account__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Create Facebook Account'+','+ATFollowUp;
            } 
            /*if(Trigger.newMap.get(obj.Id).CreditCardAuthSent__c != Trigger.OldMap.get(obj.Id).CreditCardAuthSent__c && obj.CreditCardAuthSent__c == 'Needs AT Follow Up'){
ATFollowUp = 'Credit Card Auth Sent'+','+ATFollowUp;
} 
if(Trigger.newMap.get(obj.Id).Credit_Card_Received__c != Trigger.OldMap.get(obj.Id).Credit_Card_Received__c && obj.Credit_Card_Received__c == 'Needs AT Follow Up'){
ATFollowUp = 'Credit Card Received'+','+ATFollowUp;
} */
            if(Trigger.newMap.get(obj.Id).Add_CC_to_Google__c    != Trigger.OldMap.get(obj.Id).Add_CC_to_Google__c   && obj.Add_CC_to_Google__c  == 'Needs AT Follow Up'){
                ATFollowUp = 'Add CC to Google'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Add_CC_to_Bing__c != Trigger.OldMap.get(obj.Id).Add_CC_to_Bing__c && obj.Add_CC_to_Bing__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Add CC to Bing'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Add_CC_to_Facebook__c != Trigger.OldMap.get(obj.Id).Add_CC_to_Facebook__c && obj.Add_CC_to_Facebook__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Add CC to Facebook'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Logo_Received__c != Trigger.OldMap.get(obj.Id).Logo_Received__c && obj.Logo_Received__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Logo Received'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Logo_added_to_Compliance_Board__c != Trigger.OldMap.get(obj.Id).Logo_added_to_Compliance_Board__c && obj.Logo_added_to_Compliance_Board__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Logo Added to Compliance Board'+','+ATFollowUp;
            } 
            if(Trigger.newMap.get(obj.Id).Logo_approved_by_Compliance_Team__c != Trigger.OldMap.get(obj.Id).Logo_approved_by_Compliance_Team__c && obj.Logo_approved_by_Compliance_Team__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Logo Approved by Compliance Team'+','+ATFollowUp;
            }
            if(Trigger.newMap.get(obj.Id).Link_GMB_for_Location_Extenstions__c != Trigger.OldMap.get(obj.Id).Link_GMB_for_Location_Extenstions__c && obj.Link_GMB_for_Location_Extenstions__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Link GMB for Location Extenstions'+','+ATFollowUp;
            }
            if(Trigger.newMap.get(obj.Id).Add_to_Measurement_Trix__c != Trigger.OldMap.get(obj.Id).Add_to_Measurement_Trix__c && obj.Add_to_Measurement_Trix__c == 'Needs AT Follow Up'){
                ATFollowUp = 'Add to Measurement Trix'+','+ATFollowUp;
            }
            if(ATFollowUp.right(1) == ','){
                ATFollowUp =  ATFollowUp.removeEnd(',');
            }
            if(followUp.right(1) == ','){
                followUp =  followUp.removeEnd(',');
            }
            if(ATFollowUp.length() > 255){
                obj.AT_Follow_Up__c = ATFollowUp.substring(0,254);
            }
            else {
                obj.AT_Follow_Up__c = ATFollowUp;
            }
            if(followUp.length() > 255){
                obj.Follow_up_fields__c = followUp.substring(0,254);
            }
            else{
                obj.Follow_up_fields__c = followUp;
            }
            
        }
    }
    if(Trigger.isUpdate && Trigger.isAfter){
        list<Id> accId = new list<Id>();
        set<Account> accIdHyundai = new set<Account>();
        for(Onboarding__c obj :trigger.new){
            if(trigger.newMap.get(obj.Id).Confirm_Launch_Date_with_Client__c != trigger.oldMap.get(obj.Id).Confirm_Launch_Date_with_Client__c && trigger.newMap.get(obj.Id).Confirm_Launch_Date_with_Client__c == 'Completed'){
                accId.add(obj.Account__c);
            }
            if(trigger.newMap.get(obj.Id).Hyundai_Coop__c  != trigger.oldMap.get(obj.Id).Hyundai_Coop__c && obj.Account__c != null){
                Account acc = new Account();
                acc.Id = obj.Account__c;
                acc.Hyundai_Coop__c = obj.Hyundai_Coop__c;
                accIdHyundai.add(acc);
            }
        }
        if(accIdHyundai != null && !accIdHyundai.isEmpty()){
            database.update(new list<Account>(accIdHyundai),false);
        }
        if(accId != null && !accId.isEmpty()){
            List<Task> tskList = [select id,Status from task where WhatId In: accId and subject ='Confirm Launch Date and Details'];
            for(Task tskObj :tskList ){
                tskObj.Status = 'Completed';
            }
            update tskList;
        }
    }
    
}