global class PRCompleteFlagOnAccBatch implements Database.Batchable<sObject>,Database.Stateful,schedulable {
    
    global string query,CurrentMonth,CurrentYearStr,LastMonth,LastYearStr;
    global Decimal CurrentYear,LastYear;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        DateTime dt = Datetime.now();
        CurrentMonth = dt.format('MMM');
        CurrentYearStr = String.valueOf(dt.format('YYYY'));
        CurrentYear = decimal.valueOf(CurrentYearStr);


        DateTime lstDt = dt.addMonths(-1);
        LastMonth = lstDt.format('MMM');
        LastYearStr = String.valueOf(lstDt.format('YYYY'));
       	LastYear = decimal.valueOf(LastYearStr);
        
          query ='SELECT Id,Name,Current_Month_PR__c,Last_Month_PR__c,(SELECT Id,Close_Month__c,Close_Year__c FROM Cases Where (((Close_Month__c= \''+CurrentMonth +'\'AND Close_Year__c='+ CurrentYear +') OR (Close_Month__c= \''+LastMonth +'\'AND Close_Year__c='+ LastYear +')) AND Request_Type__c=\'Performance Review\' )  ) FROM Account where Id In (SELECT AccountId FROM Case Where (Close_Month__c= \''+CurrentMonth +'\'AND Close_Year__c='+ CurrentYear +') OR (Close_Month__c= \''+LastMonth +'\'AND Close_Year__c='+ LastYear +') ) ';  
       
      
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        List<Account> accList = new List<Account>();
        System.debug('===='+scope);
        for(Account acc:scope)
        {
            map<String,Boolean> mapOfMonth = new map<String,Boolean>();
            
            Account act = new Account();
            for(Case c:acc.Cases)
            {
                if(c.Close_Month__c != null && c.Close_Year__c != null)
                {
                    if(c.Close_Month__c == CurrentMonth && c.Close_Year__c == CurrentYear)
                    {
                        mapOfMonth.put('Current_Month_PR', True);
                       
                    }  
                    if(c.Close_Month__c == LastMonth && c.Close_Year__c == LastYear)
                    {
                        mapOfMonth.put('Last_Month_PR', True);
                    }
                }
            }
            System.debug('mapOfMonth ================'+mapOfMonth);
            
            If(mapOfMonth.containsKey('Current_Month_PR'))
            {
                act.Current_Month_PR__c = true;
            }
            If(mapOfMonth.containsKey('Last_Month_PR'))
            {
                act.Last_Month_PR__c = true;
            }
            If(!mapOfMonth.containsKey('Current_Month_PR'))
            {
                act.Current_Month_PR__c = false;
            }
            If(!mapOfMonth.containsKey('Last_Month_PR'))
            {
                act.Last_Month_PR__c = false;
            }
            act.Id = acc.Id;
            accList.add(act);
        }
        if(accList != null && !accList.isEmpty())
        {
            system.debug('accList before update -- '+accList);
            database.update(accList,true);
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
    global void execute(SchedulableContext sc)
    {
        PRCompleteFlagOnAccBatch b = new PRCompleteFlagOnAccBatch(); //ur batch class
        database.executebatch(b);
    }
}