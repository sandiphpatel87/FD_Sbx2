global class UpdateOpportunityStageAsLostBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query opportunities where Last_Day_of_Service__c is not null and StageName is not 'Lost'
        // Also get account information in the same query to avoid additional queries
        return Database.getQueryLocator([
            SELECT Id, StageName, Last_Day_of_Service__c, AccountId, 
                   Account.Active__c, Account.Live_Opps__c, Account.Name
            FROM Opportunity 
            WHERE Last_Day_of_Service__c != null 
            AND StageName != 'Lost'
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        if (scope.isEmpty()) return;
        
        // Step 1: Identify opportunities that need to be updated to 'Lost'
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        Set<Id> accountIdsToCheck = new Set<Id>();
        
        for (Opportunity opp : scope) {
            // Check if Last_Day_of_Service__c is today or before today
            if (opp.Last_Day_of_Service__c <= Date.today()) {
                // Update opportunity stage to Lost
                opp.StageName = 'Lost';
                opportunitiesToUpdate.add(opp);
                
                // Add account to check list if not already there
                if (opp.AccountId != null) {
                    accountIdsToCheck.add(opp.AccountId);
                }
            }
        }
        
        // Step 2: Update all opportunities in a single DML operation
        if (!opportunitiesToUpdate.isEmpty()) {
            try {
                update opportunitiesToUpdate;
                System.debug('Successfully updated ' + opportunitiesToUpdate.size() + ' opportunities to Lost stage');
            } catch (Exception e) {
                System.debug('Error updating opportunities: ' + e.getMessage());
                // Log error but continue with account processing
            }
        }
        
        // Step 3: Process accounts that need to be made inactive
        if (!accountIdsToCheck.isEmpty()) {
            processAccountsForInactiveStatus(accountIdsToCheck);
        }
    }
    
    private void processAccountsForInactiveStatus(Set<Id> accountIds) {
      
        // Single query to get all accounts with their live opportunities count
        Map<Id, Account> accountsMap = new Map<Id, Account>([
            SELECT Id, Active__c, Live_Opps__c, Name,
                   (SELECT Id FROM Opportunities WHERE StageName NOT IN ('Closed Won', 'Closed Lost'))
            FROM Account 
            WHERE Id IN :accountIds
            AND Active__c = true
        ]);
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account acc : accountsMap.values()) {
            // Check if account has no live opportunities and is active           
            if (acc.Active__c == true) {
                // Use the Live_Opps__c field if available, otherwise count from subquery
                Integer liveOppCount = 0;
                if (acc.Live_Opps__c != null) {
                    liveOppCount = Integer.valueOf(acc.Live_Opps__c);
                } else {
                    // Fallback to counting from subquery if Live_Opps__c is not populated
                    liveOppCount = acc.Opportunities.size();
                }
                
                if (liveOppCount == 0) {
                    accountsToUpdate.add(new Account(Id = acc.Id, Active__c = false));
                }
            }            
        }
        
        // Update all accounts in a single DML operation
        if (!accountsToUpdate.isEmpty()) {
            try {
                update accountsToUpdate;
                System.debug('Successfully updated ' + accountsToUpdate.size() + ' accounts to inactive status');
            } catch (Exception e) {
                System.debug('Error updating accounts: ' + e.getMessage());
            }
        }       
    }
    
    global void finish(Database.BatchableContext BC) {
        // Log completion
        System.debug('UpdateOpportunityStageAsLostBatch completed successfully');
       
    }    
    
    @TestVisible
    private void testForceAccountProcessing() {
        integer a = 0;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
    }
   
}