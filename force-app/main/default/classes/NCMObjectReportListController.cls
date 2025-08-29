public class NCMObjectReportListController 
{
    @AuraEnabled
    public static List<Onboarding__c> getOnboardingRecords(Id recordId)
    {
        List<Onboarding__c> onBoardList = new List<	Onboarding__c>();
        Set<Id> accIdSet = new Set<Id>();
        String groupCode ='';
        
        List<Account> acc =[SELECT ID,Name,Sub_Parent__c FROM Account WHERE ID =: recordId];
        if(acc.size()>0)
        { 
            accIdSet.Add(acc[0].ID);
            if(   (acc[0].Name).contains('(') &&  (acc[0].Name).contains(')') )
            {
                groupCode = ((acc[0].Name). substringBetween('(', ')'));
            }
        }
        
        List<Account> accList =[SELECT Id,Name from Account Where Sub_Parent__c =: recordId OR ParentId =: recordId OR NCM_Management_Group__c =: recordId OR NCM_20_Group_2__c =: recordId];
        if(accList.size()>0)
        { 
            for(Account ac : accList){
                accIdSet.Add(ac.ID);
            }
        }
        
        
        
        
        List<Account> accountList = [SELECT Id,Name,Sub_Parent__c,(select id,Name,Opportunity__r.Account.Name,Website_URL__c,Contract_Signed__c, Opportunity__r.Type__c, Opportunity__r.Account.Type__c,
                                                                   Opportunity__r.StageName,GTM_Sent__c,GTM_on_Site__c,GTM_Container_Updated_for_GA4__c,
                                                                   Inventory_Received_Automation__c,Secure_Google_Ads_Data_In_GA__c from Onboarding__r WHERE NCM_20_Group_Code__c =: groupCode AND (Opportunity__r.StageName = 'Onboarding' OR Opportunity__r.StageName = 'Live')) 
                                     from Account Where id In: accIdSet];
        
        for(Account a : accountList)
        {
            for(Onboarding__c onboard: a.Onboarding__r)
            {
                onBoardList.add(onboard);
            }
        }
        return onBoardList;
    }
    
    @AuraEnabled
    public static List<Opportunity> getOpportunityRecords(Id recordId)
    {
        List<Opportunity> listOpportunities = new List<Opportunity>();
        Set<Id> accIdSet = new Set<Id>();
        String groupCode ='';
        
        List<Account> acc =[SELECT ID, Name, Sub_Parent__c FROM Account WHERE ID =: recordId];
        
        if(acc.size()>0)
        { 
            accIdSet.Add(acc[0].ID);
            if(   (acc[0].Name).contains('(') &&  (acc[0].Name).contains(')') )
            {
                groupCode = ((acc[0].Name). substringBetween('(', ')'));
            }
        }
        
        List<Account> accList =[SELECT Id,Name from Account Where Sub_Parent__c =: recordId OR ParentId =: recordId OR NCM_Management_Group__c =: recordId OR NCM_20_Group_2__c =: recordId];
        
        if(accList.size()>0)
        { 
            for(Account ac : accList){
                accIdSet.Add(ac.ID);
            }
        }
        
        List<Account> accountList = [SELECT Id, Name, Sub_Parent__c, (SELECT Id, Name, AccountId, Account.Name, Account.Type__c, StageName, Contract_Sent_Date__c, Contract_Signed_Date__c FROM Opportunities WHERE NCM_20_Group_Code__c =: groupCode)
                                     FROM Account WHERE Id In : accIdSet
                                    ];
        
        for(Account a : accountList)
        {
            for(Opportunity objOpportunity: a.Opportunities)
            {
                listOpportunities.add(objOpportunity);
            }
        }
        return listOpportunities;
    }
}