public class OnboardingCheckList {
    public String objId{get;set;}
   // public String followUp{get;set;}
    public String getFollowUp(){
        System.debug('==objId=='+objId);
        String followUp ='';
        
        String SobjectApiName = 'Onboarding__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset()){
            if(commaSepratedFields == null || commaSepratedFields == ''){
                commaSepratedFields = fieldName;
            }else{
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        } 
        String query;
        if(!Test.isRunningTest()){
         query = 'select ' + commaSepratedFields + ' from Onboarding__c where Id =: objId limit 1';
        }
        else{
          query = 'select ' + commaSepratedFields + ' from Onboarding__c  limit 1';   
        }
        list<Onboarding__c> onnbordingList = Database.query(query);
        System.debug('===onnbordingList=='+onnbordingList);
        Onboarding__c obj = new  Onboarding__c();
        if(onnbordingList != null && !onnbordingList.isEmpty()){
            obj = onnbordingList[0];
        }
        followUp = '';
        
        if(obj.Facebook_Request_Sent__c != 'Not Applicable' && obj.Facebook_Request_Sent__c != 'Completed' && obj.Facebook_Request_Sent__c != null){
            followUp = 'Facebook Request Sent - '+obj.Facebook_Request_Sent__c;
        }
        if(obj.Facebook_Request_Accepted__c != 'Not Applicable' && obj.Facebook_Request_Accepted__c != 'Completed' && obj.Facebook_Request_Accepted__c != null){
            followUp = 'Facebook Request Accepted - '+obj.Facebook_Request_Accepted__c+'\n'+followUp;
        } 
        if(obj.GMB_Request_Sent__c != 'Not Applicable' && obj.GMB_Request_Sent__c != 'Completed' && obj.GMB_Request_Sent__c != null){
            followUp = 'GMB Request Sent - '+obj.GMB_Request_Sent__c+'\n'+followUp;
        } 
        if(obj.GMB_Request_Received__c != 'Not Applicable' && obj.GMB_Request_Received__c != 'Completed' && obj.GMB_Request_Received__c != null){
            followUp = 'GMB Request Received - '+obj.GMB_Request_Received__c+'\n'+followUp;
        } 
        if(obj.Turn_Sitelinks_Off_in_Apollo__c != 'Not Applicable' && obj.Turn_Sitelinks_Off_in_Apollo__c != 'Completed' && obj.Turn_Sitelinks_Off_in_Apollo__c != null){
            followUp = 'Turn Sitelinks Off in Apollo - '+obj.Turn_Sitelinks_Off_in_Apollo__c+'\n'+followUp;
        } 
        if(obj.Add_Sitelinks_to_Google_Ads__c != 'Not Applicable' && obj.Add_Sitelinks_to_Google_Ads__c != 'Completed'  && obj.Add_Sitelinks_to_Google_Ads__c != null){
            followUp = 'Add Sitelinks to Google Ads - '+obj.Add_Sitelinks_to_Google_Ads__c+'\n'+followUp;
        } 
        if(obj.Zipcodes_Received__c != 'Not Applicable' && obj.Zipcodes_Received__c != 'Completed' && obj.Zipcodes_Received__c != null){
            followUp = 'Zipcodes Received - '+obj.Zipcodes_Received__c+'\n'+followUp;
        } 
        if(obj.Budgets_Confirmed__c != 'Not Applicable' && obj.Budgets_Confirmed__c != 'Completed' && obj.Budgets_Confirmed__c != null){
            followUp = 'Budgets Confirmed - '+obj.Budgets_Confirmed__c+'\n'+followUp;
        } 
        if(obj.Budgets_Updated_in_Apollo__c != 'Not Applicable' && obj.Budgets_Updated_in_Apollo__c != 'Completed' && obj.Budgets_Updated_in_Apollo__c != null){
            followUp = 'Budgets Updated in Apollo - '+obj.Budgets_Updated_in_Apollo__c+'\n'+followUp;
        } 
        if(obj.Schedule_Kickoff_Call__c != 'Not Applicable' && obj.Schedule_Kickoff_Call__c != 'Completed' && obj.Schedule_Kickoff_Call__c != null){
            followUp = 'Schedule Kickoff Call - '+obj.Schedule_Kickoff_Call__c +'\n'+followUp;
        } 
        if(obj.Send_Geo_targeting_for_Approval__c != 'Not Applicable' && obj.Send_Geo_targeting_for_Approval__c != 'Completed' && obj.Send_Geo_targeting_for_Approval__c != null){
            followUp = 'Send Geo-targeting for Client Approval - '+obj.Send_Geo_targeting_for_Approval__c+'\n'+followUp;
        } 
        if(obj.Send_Advertised_Payments_for_Approval__c != 'Not Applicable' && obj.Send_Advertised_Payments_for_Approval__c != 'Completed' && obj.Send_Advertised_Payments_for_Approval__c != null){
            followUp = 'Send Ad Payments for Client Approval - '+obj.Send_Advertised_Payments_for_Approval__c+'\n'+followUp;
        } 
        if(obj.Confirm_Launch_Date_with_Client__c != 'Not Applicable' && obj.Confirm_Launch_Date_with_Client__c != 'Completed' && obj.Confirm_Launch_Date_with_Client__c != null){
            followUp = 'Confirm Launch Date with Client - '+obj.Confirm_Launch_Date_with_Client__c+'\n'+followUp;
        } 
        if(obj.Verify_Inventory_Pricing__c != 'Not Applicable'  && obj.Verify_Inventory_Pricing__c  != 'Completed' && obj.Verify_Inventory_Pricing__c  != null){
            followUp = 'Verify Inventory Pricing - '+obj.Verify_Inventory_Pricing__c+'\n'+followUp;
        } 
      /*  if(obj.Inventory_Ordered__c  != 'Not Applicable' && obj.Inventory_Ordered__c != 'Completed' && obj.Inventory_Ordered__c != null){
            followUp = 'Inventory Ordered - '+obj.Inventory_Ordered__c+'\n'+followUp;
        } */
        if(obj.OnboardingPackSent__c != 'Not Applicable' && obj.OnboardingPackSent__c != 'Completed' && obj.OnboardingPackSent__c != null){
            followUp = 'Onboarding Pack Sent - '+obj.OnboardingPackSent__c+'\n'+followUp;
        } 
        if(obj.Onboarding_Pack_Received__c != 'Not Applicable' && obj.Onboarding_Pack_Received__c != 'Completed' && obj.Onboarding_Pack_Received__c != null){
            followUp = 'Onboarding Pack Received - '+obj.Onboarding_Pack_Received__c+'\n'+followUp;
        }
        if(obj.Create_Google_Account__c != 'Not Applicable' && obj.Create_Google_Account__c != 'Completed' && obj.Create_Google_Account__c != null){
            followUp = 'Create Google Account - '+obj.Create_Google_Account__c+'\n'+followUp;
        } 
        if(obj.Create_Bing_Account__c != 'Not Applicable' && obj.Create_Bing_Account__c != 'Completed' && obj.Create_Bing_Account__c != null){
            followUp = 'Create Bing Account - '+obj.Create_Bing_Account__c+'\n'+followUp;
        } 
        if(obj.Create_Facebook_Account__c != 'Not Applicable' && obj.Create_Facebook_Account__c != 'Completed' && obj.Create_Facebook_Account__c != null){
            followUp = 'Create Facebook Account - '+obj.Create_Facebook_Account__c+'\n'+followUp;
        } 
        /*if(obj.CreditCardAuthSent__c != 'Not Applicable' && obj.CreditCardAuthSent__c != 'Completed' && obj.CreditCardAuthSent__c != null){
            followUp = 'Credit Card Auth Sent - '+obj.CreditCardAuthSent__c+'\n'+followUp;
        } 
        if(obj.Credit_Card_Received__c != 'Not Applicable' && obj.Credit_Card_Received__c != 'Completed' && obj.Credit_Card_Received__c != null){
            followUp = 'Credit Card Received - '+obj.Credit_Card_Received__c+'\n'+followUp;
        } */
        if(obj.Add_CC_to_Google__c != 'Not Applicable'  && obj.Add_CC_to_Google__c  != 'Completed' && obj.Add_CC_to_Google__c  != null){
            followUp = 'Add CC to Google - '+obj.Add_CC_to_Google__c+'\n'+followUp;
        } 
        if(obj.Add_CC_to_Bing__c != 'Not Applicable' && obj.Add_CC_to_Bing__c != 'Completed' && obj.Add_CC_to_Bing__c != null){
            followUp = 'Add CC to Bing - '+obj.Add_CC_to_Bing__c+'\n'+followUp;
        } 
        if(obj.Add_CC_to_Facebook__c != 'Not Applicable' && obj.Add_CC_to_Facebook__c != 'Completed' && obj.Add_CC_to_Facebook__c != null){
            followUp = 'Add CC to Facebook - '+obj.Add_CC_to_Facebook__c+'\n'+followUp;
        } 
        if(obj.Logo_Received__c  != 'Not Applicable' && obj.Logo_Received__c != 'Completed' && obj.Logo_Received__c != null){
            followUp = 'Logo Received - '+obj.Logo_Received__c+'\n'+followUp;
        } 
        if(obj.Logo_added_to_Compliance_Board__c != 'Not Applicable' && obj.Logo_added_to_Compliance_Board__c != 'Completed' && obj.Logo_added_to_Compliance_Board__c != null){
            followUp = 'Logo Added to Compliance Board - '+obj.Logo_added_to_Compliance_Board__c+'\n'+followUp;
        } 
        if(obj.Logo_approved_by_Compliance_Team__c != 'Not Applicable' && obj.Logo_approved_by_Compliance_Team__c != 'Completed' && obj.Logo_approved_by_Compliance_Team__c != null){
            followUp = 'Logo Approved by Compliance Team - '+obj.Logo_approved_by_Compliance_Team__c+'\n'+followUp;
        }
        if(obj.Link_GMB_for_Location_Extenstions__c != 'Not Applicable' && obj.Link_GMB_for_Location_Extenstions__c != 'Completed' && obj.Link_GMB_for_Location_Extenstions__c != null){
            followUp = 'Link GMB for Location Extenstions - '+obj.Link_GMB_for_Location_Extenstions__c+'\n'+followUp;
        }
        if(obj.Add_to_Measurement_Trix__c != 'Not Applicable' && obj.Add_to_Measurement_Trix__c != 'Completed' && obj.Add_to_Measurement_Trix__c != null){
            followUp = 'Add to Measurement Trix - '+obj.Add_to_Measurement_Trix__c +'\n'+followUp;
        }
        if(obj.Contract_Signed__c != null){
            followUp = 'Contract Signed - '+obj.Contract_Signed__c+'\n'+followUp; 
        }
        
        if(obj.Complete_Payment_Call__c != null){
            followUp = 'Complete Kickoff Call - '+obj.Complete_Payment_Call__c+'\n'+followUp; 
        }
        return followUp;
    }
}