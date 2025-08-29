public class OnboardingFieldUpdateBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator  start(Database.BatchableContext bc) {
        String onBoardingList;
        Map<String, Schema.SObjectField> fieldMap = Onboarding__c.sObjectType.getDescribe().fields.getMap();
        Set<String> setFieldNames = fieldMap.keySet();
        list<String> lstFieldNames = new List<String>(setFieldNames);
        
        onBoardingList = 'SELECT '+ String.join(lstFieldNames, ',') +  ' FROM Onboarding__c' ;
        return   Database.getQueryLocator(onBoardingList);
    }
    public void execute(Database.BatchableContext bc, List<Onboarding__c> scope){
        System.debug('======'+scope);
        for(Onboarding__c obj :scope){
            if(obj.Add_CC_to_Google__c != 'Not Started' && obj.Add_CC_to_Google__c != null){
                obj.Add_CC_to_Google1__c = true;
            }
            if(obj.Add_CC_to_Bing__c != 'Not Started' && obj.Add_CC_to_Bing__c != null){
                obj.Add_CC_to_Bing1__c = true;
            }
            if(obj.Add_CC_to_Facebook__c != 'Not Started' && obj.Add_CC_to_Facebook__c != null){
                obj.Add_CC_to_Facebook1__c = true;
            }
             if(obj.Logo_Received__c != 'Not Started' && obj.Logo_Received__c != null){
                obj.Logo_Received1__c = true;
            }
            if(obj.Logo_added_to_Compliance_Board__c != 'Not Started' && obj.Logo_added_to_Compliance_Board__c !=  null){
                obj.Logo_Added_to_Compliance_Board1__c = true;
            }
            if(obj.Logo_approved_by_Compliance_Team__c != 'Not Started' && obj.Logo_approved_by_Compliance_Team__c != null){
                obj.Logo_Approved_by_Compliance_Team1__c = true;
            }
            if(obj.Link_GMB_for_Location_Extenstions__c != 'Not Started' && obj.Link_GMB_for_Location_Extenstions__c !=  null){
                obj.Link_GMB_for_Location_Extensions1__c = true;
            }
             if(obj.Turn_Sitelinks_Off_in_Apollo__c != 'Not Started' && obj.Turn_Sitelinks_Off_in_Apollo__c != null ){
                obj.Turn_Sitelinks_Off_in_Apollo1__c = true;
            }
            if(obj.Add_Sitelinks_to_Google_Ads__c != 'Not Started' && obj.Add_Sitelinks_to_Google_Ads__c != null ){
                obj.Add_Sitelinks_to_Google_Ads1__c = true;
            }
            if(obj.Disable__c != 'Not Started' && obj.Disable__c != null){
                obj.Disable_Google_Recommendations1__c = true; 
            }
            if(obj.Customize_Client_Notification_Settings__c != 'Not Started' && obj.Customize_Client_Notification_Settings__c != null){
                obj.Customize_Client_Notification_Settings1__c = true; 
            }
            if(obj.Enable_Auto_Tagging__c != 'Not Started' && obj.Enable_Auto_Tagging__c != null){
                obj.Enable_Auto_Tagging1__c = true; 
            }
            if(obj.Link_GA_Account__c != 'Not Started' && obj.Link_GA_Account__c != null){
                obj.Link_GA_Account1__c = true; 
            }
            if(obj.Zipcodes_Received__c != 'Not Started' && obj.Zipcodes_Received__c != null){
                obj.Zipcodes_Received1__c = true;
            }
             if(obj.Budgets_Confirmed__c != 'Not Started' && obj.Budgets_Confirmed__c != null){
                obj.Budgets_Confirmed1__c = true;
            }
             if(obj.Budgets_Updated_in_Apollo__c != 'Not Started' && obj.Budgets_Updated_in_Apollo__c != null){
                obj.Budgets_Updated_in_Apollo1__c = true;
            }
             if(obj.Schedule_Kickoff_Call__c != 'Not Started' && obj.Schedule_Kickoff_Call__c != null){
                obj.Schedule_Kickoff_Call1__c = true;
            }
             if(obj.Send_Geo_targeting_for_Approval__c != 'Not Started' && obj.Send_Geo_targeting_for_Approval__c !=  null){
                obj.Send_Geo_targeting_for_Client_Approval1__c = true;
            }
            if(obj.Send_Advertised_Payments_for_Approval__c != 'Not Started' && obj.Send_Advertised_Payments_for_Approval__c !=  null){
                obj.Send_Ad_Payments_for_Client_Approval1__c = true;
            }
            if(obj.Confirm_Launch_Date_with_Client__c != 'Not Started' && obj.Confirm_Launch_Date_with_Client__c != null){
                obj.Confirm_Launch_Date_with_Client1__c = true;
            }
            if(obj.OnboardingPackSent__c != 'Not Started' && obj.OnboardingPackSent__c != null){
                obj.Onboarding_Pack_Sent1__c = true; 
            }
            if(obj.Onboarding_Pack_Received__c != 'Not Started' && obj.Onboarding_Pack_Received__c != null){
                obj.Onboarding_Pack_Received1__c = true; 
            }
            /*if(obj.CreditCardAuthSent__c != 'Not Started' && obj.CreditCardAuthSent__c != null){
                obj.Credit_Card_Auth_Sent1__c = true; 
            }
           if(obj.Credit_Card_Received__c != 'Not Started' && obj.Credit_Card_Received__c != null){
                obj.Credit_Card_Received1__c = true; 
            }*/
            /* if(obj.Inventory_Ordered__c != 'Not Started' && obj.Inventory_Ordered__c !=null){
                obj.Inventory_Ordered1__c = true;
            }*/
            if(obj.Verify_Inventory_Pricing__c != 'Not Started' && obj.Verify_Inventory_Pricing__c !=  null){
                obj.Verify_Inventory_Pricing1__c = true;
            }
            if(obj.Service__c != 'Not Started' && obj.Service__c !=  null){
                obj.Input_Service_Coupons1__c = true;
            }
             if(obj.Secure_Admin_Account_Access__c != 'Not Started' && obj.Secure_Admin_Account_Access__c !=  null){
                obj.Secure_Admin_Account_Access1__c = true;
            }
            if(obj.Secure_Payment_Profile_Access__c != 'Not Started' && obj.Secure_Payment_Profile_Access__c !=  null){
                obj.Secure_Payment_Profile_Access1__c = true;
            }
            
            if(obj.Facebook_Request_Sent__c != 'Not Started' && obj.Facebook_Request_Sent__c != null){
                obj.Facebook_Request_Sent1__c = true ;
            }
            if(obj.Facebook_Request_Accepted__c != 'Not Started' && obj.Facebook_Request_Accepted__c != null){
                obj.Facebook_Request_Accepted1__c = true;
            }
            if(obj.GMB_Request_Sent__c != 'Not Started' && obj.GMB_Request_Sent__c != null){
                obj.GMB_Request_Sent1__c = true;
            }
            if(obj.GMB_Request_Received__c != 'Not Started' && obj.GMB_Request_Received__c != null){
                obj.GMB_Request_Accepted1__c = true;
            }
             if(obj.Create_Google_Account__c != 'Not Started' && obj.Create_Google_Account__c != null){
                obj.Create_Google_Account1__c = true;
            }
             if(obj.Create_Bing_Account__c != 'Not Started' && obj.Create_Bing_Account__c != null){
                obj.Create_Bing_Account1__c = true;
            }
             if(obj.Create_Facebook_Account__c != 'Not Started' && obj.Create_Facebook_Account__c != null){
                obj.Create_Facebook_Account1__c = true;
            }
        
        }
        update scope;
    }
    public void finish(Database.BatchableContext bc){
    }
}