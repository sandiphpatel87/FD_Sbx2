global class mediaBudgetFlagOnAccBatch implements Database.Batchable<sObject>,Database.Stateful,schedulable {
    
    global string query,Month,Year,NxtMnth,NxtYear,LastMnth;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        DateTime dt = Datetime.now();
        Month = dt.format('MMM');
        Year = String.valueOf(dt.format('YYYY'));
        //___________________________________________________
        DateTime lstDt = dt.addMonths(-1);
        LastMnth = lstDt.format('MMM');
        Year = String.valueOf(lstDt.format('YYYY'));
        //___________________________________________________
        
        DateTime nxtDt = dt.addMonths(1);
        NxtMnth = nxtDt.format('MMM');
        NxtYear = String.valueOf(nxtDt.format('YYYY'));
        
        //query = 'SELECT ID,MRR__c,Sys_Agency_Fee_ARR__c,Month__c,Year__c,Opportunity.AccountId,Product2.Name,Percentage__c FROM OpportunityLineItem WHERE Percentage__c != null AND Product2.Name = \''+System.Label.AgencyFee_ProductName+'\'';
        query ='SELECT Id,Name,Tech_Fee_To_Budget_Ratio__c,Active__c,Type__c,Total_MRR__c,(SELECT Id,Account__r.Active__c,Account__r.Type__c,Account__r.Tech_Fee_To_Budget_Ratio__c,Account__r.Total_MRR__c,Total__c,Date__c,Budget_Month__c,Budget_Year__c,New_Search__c,Service_Search__c,Used_Search__c,Video__c,FB__c,Facebook_Used_Car_Budget__c,New_Vehicle_Ads__c,Vehicle_Ads_Used_Car_Budget__c FROM Budgets__r Where (Budget_Month__c= \''+Month +'\'AND Budget_Year__c=\''+ Year +'\') OR (Budget_Month__c= \''+NxtMnth +'\'AND Budget_Year__c=\''+ NxtYear +'\') OR (Budget_Month__c= \''+LastMnth +'\'AND Budget_Year__c=\''+ Year +'\') limit 3 ) FROM Account where Id In (SELECT Account__c FROM Media_Budget__c Where (Budget_Month__c= \''+Month +'\'AND Budget_Year__c=\''+ Year +'\') OR (Budget_Month__c= \''+NxtMnth +'\'AND Budget_Year__c=\''+ NxtYear +'\') OR (Budget_Month__c= \''+LastMnth +'\'AND Budget_Year__c=\''+ Year +'\')) ';  
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        List<Account> accList = new List<Account>();
        System.debug('===='+scope);
        for(Account acc:scope)
        {
            map<String,Boolean> mapOfMonth = new map<String,Boolean>();
            map<String,Media_Budget__c> mapOfMonthAndMedia = new map<String,Media_Budget__c>();
            
            Account act = new Account();
            for(Media_Budget__c m:acc.Budgets__r)
            {
                if(m.Budget_Month__c != null && m.Budget_Year__c != null)
                {
                    if(m.Budget_Month__c == Month && m.Budget_Year__c == Year)
                    {
                        mapOfMonth.put('Current_Month_Budget', True);
                        mapOfMonthAndMedia.put('Current_Month_Budget', m);
                    }  
                    if(m.Budget_Month__c == NxtMnth && m.Budget_Year__c == NxtYear)
                    {
                        mapOfMonth.put('New_Month_Budget', True);
                        mapOfMonthAndMedia.put('New_Month_Budget', m);
                    }
                    if(m.Budget_Month__c == LastMnth && m.Budget_Year__c == Year)
                    {
                        mapOfMonth.put('Last_Month__c', True);
                        mapOfMonthAndMedia.put('Last_Month__c', m);
                    }
                    /* if(m.Budget_Month__c == Month && m.Budget_Year__c == Year){
act.Current_Month_Budget__c = True;
}  
if((m.Budget_Month__c != Month && m.Budget_Year__c != Year)||(m.Budget_Month__c != Month && m.Budget_Year__c == Year && m.Budget_Month__c != NxtMnth)||(m.Budget_Month__c == Month && m.Budget_Year__c != Year && m.Budget_Month__c != NxtMnth)){
act.Current_Month_Budget__c = False;
}                    
if(m.Budget_Month__c == NxtMnth && m.Budget_Year__c == NxtYear){
act.New_Month_Budget__c = True;
}
if((m.Budget_Month__c != NxtMnth && m.Budget_Year__c != NxtYear) || (m.Budget_Month__c != NxtMnth && m.Budget_Year__c == NxtYear && m.Budget_Month__c != Month)||(m.Budget_Month__c == NxtMnth && m.Budget_Year__c != NxtYear && m.Budget_Month__c != Month)){
act.New_Month_Budget__c = False;
} */   
                }
            }
            System.debug('mapOfMonth ================'+mapOfMonth);
            System.debug('mapOfMonthAndMedia ================'+mapOfMonthAndMedia);
            
            If(mapOfMonth.containsKey('Current_Month_Budget'))
            {
                act.Current_Month_Budget__c = true;
                Media_Budget__c mediaBudget = mapOfMonthAndMedia.get('Current_Month_Budget');
                act.Current_Month_Budget_Fields__c ='New Search : $ '                  + mediaBudget.New_Search__c               + '\n' +
                    'Service Search : $ '              + mediaBudget.Service_Search__c           + '\n' +
                    'Used Search : $ '                 + mediaBudget.Used_Search__c              + '\n' +
                    'New Video : $ '                   + mediaBudget.Video__c                    + '\n' +
                    'Facebook New : $ '                + mediaBudget.FB__c                       + '\n' +
                    'Facebook Used : $ '               + mediaBudget.Facebook_Used_Car_Budget__c + '\n' +
                    'Vehicle Ads New Car Budget : $ '  + mediaBudget.New_Vehicle_Ads__c          + '\n' +
                    'Vehicle Ads Used Car Budget : $ ' + mediaBudget.Vehicle_Ads_Used_Car_Budget__c;
                
                /*If(mediaBudget.Account__r.Active__c == true)
                {
                    Integer index =  mediaBudget.Account__r.Type__c?.split(';').indexOf('Digital Advertising');
                    if(index != null && index != -1) {
                        if(mediaBudget.Total__c == 0 )
                        {
                            act.Tech_Fee_To_Budget_Ratio__c = 0;
                        }
                        else{
                             act.Tech_Fee_To_Budget_Ratio__c = ((mediaBudget.Account__r.Total_MRR__c/mediaBudget.Total__c)*100 ). setScale(2);
                        }
                    }
                }*/
                act.Current_Month_Budget_Total__c = mediaBudget.Total__c;
                
            }
            else
            {
                act.Current_Month_Budget__c = false; 
                act.Current_Month_Budget_Fields__c = '';
            }
            If(mapOfMonth.containsKey('New_Month_Budget'))
            {
                act.New_Month_Budget__c = true;
                Media_Budget__c mediaBudget = mapOfMonthAndMedia.get('New_Month_Budget');
                act.New_Month_Budget_Fields__c    = 'New Search : $ '                  + mediaBudget.New_Search__c               + '\n' +
                    'Service Search : $ '              + mediaBudget.Service_Search__c           + '\n' +
                    'Used Search : $ '                 + mediaBudget.Used_Search__c              + '\n' +
                    'New Video : $ '                   + mediaBudget.Video__c                    + '\n' +
                    'Facebook New : $ '                + mediaBudget.FB__c                       + '\n' +
                    'Facebook Used : $ '               + mediaBudget.Facebook_Used_Car_Budget__c + '\n' +
                    'Vehicle Ads New Car Budget : $ '  + mediaBudget.New_Vehicle_Ads__c          + '\n' +
                    'Vehicle Ads Used Car Budget : $ ' + mediaBudget.Vehicle_Ads_Used_Car_Budget__c;
                
                act.New_Month_Budget_New_Search__c              = mediaBudget.New_Search__c;
                act.New_Month_Budget_Service_Search__c          = mediaBudget.Service_Search__c;
                act.New_Month_Budget_Used_Search__c             = mediaBudget.Used_Search__c ;
                act.New_Month_Budget_New_Video__c               = mediaBudget.Video__c;
                act.New_Month_Budget_Facebook_New__c            = mediaBudget.FB__c  ;
                act.New_Month_Budget_Facebook_Used__c           = mediaBudget.Facebook_Used_Car_Budget__c;
                act.New_Month_Budget_VehicleAdsNewCarBudget__c  = mediaBudget.New_Vehicle_Ads__c;
                act.New_Month_Budget_VehicleAdsUsedCarBudget__c = mediaBudget.Vehicle_Ads_Used_Car_Budget__c;
            }
            else
            {
                act.New_Month_Budget__c = false; 
                act.New_Month_Budget_Fields__c  ='';
                act.New_Month_Budget_New_Search__c              = null;
                act.New_Month_Budget_Service_Search__c          = null;
                act.New_Month_Budget_Used_Search__c             = null;
                act.New_Month_Budget_New_Video__c               = null;
                act.New_Month_Budget_Facebook_New__c            = null;
                act.New_Month_Budget_Facebook_Used__c           = null;
                act.New_Month_Budget_VehicleAdsNewCarBudget__c  = null;
                act.New_Month_Budget_VehicleAdsUsedCarBudget__c = null;
            }
            If(mapOfMonth.containsKey('Last_Month__c'))
            {
                act.Last_Month__c = true; 
                Media_Budget__c mediaBudget = mapOfMonthAndMedia.get('Last_Month__c');
                act.Last_Month_Budget_Fields__c   = 'New Search : $ '                  + mediaBudget.New_Search__c               + '\n' +
                    'Service Search : $ '              + mediaBudget.Service_Search__c           + '\n' +
                    'Used Search : $ '                 + mediaBudget.Used_Search__c              + '\n' +
                    'New Video : $ '                   + mediaBudget.Video__c                    + '\n' +
                    'Facebook New : $ '                + mediaBudget.FB__c                       + '\n' +
                    'Facebook Used : $ '               + mediaBudget.Facebook_Used_Car_Budget__c + '\n' +
                    'Vehicle Ads New Car Budget : $ '  + mediaBudget.New_Vehicle_Ads__c          + '\n' +
                    'Vehicle Ads Used Car Budget : $ ' + mediaBudget.Vehicle_Ads_Used_Car_Budget__c;
            }
            else
            {
                act.Last_Month__c = false; 
                act.Last_Month_Budget_Fields__c= '';
            }
            /* if(mapOfMonth.containsKey('Current_Month_Budget') && mapOfMonth.containsKey('New_Month_Budget') && mapOfMonth.containsKey('Last_Month__c') )
{
System.debug('==========1======'+mapOfMonth+'===='+NxtMnth+'=='+Month +'=='+acc.Name);
act.Current_Month_Budget__c = True;
act.New_Month_Budget__c = True;
act.Last_Month__c = True;
}
else if(mapOfMonth.containsKey('Current_Month_Budget') && !mapOfMonth.containsKey('New_Month_Budget') && mapOfMonth.containsKey('Last_Month__c'))
{
System.debug('=========2======='+mapOfMonth);
System.debug('==========2======'+mapOfMonth+'===='+NxtMnth+'=='+Month +'=='+acc.Name);

act.Current_Month_Budget__c = True;
act.Last_Month__c = True;
act.New_Month_Budget__c = false; 
}
else if(!mapOfMonth.containsKey('Current_Month_Budget') && mapOfMonth.containsKey('New_Month_Budget') && mapOfMonth.containsKey('Last_Month__c'))
{
System.debug('===========3====='+mapOfMonth);
System.debug('==========3======'+mapOfMonth+'===='+NxtMnth+'=='+Month +'=='+acc.Name);

act.Current_Month_Budget__c = false;
act.New_Month_Budget__c = True; 
act.Last_Month__c = True;
}
else if(mapOfMonth.containsKey('Current_Month_Budget') && mapOfMonth.containsKey('New_Month_Budget') && !mapOfMonth.containsKey('Last_Month__c'))
{
System.debug('===========3====='+mapOfMonth);
System.debug('==========3======'+mapOfMonth+'===='+NxtMnth+'=='+Month +'=='+acc.Name);

act.Current_Month_Budget__c = True;
act.New_Month_Budget__c = True; 
act.Last_Month__c = false;
}
else
{
act.Current_Month_Budget__c = false;
act.New_Month_Budget__c = false; 
act.Last_Month__c = false;
}*/
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
        mediaBudgetFlagOnAccBatch b = new mediaBudgetFlagOnAccBatch(); //ur batch class
        database.executebatch(b,50);
    }
}