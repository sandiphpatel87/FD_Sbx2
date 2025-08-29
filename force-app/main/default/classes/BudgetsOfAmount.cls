global class BudgetsOfAmount {
    global String mediaId{get;set;}
    global Media_Budget__c MediaObj{
        get{
            if(mediaId != null){
                Media_Budget__c obj = [select id,New_Search__c,Service_Search__c,Used_Search__c,Facebook_Service__c,FB__c,Display__c,Video__c,Used_Display__c,Used_Video__c from Media_Budget__c where id =: mediaId];
                
                return obj;
            }
            return null;
        }
        set{}
        
    }
}