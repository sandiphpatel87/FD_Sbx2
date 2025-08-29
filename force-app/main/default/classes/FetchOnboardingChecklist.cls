public class FetchOnboardingChecklist {
    @AuraEnabled
    public static List <Onboarding__c> fetchOnboarding(String searchMonth ,String searchYear,String searchDate) {
        System.debug('====searchMonth==$$$$'+searchMonth );
        System.debug('====searchYear==$$$$'+searchYear );
        System.debug('====searchDate==$$$$'+searchDate );
            if(searchDate != null){
                System.debug('====loop==searchDate==$$$$'+searchDate );
            }
            
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
        Id recordTypeId =
  Schema.SObjectType.Onboarding__c.getRecordTypeInfosByDeveloperName()
    .get('Business_Intelligence').getRecordTypeId();
        
        system.debug('recordTypeId : ' + recordTypeId);
        
        if(searchMonth == null  && searchYear == null && searchDate == null){
            query = 'select Account__r.Name,Opportunity__r.Name,Account__r.Account_Technician__c,Account__r.Account_Technician_Name__c,Account__r.Regional_performance_manager__c,Account__r.Regional_Performance_Manager_Name__c,' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Opportunity__r.StageName = \'Onboarding\' AND Opportunity__r.Type__c = \'Digital Advertising\' AND RecordTypeId !=: recordTypeId'; 
            System.debug('====19==$$$$'+query );
        }
        
        else if((searchMonth != null || searchYear != null)&& searchDate == null){
            if(searchMonth != null && searchYear ==  null){
                Integer month = Integer.valueOf(searchMonth);
                System.debug('===31month==='+month);
                query = 'select Account__r.Name,Opportunity__r.Name,Account__r.Account_Technician__c,Account__r.Account_Technician_Name__c,Account__r.Regional_performance_manager__c,Account__r.Regional_Performance_Manager_Name__c,' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Opportunity__r.StageName = \'Onboarding\' AND Opportunity__r.Type__c = \'Digital Advertising\' AND (CALENDAR_MONTH(Planned_Launch_Date__c) ='+ month + ' AND RecordTypeId !=: recordTypeId'; 
                System.debug('===31==='+query);
            }
            else if((searchYear != null && searchMonth == null) && searchDate == null){
                Integer Year = Integer.valueOf(searchYear);
                query = 'select Account__r.Name,Opportunity__r.Name,Account__r.Account_Technician__c,Account__r.Account_Technician_Name__c,Account__r.Regional_performance_manager__c,Account__r.Regional_Performance_Manager_Name__c,' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Opportunity__r.StageName = \'Onboarding\' AND Opportunity__r.Type__c = \'Digital Advertising\' AND CALENDAR_YEAR(Planned_Launch_Date__c) ='+ Year + ' AND RecordTypeId !=: recordTypeId'; 
                System.debug('===36==='+query);
                
            }
            else if ((searchYear != null && searchMonth != null) && searchDate == null){
                
                Integer month = Integer.valueOf(searchMonth);
                Integer Year = Integer.valueOf(searchYear);
                query = 'select Account__r.Name,Opportunity__r.Name,Account__r.Account_Technician__c,Account__r.Account_Technician_Name__c,Account__r.Regional_performance_manager__c,Account__r.Regional_Performance_Manager_Name__c,' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Opportunity__r.StageName = \'Onboarding\' AND Opportunity__r.Type__c = \'Digital Advertising\' AND CALENDAR_MONTH(Planned_Launch_Date__c) ='+ month +'and CALENDAR_YEAR(Planned_Launch_Date__c) ='+ Year + ' AND RecordTypeId !=: recordTypeId'; 
                System.debug('====44==$$$$'+query );
            }
        }
        else if(searchDate != null){
            //Date sDate = date.valueOf(searchDate);
            query = 'select Account__r.Name,Opportunity__r.Name,Account__r.Account_Technician__c,Account__r.Account_Technician_Name__c,Account__r.Regional_performance_manager__c,Account__r.Regional_Performance_Manager_Name__c,' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Opportunity__r.StageName = \'Onboarding\' AND Opportunity__r.Type__c = \'Digital Advertising\' AND Planned_Launch_Date__c ='+ searchDate + ' AND RecordTypeId !=: recordTypeId'; 
            System.debug('====44==$$$$'+query );
        }
        system.debug('Query : ' + query);
        List <Onboarding__c> onboardingList = Database.query(query);
        System.debug('======'+onboardingList);
        // List<Onboarding__c> objList = [SELECT Id, Inventory_Providers__c, Inventory_Feed_Provider_New_Car__c, Inventory_Feed_Provider_Used_Car__c, Measurement_Strategy__c, Add_CC_to_Bing__c, Add_CC_to_Facebook__c, Add_CC_to_Google__c, Add_Sitelinks_to_Google_Ads__c, Add_to_Measurement_Trix__c, Budgets_Confirmed__c, Budgets_Updated_in_Apollo__c, Confirm_Launch_Date_with_Client__c, Create_Bing_Account__c, Create_Facebook_Account__c, Create_Google_Account__c, CreditCardAuthSent__c, Credit_Card_Received__c, Email_GTM_to_Website_Provider__c, Email_Measurement_Partner_Pixels__c, Email_Measurement_Partner__c, Facebook_Request_Accepted__c, Facebook_Request_Sent__c, GA_Access_Received_Analytics__c, GA_Access__c, GMB_Request_Received__c, GMB_Request_Sent__c, Inventory_Ordered__c, Link_GA_to_FD_View_and_Goals__c, Link_GMB_for_Location_Extenstions__c, Logo_Received__c, Logo_added_to_Compliance_Board__c, Logo_approved_by_Compliance_Team__c, OnboardingPackSent__c, Onboarding_Pack_Received__c, Schedule_Kickoff_Call__c, Send_Advertised_Payments_for_Approval__c, Send_Geo_targeting_for_Approval__c, Turn_Sitelinks_Off_in_Apollo__c, Verify_GTM_Installed_Correctly__c, Verify_Inventory_Pricing__c, Zipcodes_Received__c, Opportunity__c, Account__c, Contract_Signed__c, Inventory_Approval_Form_Received__c, Inventory_Approval_Form_Sent__c, Inventory_Is_In__c, Complete_Payment_Call__c, Dealership_Address__c, Call_Routing_Line_Service__c FROM Onboarding__c];
        //return list of accounts
        return onboardingList;
    }
    /* @AuraEnabled
public static  list<Onboarding_CheckList1__c> fetchCustomSet() {
list<Onboarding_CheckList1__c> csList = [select id,API_Name__c,Color__c,Label__c from Onboarding_CheckList1__c];
return csList;
}*/
    @AuraEnabled 
    public static Map<String, String> getMonthFieldValue(){
        Map<String, String> options = new Map<String, String>();
        options.put('1', 'January');
        options.put('2', 'February');
        options.put('3', 'March');
        options.put('4', 'April');
        options.put('5', 'May');
        options.put('6', 'June'); 
        options.put('7', 'July'); 
        options.put('8', 'August');
        options.put('9', 'September');
        options.put('10', 'October'); 
        options.put('11', 'November'); 
        options.put('12', 'December');
        
        return options;
    }
    
}