public class CoopCloneController {
    @auraEnabled  
    public static wrapperClass getCoop(String coopId) {  
        DescribeSObjectResult describeResult = Coop__c.getSObjectType().getDescribe();	
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query =	  ' SELECT ' +String.join( fieldNames, ',') +',Account__r.Name,Contact_2__r.Name,Contact3__r.Name,Contact_4__r.Name,Contact__r.Name  FROM Coop__c where id =: coopId';
        Coop__c obj =   Database.query( query );
        obj.Pre_Approval_Required__c = false;
        obj.Bing_Screenshot__c = false;
        obj.Bing_Invoices__c = false;
        obj.Bing_Final_URL_Report__c = false;
        obj.Facebook_Ad_Screenshot__c = false;
        obj.Facebook_Invoices__c = false;
        obj.FB_Performance_Report_Screenshot__c = false;
        obj.FD_Tech_Invoice__c = false;
        obj.Google_Search_Screenshot__c = false;
        obj.Google_Clicks_and_Impressions_Report__c = false;
        obj.Google_Invoices__c = false;
        obj.Google_Keyword_Report__c = false;
        obj.Pre_Approval_Required__c = false;
        obj.Submit_on_behalf_of_the_client__c = false;
        obj.Video_Campaign_Screenshot__c = false;
        obj.Video_Ad_Screenshot__c = false;
        obj.Video__c = false;
        obj.Video_Model_Ad_Screenshot__c = false;
        obj.Video_Model_Script__c = false;
        if(obj.Date__c != null){
            Date LastMonth = obj.Date__c.addmonths(-1);
            system.debug('==='+Lastmonth.Month());
            obj.Month__c = getPreviousMonth(LastMonth.month());
            obj.Year__c = String.valueOf(Lastmonth.year());
        }
        String queryOld =	  ' SELECT ' +String.join( fieldNames, ',') +'  FROM Coop__c where id =: coopId limit 1';
        List<Coop__c> objOld =   Database.query( queryOld );
        wrapperClass returnwrapperClass = new  wrapperClass ();        
        returnwrapperClass.coopObj = obj;
        returnwrapperClass.coopObjOld = objOld;
        return returnwrapperClass;
    } 
    @auraEnabled 
    public static List <String> getPiklistValues() {
        List<String> plValues = new List<String>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('Coop__c');
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get('Notary_Required__c').getDescribe();
        List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();
        for(Schema.PicklistEntry plv: picklistvalues) {
            plValues.add(plv.getValue());
        }
        plValues.sort();
        return plValues;
    }
    @auraEnabled 
    public static Coop__c saveCoop(Coop__c coopObj){
        system.debug('=============='+coopObj.Account__r.Name);
        system.debug('=============='+coopObj.Account__c);
        system.debug('=============='+coopObj.Contact__c);
        system.debug('=============='+coopObj.Notary_Required__c); 
        
        Coop__c obj = new Coop__c();
        obj.Pre_Approval_Required__c = coopObj.Pre_Approval_Required__c;
        obj.Bing_Screenshot__c = coopObj.Bing_Screenshot__c;
        obj.Bing_Invoices__c = coopObj.Bing_Invoices__c;
        obj.Bing_Final_URL_Report__c = coopObj.Bing_Final_URL_Report__c;
        obj.Facebook_Ad_Screenshot__c = coopObj.Facebook_Ad_Screenshot__c;
        obj.Facebook_Invoices__c = coopObj.Facebook_Invoices__c;
        obj.FB_Performance_Report_Screenshot__c = coopObj.FB_Performance_Report_Screenshot__c;
        obj.FD_Tech_Invoice__c = coopObj.FD_Tech_Invoice__c;
        obj.Google_Search_Screenshot__c = coopObj.Google_Search_Screenshot__c;
        obj.Google_Clicks_and_Impressions_Report__c = coopObj.Google_Clicks_and_Impressions_Report__c;
        obj.Google_Invoices__c = coopObj.Google_Invoices__c;
        obj.Google_Keyword_Report__c = coopObj.Google_Keyword_Report__c;
        obj.Pre_Approval_Required__c = coopObj.Pre_Approval_Required__c;
        obj.Submit_on_behalf_of_the_client__c = coopObj.Submit_on_behalf_of_the_client__c;
        obj.Video_Campaign_Screenshot__c = coopObj.Video_Campaign_Screenshot__c;
        obj.Video_Ad_Screenshot__c = coopObj.Video_Ad_Screenshot__c;
        obj.Video__c = coopObj.Video__c;
        obj.Video_Model_Ad_Screenshot__c = coopObj.Video_Model_Ad_Screenshot__c;
        obj.Video_Model_Script__c = coopObj.Video_Model_Script__c;
        obj.Account__c = coopObj.Account__c;
        obj.Contact3__c = coopObj.Contact3__c;
        obj.Contact_2__c = coopObj.Contact_2__c;
        obj.Contact_4__c = coopObj.Contact_4__c;
        obj.Contact__c = coopObj.Contact__c;
        obj.Notary_Required__c = coopObj.Notary_Required__c;
        obj.Notes__c = coopObj.Notes__c;
        obj.Month__c = coopObj.Month__c;
        obj.Year__c = coopObj.Year__c;
        obj.Date__c = coopObj.Date__c;
        
        // Coop__c obj = coopObj.clone(false, false, false, false);
        
        try{
            insert obj;	
        }
        catch(Exception e){
            throw new AuraHandledException('Something went wrong: '
                                           + e.getMessage()); 
        }
        system.debug('=============='+obj.Id); 
        return obj;
    }
    public static string getPreviousMonth(Integer dateVal){
      String month;
        switch on dateVal {
            when 1 {
               month = 'Jan';
            }
            when 2 {
             month  ='Feb'; 
            }
            when 3 {
              month  = 'Mar';
            }
            when 4 {
              month  = 'Apr';
            }
            when 5 {
               month = 'May';
            }
            when 6 {
               month = 'Jun';
            }
            when 7 {
               month = 'Jul';
            }
            when 8 {
               month = 'Aug';
            }
            when 9 {
              month  = 'Sep'; 
            }
            when 10 {
              month  = 'Oct'; 
            }
            when 11 {
               month ='Nov'; 
            }
            when 12 {
                month = 'Dec';
            }
        }
        return month;
    }
    
    public class wrapperClass{
        
        @AuraEnabled public Coop__c coopObj{get;set;}
        @AuraEnabled public list<Coop__c> coopObjOld {get;set;}
    }
}