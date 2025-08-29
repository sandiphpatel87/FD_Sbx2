global class OnboardingProductFieldUpdateBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        //String query = 'SELECT Id,Opportunity__c, Profit_Center_New__c ,Profit_Center_Used__c ,Profit_Center_Service__c ,Opportunity_Product_Name__c, MRR__c from Onboarding__c';
        String query = 'SELECT Id,Opportunity__c, Profit_Center_New__c ,Profit_Center_Used__c ,Profit_Center_Service__c ,Opportunity_Product_Name__c from Onboarding__c';
        
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Onboarding__c> scope)
    {
        set<id> oppIds = new set<id>();
        for(Onboarding__c onBoard : scope)
        {
          oppIds.add(onBoard.Opportunity__c);
        }
        
        map<id,OpportunityLineItem> oppIdLineIdMap = new map<id,OpportunityLineItem>();
        List<Onboarding__c> onboardingListToUpdate = new List<Onboarding__c>();
        
        List<OpportunityLineItem> opLineItem =  [SELECT Id,Name,OpportunityId,Profit_Center_New__c ,Profit_Center_Used__c ,Profit_Center_Service__c , MRR__c FROM OpportunityLineItem where OpportunityId =: oppIds];        
        for(OpportunityLineItem opl : opLineItem){
           oppIdLineIdMap.put(opl.OpportunityId,opl); 
        } 
        system.debug('==------=============='+oppIdLineIdMap);
        
        for(Onboarding__c ob: scope){
            if(ob.Opportunity__c != null && oppIdLineIdMap.get(ob.Opportunity__c) != null){
            ob.Profit_Center_New__c = oppIdLineIdMap.get(ob.Opportunity__c).Profit_Center_New__c;
            ob.Profit_Center_Service__c = oppIdLineIdMap.get(ob.Opportunity__c).Profit_Center_Service__c;
            ob.Profit_Center_Used__c = oppIdLineIdMap.get(ob.Opportunity__c).Profit_Center_Used__c;
            ob.Opportunity_Product_Name__c = oppIdLineIdMap.get(ob.Opportunity__c).Name;
            //ob.MRR__c = string.valueOf(oppIdLineIdMap.get(ob.Opportunity__c).MRR__c);
            onboardingListToUpdate.add(ob);
            }
        }
        
        update onboardingListToUpdate;
    }
    global void finish(Database.BatchableContext BC) {
    }
}