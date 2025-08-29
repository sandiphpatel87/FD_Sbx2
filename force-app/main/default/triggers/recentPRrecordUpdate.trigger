trigger recentPRrecordUpdate on Performance_Reviews__c (before insert,after Insert) {

    Set<ID> accountID = new Set<ID>();
    List<Performance_Reviews__c> oldPRUpdate = new List<Performance_Reviews__c>();
    
    if(trigger.isbefore && trigger.isInsert){
        for(Performance_Reviews__c pr : trigger.new){
            accountID.add(pr.Account__c);
        }
        
        for(Performance_Reviews__c prOld: [Select ID, Account__c,Recently_Created__c From Performance_Reviews__c where Account__c IN: accountID AND Recently_Created__c = True]){
            Performance_Reviews__c opr = new Performance_Reviews__c();
            opr.Id = prOld.ID;
            opr.Recently_Created__c = False;    
            oldPRUpdate.add(opr);
        }
        update oldPRUpdate;
        
        for(Performance_Reviews__c pr : trigger.new){
            pr.Recently_Created__c = true;  
        }
    }
    if(trigger.isAfter && trigger.isInsert){
        set<Id> AccId = new set<Id>();
        list<Integer> Months = new list<Integer>();
        list<Integer> years = new list<Integer>();
        for(Performance_Reviews__c pr : trigger.new){
            Integer month ;
            if(pr.Month__c != null){
              month = CoopTabController.getPreviousMonth(pr.Month__c);
                Months.add(month);
            }
            AccId.add(pr.Account__c);
            if(pr.Year__c != null){
                years.add(Integer.valueOf(pr.Year__c));
            }
           
        }
        System.debug('==years=='+years);
        System.debug('==Months=='+Months);
        List<Task> tskList = [select id,status from task where whatId In: AccId and subject =:'Performance review note added' and CALENDAR_MONTH(CreatedDate) In: Months and CALENDAR_YEAR(CreatedDate) In: Years ];
        System.debug('===='+tskList); 
        if(tskList != null && !tskList.isEmpty()){
                    for(Task tskObj : tskList){
                        tskObj.status = 'Completed';
                    }
                    update tskList;
                }       
    }
}