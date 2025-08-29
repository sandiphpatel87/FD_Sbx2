global with sharing class budgetsOfAccount{
    
    //global List<Media_Budget__c> Opps{get;set;}
    global String accountId{get;set;}
    global account account{
        get {
          Account = [Select Id, name from Account where id =: accountId];
          return account; }
       set;
    }
   
    global List<Media_Budget__c> Opps{
        get{        
            List<Media_Budget__c> posToDisplay = new List<Media_Budget__c>();
            DateTime dt = Datetime.now();
            String Month = dt.format('MMM');
            String Year = String.valueOf(dt.format('YYYY'));
            
            List<Account> accList = [SELECT Id,Name,(SELECT Id,Used_Search__c,Service_Search__c,Video__c,FB__c,New_Search__c,Date__c,Display__c,Used_Video__c,Used_Display__c,Facebook_Service__c, Facebook_Used_Car_Budget__c, New_Vehicle_Ads__c, Vehicle_Ads_Used_Car_Budget__c, Streaming_TV_OTT_Advertising__c, New_Performance_Max__c, Used_Performance_Max__c FROM Budgets__r Where Budget_Month__c=:Month AND Budget_Year__c=:Year limit 1) FROM Account WHERE Id=:accountId];
            for(Account p:accList){
                for(Media_Budget__c m:p.Budgets__r){
                    posToDisplay.add(m);
                }
            }
            return posToDisplay;
        }
        set;
    }
    
    global List<Media_Budget__c> newOpps{
        get{        
            List<Media_Budget__c> posToDisplay = new List<Media_Budget__c>();
            DateTime dt = Datetime.now();
            dt = dt.addMonths(1);
            String Month = dt.format('MMM');
            String Year = String.valueOf(dt.format('YYYY'));
            
            List<Account> accList = [SELECT Id,Name,(SELECT Id,Used_Search__c,Service_Search__c,Video__c,FB__c,New_Search__c,Date__c,Display__c,Used_Video__c,Used_Display__c,Facebook_Service__c, Facebook_Used_Car_Budget__c, New_Vehicle_Ads__c, Vehicle_Ads_Used_Car_Budget__c, Streaming_TV_OTT_Advertising__c, New_Performance_Max__c, Used_Performance_Max__c FROM Budgets__r Where Budget_Month__c=:Month AND Budget_Year__c=:Year limit 1) FROM Account WHERE Id=:accountId];
            for(Account p:accList){
                for(Media_Budget__c m:p.Budgets__r){
                    posToDisplay.add(m);
                }
            }
            return posToDisplay;
        }
        set;
    }
    
    global String NewLine {
        get { return '\r\n'; }
        set;
    }
    
}