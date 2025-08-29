global class agency_Fees_UpdateBatch implements Database.Batchable<sObject>,Database.Stateful,schedulable {

    global Map<Id,Decimal> accIDtotalMBMap = new Map<Id,Decimal>();
    global string query,Month,Year;
    global set<ID> accIDs = new set<ID>();
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        DateTime dt = Datetime.now();
        Month = dt.format('MMM');
        Year = String.valueOf(dt.format('YYYY'));
                
        query = 'SELECT ID,MRR__c,Sys_Agency_Fee_ARR__c,Month__c,Year__c,Opportunity.AccountId,Product2.Name,Percentage__c FROM OpportunityLineItem WHERE Percentage__c != null AND Product2.Name = \''+System.Label.AgencyFee_ProductName+'\'';
        List<OpportunityLineItem> oppLineItemList = database.query(query);
        for(OpportunityLineItem oli:oppLineItemList){
            accIDs.add(oli.Opportunity.AccountId);
        }
        List<Account> accList = [SELECT Id,Name,(SELECT Id,Total__c,Date__c FROM Budgets__r Where Budget_Month__c=:Month AND Budget_Year__c=:Year limit 1) FROM Account WHERE Id=:accIDs];
        
        for(Account p:accList){
            for(Media_Budget__c m:p.Budgets__r){
                accIDtotalMBMap.put(p.ID, m.Total__c);
            }
        }
        system.debug('accIDtotalMBMap >>'+accIDtotalMBMap);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<OpportunityLineItem> scope)
    {
    	List<OpportunityLineItem> opliList = new List<OpportunityLineItem>();
        for(OpportunityLineItem opp:scope){
            system.debug('accIDtotalMBMap values >>'+accIDtotalMBMap.get(opp.Opportunity.AccountId));
            if(accIDtotalMBMap.get(opp.Opportunity.AccountId) != null && (opp.Month__c != Month || opp.Month__c == null || opp.Month__c == '')){
                OpportunityLineItem oppli = new OpportunityLineItem();
                decimal mrrValue = accIDtotalMBMap.get(opp.Opportunity.AccountId);
                decimal mrrfees = mrrValue * (opp.Percentage__c/100);
                oppli.MRR__c = mrrfees;
                oppli.Sys_Agency_Fee_ARR__c = opp.Sys_Agency_Fee_ARR__c != null ? opp.Sys_Agency_Fee_ARR__c + mrrfees : mrrfees;
                if(opp.Year__c != null && opp.Year__c != Year){
                    oppli.Sys_Agency_Fee_ARR__c = mrrfees;
                }
                oppli.Month__c = Month;
                oppli.Year__c = Year;
                oppli.Id = opp.id;
                opliList.add(oppli);
                system.debug('inside loop >>'+opliList);
            }
        }
        
       update opliList;
    }
    
    global void finish(Database.BatchableContext BC)
    {
    }
    global void execute(SchedulableContext sc)
    {
        agency_Fees_UpdateBatch b = new agency_Fees_UpdateBatch(); //ur batch class
        database.executebatch(b);
    }
}