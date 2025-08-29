global class SLARemainingTimeSendEmailBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Status, Remaining_Hours__c,Case_Assign_To__c,SLA_Time_fe__c,Account.Regional_performance_manager__c, Mail_Sent__c FROM Case';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Case> caseList) {
        
        for(Case cs : caseList) {
            if((cs.Remaining_Hours__c == 0 && cs.Mail_Sent__c != true && cs.Status != 'Future' && cs.Status != 'Closed') &&
              (cs.SLA_Time_fe__c != 0 && cs.SLA_Time_fe__c != NULL)){
               cs.Mail_Sent__c = true; 
            }
        }
        try {
            update caseList;
            
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}