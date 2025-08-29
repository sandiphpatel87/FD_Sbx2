global class LoadOppConRole implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'Select Id, AccountId from Opportunity ORDER BY Name';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> oppList) {
        
        List<OpportunityContactRole> listOpportunityContactRole = new LIST<OpportunityContactRole>();
        
        
        // process each batch of records default size is 200
        for(Opportunity opp : oppList) {     
            
            LIST<AccountContactRelation> accRelLst = [Select Id, AccountId, ContactId, Roles 
                                                      from AccountContactRelation 
                                                      WHERE AccountId=:opp.AccountId];
            
            for(AccountContactRelation accRel : accRelLst){
                OpportunityContactRole OppContactRole = new OpportunityContactRole();
                OppContactRole.OpportunityId = opp.Id;
                OppContactRole.Roles__c = accRel.Roles;
                OppContactRole.ContactId = accRel.ContactId;
                OppContactRole.Account__c = accRel.AccountId;
                listOpportunityContactRole.add(OppContactRole);
            }
            
        }
        try {
           insert listOpportunityContactRole; 
            
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
    
}