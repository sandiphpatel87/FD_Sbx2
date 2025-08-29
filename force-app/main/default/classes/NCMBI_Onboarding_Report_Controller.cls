public class NCMBI_Onboarding_Report_Controller 
{
    @AuraEnabled
    public static List <Onboarding__c> fetchOnboarding(String searchMonth ,String searchYear, String searchDate, String searchGroupCode, String searchGroupName) 
    {
        System.debug('====searchMonth==$$$$ : ' + searchMonth );
        System.debug('====searchYear==$$$$ : ' + searchYear );
        System.debug('====searchDate==$$$$ : ' + searchDate );
        
        String SobjectApiName = 'Onboarding__c';      
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        
        String commaSepratedFields = '';
        
        for(String fieldName : fieldMap.keyset())
        {
            if(commaSepratedFields == null || commaSepratedFields == '')
            {
                commaSepratedFields = fieldName;
            }
            else
            {
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }
        
        String query;
        Id recordTypeId = Schema.SObjectType.Onboarding__c.getRecordTypeInfosByDeveloperName().get('Business_Intelligence').getRecordTypeId();
        
        system.debug('recordTypeId : ' + recordTypeId);
        
        if(searchMonth == null  && searchYear == null && searchDate == null)
        {
            query = 'select Account__r.Name,Opportunity__r.Contract_Signed_Date__c,Opportunity__r.Name,Opportunity__r.Enrollment_Deadline__c, Account__r.Account_Technician__c,Account__r.Account_Technician_Name__c,Account__r.Regional_performance_manager__c,Account__r.Regional_Performance_Manager_Name__c,' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Opportunity__r.StageName = \'Onboarding\' AND (Opportunity__r.Type__c = \'NCM\' OR Opportunity__r.Type__c = \'Business Intelligence\')';// and RecordTypeId !=: recordTypeId 
            System.debug('====19==$$$$ : ' + query );
        }
        else if((searchMonth != null || searchYear != null) && searchDate == null)
        {
            if(searchMonth != null && searchYear ==  null)
            {
                Integer month = Integer.valueOf(searchMonth);
                
                System.debug('===31month=== : ' + month);
                
                query = 'select Account__r.Name,Opportunity__r.Name,Account__r.Account_Technician__c,Opportunity__r.Enrollment_Deadline__c,Account__r.Account_Technician_Name__c,Account__r.Regional_performance_manager__c,Account__r.Regional_Performance_Manager_Name__c,' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Opportunity__r.StageName = \'Onboarding\' and (Opportunity__r.Type__c = \'NCM\' OR Opportunity__r.Type__c = \'Business Intelligence\') and CALENDAR_MONTH(BI_Launch_Date__c) =' + month + ' AND RecordTypeId !=: recordTypeId'; 
                
                System.debug('===31=== : ' + query);
            }
            else if((searchYear != null && searchMonth == null) && searchDate == null)
            {
                Integer Year = Integer.valueOf(searchYear);
                query = 'select Account__r.Name,Opportunity__r.Name,Account__r.Account_Technician__c,Opportunity__r.Enrollment_Deadline__c,Account__r.Account_Technician_Name__c,Account__r.Regional_performance_manager__c,Account__r.Regional_Performance_Manager_Name__c,' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Opportunity__r.StageName = \'Onboarding\' AND (Opportunity__r.Type__c = \'NCM\' OR Opportunity__r.Type__c = \'Business Intelligence\') and CALENDAR_YEAR(BI_Launch_Date__c) ='+ Year + ' AND RecordTypeId !=: recordTypeId'; 
                
                System.debug('===36=== : ' + query);
            }
            else if ((searchYear != null && searchMonth != null) && searchDate == null)
            {  
                Integer month = Integer.valueOf(searchMonth);
                Integer Year = Integer.valueOf(searchYear);
                
                query = 'select Account__r.Name,Opportunity__r.Name,Opportunity__r.Enrollment_Deadline__c,Account__r.Account_Technician__c,Account__r.Account_Technician_Name__c,Account__r.Regional_performance_manager__c,Account__r.Regional_Performance_Manager_Name__c,' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Opportunity__r.StageName = \'Onboarding\' AND (Opportunity__r.Type__c = \'NCM\' OR Opportunity__r.Type__c = \'Business Intelligence\') and CALENDAR_MONTH(BI_Launch_Date__c) ='+ month +'and CALENDAR_YEAR(BI_Launch_Date__c) ='+ Year + ' AND RecordTypeId !=: recordTypeId'; 
                
                System.debug('====44==$$$$ : ' + query );
            }
        }
        else if(searchDate != null)
        {
            query = 'select Account__r.Name,Opportunity__r.Name,Opportunity__r.Enrollment_Deadline__c,Account__r.Account_Technician__c,Account__r.Account_Technician_Name__c,Account__r.Regional_performance_manager__c,Account__r.Regional_Performance_Manager_Name__c,' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Opportunity__r.StageName = \'Onboarding\' AND (Opportunity__r.Type__c = \'NCM\' OR Opportunity__r.Type__c = \'Business Intelligence\') AND BI_Launch_Date__c ='+ searchDate + ' AND RecordTypeId !=: recordTypeId'; 
            System.debug('====44==$$$$ : ' + query );
        }
        
        if(String.isNotBlank(searchGroupCode))
        {
            query = query + ' AND NCM_20_Group_Code__c =: searchGroupCode';
        }
        
        if(String.isNotBlank(searchGroupName))
        {
            query = query + ' AND NCM_Group__c =: searchGroupName';
        }
        
        system.debug('Query : ' + query);
        
        List <Onboarding__c> onboardingList = Database.query(query);
        
        System.debug('====== : ' + onboardingList);
        return onboardingList;
    }
    
    @AuraEnabled 
    public static Map<String, String> getMonthFieldValue()
    {
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