public with sharing class OpportunityFetcher {
    @InvocableMethod(label='Get Opportunities for Accounts' description='Fetch all Opportunities related to given Account Ids')
    public static List<Opportunity> getOpportunitiesForAccounts(List<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return new List<Opportunity>();
        }

        // Query all Opportunities related to the given Account Ids
        return [SELECT Id, Name, StageName, Amount, CloseDate, AccountId 
                FROM Opportunity 
                WHERE AccountId IN :accountIds];
    }
}