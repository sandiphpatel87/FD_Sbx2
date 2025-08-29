public class CalculateCaseDueDate 
{
    //For update
    public static void calculateCaseDueDate(List<Case> updatedCases,Map<Id,Case> oldCaseMap)
    {
        for (Case updatedCase : updatedCases)
        {
            //1 of start month field
            If( (updatedCase.status != oldCaseMap.get(updatedCase.Id).status) || 
               ((updatedCase.Request_Type__c != oldCaseMap.get(updatedCase.Id).Request_Type__c) || 
                (updatedCase.Future_Start_Date__c != oldCaseMap.get(updatedCase.Id).Future_Start_Date__c) ) && 
               (updatedCase.status == 'Future' && updatedCase.Request_Type__c == 'Future Budget Change'))
            { 
                If(updatedCase.Future_Start_Date__c != null)
                {
                    
                    //Integer monthNumber = ((updatedCase.Future_Start_Date__c).month());
                    //Integer currentYear = ((updatedCase.Future_Start_Date__c).year());
                    
                    //If(currentYear != null)
                    //{
                    //Date firstDayOfMonth = Date.newInstance(currentYear, monthNumber, 1);
                    
                    //System.debug('First day of the month: ' + firstDayOfMonth);
                    updatedCase.Start_Date_Time__c = updatedCase.Future_Start_Date__c;
                    updatedCase.Start_Date__c = updatedCase.Future_Start_Date__c;
                    //updatedCase.Due_Date__c = firstDayOfMonth;
                    //}                    
                }
            } 
            //last date before 5 business days of month
            If(((updatedCase.status != oldCaseMap.get(updatedCase.Id).status) || 
                (updatedCase.Request_Type__c != oldCaseMap.get(updatedCase.Id).Request_Type__c) || 
                (updatedCase.Future_Start_Date__c != oldCaseMap.get(updatedCase.Id).Future_Start_Date__c) ) && 
               (updatedCase.status == 'Future' && 
                (updatedCase.Request_Type__c == 'Future Campaign Build - Client Requested' || 
                 updatedCase.Request_Type__c == 'Future Campaign Build - Get Me More' || 
                 updatedCase.Request_Type__c == 'Future Campaign Build - Standard')))
            {
                If(updatedCase.Future_Start_Date__c != null)
                {
                    
                    //Integer monthNumber = ((updatedCase.Future_Start_Date__c).month());
                    //Integer year = ((updatedCase.Future_Start_Date__c).year());
                    
                    //If(year != null)
                    //{
                    
                    //Date firstDayOfMonth = Date.newInstance(year, monthNumber, 1);
                    /*Integer businessDaysCount = 0;
Integer daysToSubtract = 0;
while (businessDaysCount < 5)
{
daysToSubtract++;
Date subtractedDate = firstDayOfMonth.addDays(daysToSubtract);
Datetime subtractedDatetime = Datetime.newInstance(subtractedDate.year(), subtractedDate.month(), subtractedDate.day());
String dayOfWeek = subtractedDatetime.format('EEEE');

if (!dayOfWeek.equals('Saturday') && !dayOfWeek.equals('Sunday')) 
{
businessDaysCount++;
}
}
firstDayOfMonth = firstDayOfMonth;
updatedCase.Start_Date_Time__c = firstDayOfMonth.addDays(-daysToSubtract);
updatedCase.Start_Date__c = firstDayOfMonth.addDays(-daysToSubtract);*/
                    
                    updatedCase.Start_Date_Time__c = updatedCase.Future_Start_Date__c;
                    updatedCase.Start_Date__c = updatedCase.Future_Start_Date__c;
                    // Get the last day of the month
                    //Integer lastDay = Date.daysInMonth(year, monthNumber-1);
                    //updatedCase.Due_Date__c = Date.newInstance(year, monthNumber-1, lastDay);
                    //System.debug('Last day of ' + monthName + ' ' + year + ': ' + lastDay);
                    //}
                }
                Else
                {
                    Case oldCase = oldCaseMap.get(updatedCase.Id);
                    system.debug('oldCase ---'+oldCase);
                    if (updatedCase.SLA_Time__c != null && (updatedCase.SLA_Time__c != oldCase.SLA_Time__c)) 
                    {
                        system.debug('---- In first if  ---');
                        // Calculate the new due date based on the created date and SLA time
                        Integer slaTime = Integer.valueOf(updatedCase.SLA_Time__c);
                        system.debug(' slaTime  ---'+slaTime);
                        DateTime createdDateTime = updatedCase.CreatedDate;
                        system.debug(' createdDateTime  ---'+createdDateTime);
                        // Add additional days for cases created on weekends
                        if (createdDateTime.format('E') == 'Sat') 
                        {
                            system.debug('---- created on saturday  ---');
                            createdDateTime = createdDateTime.addDays(2);
                        }
                        else if (createdDateTime.format('E') == 'Sun') 
                        {
                            system.debug('---- created on sunday  ---');
                            createdDateTime = createdDateTime.addDays(1);
                        }
                        
                        // Adjust due date based on business hours
                        while (slaTime > 0) 
                        {
                            createdDateTime = createdDateTime.addHours(1);
                            if (isBusinessHour(createdDateTime))
                            {
                                slaTime--;
                            }
                        }
                        
                        Date dueDate = createdDateTime.date();
                        
                        // Update the case's due date field
                        //updatedCase.Due_Date__c = dueDate;
                    }
                }
            } 
        }
    }
    
    //For Insert
    public static void insertCases(List<Case> newCases)
    {
        if (!newCases.isEmpty()) 
        {
            Set<Id> casesId = new Set<Id>();
            Set<Id> futureCaseIds = new Set<Id>();
            //List<Case> caseListRPM = new List<Case>();
            //List<Case> caselist = new List<Case>();
            
            For(Case updatedCase : newCases)
            {
                
                /*if ( (updatedCase.Close_Date__c!=null && updatedCase.Request_Type__c =='Performance Review') )
{
caselist.add(updatedCase);
}*/
                
                If(updatedCase.SLA_Time__c != null)
                {
                    casesId.add(updatedCase.Id);   
                }
                //1 of start month field
                If(updatedCase.Future_Start_Date__c != null && updatedCase.status == 'Future' && updatedCase.Request_Type__c == 'Future Budget Change')
                {
                    futureCaseIds.add(updatedCase.Id);
                } 
                //last date before 5 business days of month
                If(updatedCase.Future_Start_Date__c != null && updatedCase.status == 'Future' && (updatedCase.Request_Type__c == 'Future Campaign Build - Client Requested' || updatedCase.Request_Type__c == 'Future Campaign Build - Get Me More' || updatedCase.Request_Type__c == 'Future Campaign Build - Standard'))
                {
                    futureCaseIds.add(updatedCase.Id);
                }
                
                /* if( updatedCase.Request_Type__c =='Performance Review' &&  
(updatedCase.Close_Date__c != null || updatedCase.Dealer_is_Satisfied_with_the_partnership__c != '' || 
updatedCase.Is_the_Dealer_meeting_sales_objectives__c != '' || 
updatedCase.Decision_Maker_attended_Performance_call__c != '' ||
updatedCase.third_Party_vendor_consistent_involvemen__c != '' || 
updatedCase.New_Stakeholder__c !=''))
{
caseListRPM.add(updatedCase);
}*/
            }
            /*if (!caseListRPM.isEmpty()) {
updateRPMScore(caseListRPM);
}*/
            //calculateAvgDays(caselist);
            calculateDueDateAsync(casesId);
            updateFutureCases(futureCaseIds);
        }
    } 
    
    //For sla cases insert
    //@future
    public static void calculateDueDateAsync(Set<Id> casesToUpdate)
    {
        List<Case> casesToUpdateWithDueDate = [SELECT Id,SLA_Time__c,Due_Date__c,CreatedDate FROM Case WHERE Id IN:casesToUpdate];
        List<Case> finalCaseLst = new List<Case>();
        for (Case updatedCase : casesToUpdateWithDueDate) 
        {
            // Calculate the new due date based on the created date and SLA time
            Integer slaTime = Integer.valueOf(updatedCase.SLA_Time__c);
            system.debug(' slaTime  ---'+slaTime);
            DateTime createdDateTime = updatedCase.CreatedDate;
            system.debug(' createdDateTime  ---'+createdDateTime);
            // Add additional days for cases created on weekends
            if (createdDateTime.format('E') == 'Sat') 
            {
                system.debug('---- created on saturday  ---');
                createdDateTime = createdDateTime.addDays(2);
            }
            else if (createdDateTime.format('E') == 'Sun') 
            {
                system.debug('---- created on sunday  ---');
                createdDateTime = createdDateTime.addDays(1);
            }
            
            // Adjust due date based on business hours
            while (slaTime > 0) 
            {
                createdDateTime = createdDateTime.addHours(1);
                if (isBusinessHour(createdDateTime))
                {
                    slaTime--;
                }
            }
            
            Date dueDate = createdDateTime.date();
            // Update the case's due date field
            updatedCase.Due_Date__c = dueDate;
            finalCaseLst.add(updatedCase);
        }
        
        
        if (!finalCaseLst.isEmpty()) 
        {
            update finalCaseLst;
        }
    }
    
    //For insert future cases
    //@future
    public static void updateFutureCases(Set<Id> casesToUpdate)
    {
        List<Case> casesToUpdateWithDueDate = [SELECT Id, Future_Start_Date__c,Start_Month__c, status, Request_Type__c, 
                                               Start_Date__c, Due_Date__c, Future_Start_Year__c
                                               FROM Case 
                                               WHERE Id IN : casesToUpdate
                                              ];
        List<Case> finalCaseLst = new List<Case>();
        for (Case updatedCase : casesToUpdateWithDueDate) 
        {
            //1 of start month field
            If(updatedCase.status == 'Future' && updatedCase.Request_Type__c == 'Future Budget Change')
            {
                If(updatedCase.Future_Start_Date__c != null)
                {
                    
                    /*Integer monthNumber = ((updatedCase.Future_Start_Date__c).month());
Integer currentYear = ((updatedCase.Future_Start_Date__c).year());

If(currentYear != null)
{
Date firstDayOfMonth = Date.newInstance(currentYear, monthNumber, 1);

System.debug('First day of the month: ' + firstDayOfMonth);
updatedCase.Start_Date_Time__c = firstDayOfMonth;
updatedCase.Start_Date__c = firstDayOfMonth;*/
                    updatedCase.Start_Date_Time__c = updatedCase.Future_Start_Date__c;
                    updatedCase.Start_Date__c = updatedCase.Future_Start_Date__c;
                    //updatedCase.Due_Date__c = firstDayOfMonth;
                    finalCaseLst.add(updatedCase);
                    //}
                }
            } 
            //last date before 5 business days of month
            If((updatedCase.status == 'Future') && (updatedCase.Request_Type__c == 'Future Campaign Build - Client Requested' || updatedCase.Request_Type__c == 'Future Campaign Build - Get Me More' || updatedCase.Request_Type__c == 'Future Campaign Build - Standard'))
            {
                If(updatedCase.Future_Start_Date__c != null)
                {
                    
                    /*Integer monthNumber = ((updatedCase.Future_Start_Date__c).month());
Integer year = ((updatedCase.Future_Start_Date__c).year());

If(year != null)
{
Date firstDayOfMonth = Date.newInstance(year, monthNumber, 1);
Integer businessDaysCount = 0;
Integer daysToSubtract = 0;
while (businessDaysCount <= 5)
{
daysToSubtract++;
Date subtractedDate = firstDayOfMonth.addDays(daysToSubtract);
Datetime subtractedDatetime = Datetime.newInstance(subtractedDate.year(), subtractedDate.month(), subtractedDate.day());
String dayOfWeek = subtractedDatetime.format('EEEE');

if (!dayOfWeek.equals('Saturday') && !dayOfWeek.equals('Sunday')) 
{
businessDaysCount++;
}
}
firstDayOfMonth = firstDayOfMonth;
updatedCase.Start_Date_Time__c = firstDayOfMonth.addDays(-daysToSubtract);

updatedCase.Start_Date__c = firstDayOfMonth.addDays(-daysToSubtract);*/
                    
                    updatedCase.Start_Date_Time__c = updatedCase.Future_Start_Date__c;
                    updatedCase.Start_Date__c = updatedCase.Future_Start_Date__c;
                    // Get the last day of the month
                    //Integer lastDay = Date.daysInMonth(year, monthNumber-1);
                    //updatedCase.Due_Date__c = Date.newInstance(year, monthNumber, lastDay);
                    //System.debug('Last day of ' + monthName + ' ' + year + ': ' + lastDay);
                    finalCaseLst.add(updatedCase);
                    //}
                }
            }
        }
        if (!finalCaseLst.isEmpty()) 
        {
            update finalCaseLst;
        }
    }
    
    // Check if the given datetime falls within business hours
    private static Boolean isBusinessHour(DateTime dt) 
    {
        // Check if it's Monday to Friday
        if (dt.format('E') != 'Sat' && dt.format('E') != 'Sun')
        {
            Time startTime = Time.newInstance(9, 0, 0, 0);
            Time endTime = Time.newInstance(17, 0, 0, 0);
            Time current = dt.time();
            return current >= startTime && current <= endTime;
        }
        
        return false;
    }
    
    public static void afterUpdateCases(List<Case> newCases,Map<Id,Case> oldCaseMap)
    {
        Set<Id> caselist = new Set<Id>();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> caseListRPM = new Set<Id>();
        Set<Id> accIdSetRPM = new Set<Id>();
        for(Case c:newCases)
        {
            if ( (c.ClosedDate!=null && c.Request_Type__c =='Performance Review') && 
                (c.ClosedDate != oldCaseMap.get(c.Id).ClosedDate) )
            {
                caselist.add(c.Id);
                accIdSet.add(c.AccountId);
            }
            if ( (c.Request_Type__c =='Performance Review') && (c.ClosedDate != null  || (c.ClosedDate != oldCaseMap.get(c.Id).ClosedDate) ||
                                                                c.New_Stakeholder__c != oldCaseMap.get(c.Id).New_Stakeholder__c    || 
                                                                c.Is_the_Dealer_meeting_sales_objectives__c   != oldCaseMap.get(c.Id).Is_the_Dealer_meeting_sales_objectives__c   ||
                                                                c.Dealer_is_Satisfied_with_the_partnership__c != oldCaseMap.get(c.Id).Dealer_is_Satisfied_with_the_partnership__c || 
                                                                c.Decision_Maker_attended_Performance_call__c != oldCaseMap.get(c.Id).Decision_Maker_attended_Performance_call__c ||
                                                                c.third_Party_vendor_consistent_involvemen__c != oldCaseMap.get(c.Id).third_Party_vendor_consistent_involvemen__c ||
                                                                c.Is_this_client_at_risk_for_cancellation__c != oldCaseMap.get(c.Id).Is_this_client_at_risk_for_cancellation__c) )
            {
                caseListRPM.add(c.Id);
                accIdSetRPM.add(c.AccountId);
            }
        }
        if (!caseListRPM.isEmpty()) 
        {
            updateRPMScore(caseListRPM,accIdSetRPM);
        }
        if(!caselist.isEmpty()){
            calculateAvgDays(caselist,accIdSet);    
        }
        
    }
    
    
    public static void calculateAvgDays(Set<Id> newCases,Set<Id> accIdSet)
    {
        map<ID,Integer> mapOfAccIdAndAvgDays = new map<ID,Integer>();
        map<ID,List<Case>> mapOfAccIdAndCaseList = new  map<ID,List<Case>>();
        
        List<case> allCaseList=[SELECT id,Close_Date__c,Request_Type__c ,AccountId,ClosedDate 
                                FROM Case 
                                WHERE ClosedDate!=null AND Request_Type__c ='Performance Review' 
                                AND AccountId != null AND AccountId IN:accIdSet ORDER BY ClosedDate  DESC];
        
        for(Case cs: allCaseList){
            if(mapOfAccIdAndCaseList.containsKey(cs.AccountId))
            {
                List<Case> caselst = mapOfAccIdAndCaseList.get(cs.AccountId);
                caselst.add(cs);
                mapOfAccIdAndCaseList.put(cs.AccountId, caselst);
            }
            else{
                mapOfAccIdAndCaseList.put(cs.AccountID, new List<Case> { cs });
            }
        }
        
        
        for(Case c: [Select Id, AccountID, Close_Date__c,ClosedDate from Case where ID IN: newCases])
        {
            List<case> caseListOfSameAcc= mapOfAccIdAndCaseList.get(c.AccountID);
            system.debug('caseListOfSameAcc '+ caseListOfSameAcc);
            Integer totalDaysBetweenPRClose = 0;
            Integer AvgDaysBetweenPRClose;
            
            for(Integer i=0 ; i<caseListOfSameAcc.size() - 1 ; i++)
            {
                totalDaysBetweenPRClose = totalDaysBetweenPRClose + (((caseListOfSameAcc[i+1].ClosedDate).date()).daysBetween((caseListOfSameAcc[i].ClosedDate).date()));
                //(caseListOfSameAcc[i].Close_Date__c - caseListOfSameAcc[i+1].Close_Date__c );
                system.debug('totalDaysBetweenPRClose ='+ totalDaysBetweenPRClose);
            }
            if(caseListOfSameAcc.size() >1){
                AvgDaysBetweenPRClose = totalDaysBetweenPRClose/(caseListOfSameAcc.size()-1);
            }
            else{
                AvgDaysBetweenPRClose = totalDaysBetweenPRClose;
            }
            system.debug('AvgDaysBetweenPRClose ='+ AvgDaysBetweenPRClose);
            mapOfAccIdAndAvgDays.put(c.AccountId, AvgDaysBetweenPRClose);
        }
        List<Id> mapKeys = new List<Id>(mapOfAccIdAndAvgDays.keySet());
        List<Account> accListToUpdate=[SELECT id FROM Account WHERE ID IN: mapKeys];
        for (Account acc: accListToUpdate)
        {
            acc.Average_Days_Between_PRs__c = mapOfAccIdAndAvgDays.get(acc.ID);
        }
        update accListToUpdate;  
    }
    
    
    public static void updateRPMScore(Set<Id> newCases,Set<Id> accIdSet){
        
        map<ID,Case> mapOfAccIdAndLatestCase = new  map<ID,Case>();
        List<Account> accListToUpdate = new List<Account>();
        
        List<case> allCaseList=[SELECT id,Close_Date__c,Request_Type__c ,AccountId,ClosedDate 
                                FROM Case 
                                WHERE ClosedDate!=null AND Request_Type__c ='Performance Review' 
                                AND AccountId != null AND AccountId IN:accIdSet ORDER BY ClosedDate DESC];
        
        for(Case cs: allCaseList){
            if(! mapOfAccIdAndLatestCase.containsKey(cs.AccountId))
            {
                mapOfAccIdAndLatestCase.put(cs.AccountID,cs);
            }
        }
        System.debug('mapOfAccIdAndLatestCase = '+ mapOfAccIdAndLatestCase);
        
        for(Case c: [Select Id,ClosedDate,Is_this_client_at_risk_for_cancellation__c, AccountId, Is_the_Dealer_meeting_sales_objectives__c, Dealer_is_Satisfied_with_the_partnership__c, New_Stakeholder__c, third_Party_vendor_consistent_involvemen__c, Decision_Maker_attended_Performance_call__c, Close_Date__c from Case where ID IN :newCases]){
            if(mapOfAccIdAndLatestCase.containsKey(c.AccountId)){
                
                System.debug('(mapOfAccIdAndLatestCase.get(c.AccountId)).ID = '+ (mapOfAccIdAndLatestCase.get(c.AccountId)).ID);
                if((mapOfAccIdAndLatestCase.get(c.AccountId)).ID == c.id)
                {
                    if(c.Is_this_client_at_risk_for_cancellation__c == 'Yes')
                    {
                        Integer CountDays = (Date.valueOf(c.ClosedDate)).daysBetween(system.today());
                        System.debug('CountDays = '+ CountDays);
                        Account a = new Account();
                        a.id = c.AccountId;
                        a.RPM_Assessment_Score__c = 0;
                        a.Days_Since_Last_PR_Closed__c = CountDays;
                        accListToUpdate.add(a);
                    }
                    else
                    {
                        Integer RPMScore,isDealer,Decision,third,newStack,Dealer; 
                        if(c.Is_the_Dealer_meeting_sales_objectives__c == 'Yes'){
                            isDealer = 20;
                        }
                        else if(c.Is_the_Dealer_meeting_sales_objectives__c == 'No'){
                            isDealer = 10;
                        }
                        else{
                            isDealer = 0;
                        }
                        
                        if(c.Dealer_is_Satisfied_with_the_partnership__c == 'Yes'){
                            Dealer = 20;
                        }
                        else if(c.Dealer_is_Satisfied_with_the_partnership__c == 'No'){
                            Dealer = 10;
                        }
                        else{
                            Dealer = 0;
                        }
                        
                        if(c.New_Stakeholder__c == 'Yes'){
                            newStack = 10;
                        }
                        else if(c.New_Stakeholder__c == 'No'){
                            newStack = 20;
                        }
                        else{
                            newStack = 0;
                        }
                        
                        if(c.third_Party_vendor_consistent_involvemen__c == 'Yes'){
                            third = 20;
                        }
                        else if(c.third_Party_vendor_consistent_involvemen__c == 'No'){
                            third = 10;
                        }
                        else{
                            third = 0;
                        }
                        
                        if(c.Decision_Maker_attended_Performance_call__c == 'Yes'){
                            Decision = 20;
                        }
                        else if(c.Decision_Maker_attended_Performance_call__c == 'No'){
                            Decision = 10;
                        }
                        else{
                            Decision = 0;
                        }
                        
                        RPMScore = isDealer + Decision + third + newStack + Dealer; 
                        Integer CountDays = (Date.valueOf(c.ClosedDate)).daysBetween(system.today());
                        System.debug('CountDays = '+ CountDays);
                        Account a = new Account();
                        a.id = c.AccountId;
                        a.RPM_Assessment_Score__c = RPMScore;
                        a.Days_Since_Last_PR_Closed__c = CountDays;
                        accListToUpdate.add(a);
                    }
                }
            }
        }
        update accListToUpdate;
    } 
    
    public static void onBeforeInsert(List<Case> listCases)
    {
        // Get Client Service record type ID
        Id clientServiceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Client_Services').getRecordTypeId(); 
        // Filter cases to only process Client Service record type
        List<Case> filteredCases = new List<Case>();
        for(Case c : listCases) {
            if(c.RecordTypeId == clientServiceRecordTypeId) {
                filteredCases.add(c);
            }
        }
        // Fetch Metadata Configurations
        Map<String, Case_Routing_Config__mdt> caseRoutingConfigMap = getCaseRoutingConfigurations();
        
        Map<String, Account> mapAccounts = getAccountRecords(filteredCases, caseRoutingConfigMap);
        
        // Fetch Group Users for 'Action', 'Analyze' and 'Helpware' queues
        Map<String, List<String>> groupUserMap = getGroupUsers(new Set<String>{'Action', 'Analyze', 'Helpware'});
        
        // Process Cases
        assignCases(filteredCases, caseRoutingConfigMap, groupUserMap, mapAccounts);
    }
    
    private static Map<String, Account> getAccountRecords(List<Case> listCases, Map<String, Case_Routing_Config__mdt> caseRoutingConfigMap) 
    {
        Set<String> setAccountFields = new Set<String>();
        
        For(Case_Routing_Config__mdt objCaseRoutingConfig : caseRoutingConfigMap.values())
        {
            If(objCaseRoutingConfig.Field_Name__c != null && !setAccountFields.contains(objCaseRoutingConfig.Field_Name__c))
            {
                setAccountFields.add(objCaseRoutingConfig.Field_Name__c);
            }
        }
        
        Map<String, Account> mapAccounts = new Map<String, Account>();
        
        If(!setAccountFields.isEmpty()) 
        {
            Set<String> setAccountIds = new Set<String>();
            
            For(Case objCase : listCases)
            {
                If(objCase.AccountId != null)
                {
                    setAccountIds.add(objCase.AccountId);
                }
            }
            
            // Convert Set to a comma-separated string
            String fieldsToQuery = String.join(new List<String>(setAccountFields), ', ');
            System.debug('fieldsToQuery : ' + fieldsToQuery);
            // Construct the dynamic SOQL query
            String soqlQuery = 'SELECT ' + fieldsToQuery + ' FROM Account WHERE Id IN : setAccountIds';
            
            System.debug('Dynamic SOQL Query: ' + soqlQuery);
            
            // Execute the query dynamically
            List<Account> listAccounts = Database.query(soqlQuery);
            
            For(Account objAccount : listAccounts)
            {
                mapAccounts.put(objAccount.Id, objAccount);
            }
            // Debug results
            System.debug('Fetched Accounts: ' + listAccounts);
        }
        return mapAccounts;
    }
    
    private static Map<String, Case_Routing_Config__mdt> getCaseRoutingConfigurations() 
    {
        Map<String, Case_Routing_Config__mdt> configMap = new Map<String, Case_Routing_Config__mdt>();
        
        for (Case_Routing_Config__mdt config : [ SELECT Id, Request_Type__c, Queue__c, QA_Queue__c, Case_Entry__c, 
                                                Initial_Assignment__c, After_QA_Assignment__c, Field_Name__c, 
                                                QA_Field_Name__c, Auto_QA_Assignment__c, Active__c 
                                                FROM Case_Routing_Config__mdt
                                               ]) 
        {
            if (config.Request_Type__c != null) 
            {
                configMap.put(config.Request_Type__c, config);
            }
        }
        return configMap;
    }
    
    private static Map<String, List<String>> getGroupUsers(Set<String> groupNames) 
    {
        Map<String, List<String>> groupUserMap = new Map<String, List<String>>();
        
        Set<Id> oooUserIds = new Map<Id, User>([SELECT Id FROM User WHERE OOO__c = true]).keySet();     
        // Fetch Group IDs
        Map<String, Id> groupIdMap = new Map<String, Id>();
        for (Group grp : [SELECT Id, Name FROM Group WHERE Name IN :groupNames AND Type = 'Queue']) 
        {
            groupIdMap.put(grp.Name, grp.Id);
        }
        
        // Fetch Users assigned to these groups
        Map<Id, List<String>> groupMembersMap = new Map<Id, List<String>>();
        
        for (GroupMember member : [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN :groupIdMap.values() AND UserOrGroupId NOT IN :oooUserIds]) 
        {
            if (!groupMembersMap.containsKey(member.GroupId)) 
            {
                groupMembersMap.put(member.GroupId, new List<String>());
            }
            groupMembersMap.get(member.GroupId).add(member.UserOrGroupId);
        }
        
        // Map users back to group names
        for (String groupName : groupIdMap.keySet()) 
        {
            String groupId = groupIdMap.get(groupName);
            
            if (groupMembersMap.containsKey(groupId)) 
            {
                groupUserMap.put(groupName, groupMembersMap.get(groupId));
            }
        }
        
        return groupUserMap;
    }
    
    private static void assignCases(List<Case> listCases, Map<String, Case_Routing_Config__mdt> caseRoutingConfigMap, Map<String, List<String>> groupUserMap, Map<String, Account> mapAccounts) 
    {
        System.debug('listCases : ' + listCases);
        System.debug('caseRoutingConfigMap : ' + caseRoutingConfigMap);
        System.debug('groupUserMap : ' + groupUserMap);
        System.debug('mapAccounts : ' + mapAccounts);
        
        For (Case objCase : listCases) 
        {    
            System.debug('----------> ' + caseRoutingConfigMap.containsKey(objCase.Request_Type__c));
            
            If(caseRoutingConfigMap.containsKey(objCase.Request_Type__c) && caseRoutingConfigMap.get(objCase.Request_Type__c) != null)
            {
                Case_Routing_Config__mdt config = caseRoutingConfigMap.get(objCase.Request_Type__c);
                
                /*If((config.Case_Entry__c != null && 
                config.Case_Entry__c == 'Manual' && 
                config.Active__c == true) || 
                (objCase.Status == 'Future' && 
                caseRoutingConfigMap.containsKey(objCase.Request_Type__c) && 
                caseRoutingConfigMap.get(objCase.Request_Type__c) != null &&               
                caseRoutingConfigMap.get(objCase.Request_Type__c).Active__c == true)) */
                If(config.Case_Entry__c != null && 
                config.Case_Entry__c == 'Manual' && 
                config.Active__c == true)
                {
                    If(config.Queue__c != null && groupUserMap.get(config.Queue__c) != null && config.Initial_Assignment__c != null && config.Initial_Assignment__c == 'Queue')
                    {
                        List<String> userIds = groupUserMap.get(config.Queue__c);
                        System.debug('userIds : ' + userIds);
                        // Fetch Last Assigned Case for User Rotation
                        Integer nextUserIndex = (getLastAssignedUser(userIds, config.Queue__c) != null) ? userIds.indexOf(getLastAssignedUser(userIds, config.Queue__c)) + 1 : 0;
                        
                        If (nextUserIndex >= userIds.size()) 
                        {
                            nextUserIndex = 0;
                        }
                        
                        System.debug('nextUserIndex : ' + nextUserIndex);
                        
                        // Assign Case
                        objCase.Case_Assign_To__c = userIds[nextUserIndex];
                        objCase.Case_Assignment_Queue__c = config.Queue__c;
                    }
                    Else If(config.Queue__c == null && config.Initial_Assignment__c != null && config.Initial_Assignment__c == 'Field')
                    {
                        System.debug(config.Field_Name__c + ' : ######################### : ' + mapAccounts.get(objCase.AccountId));
                        If(objCase.AccountId != null && mapAccounts.containsKey(objCase.AccountId) && mapAccounts.get(objCase.AccountId) != null)
                        {
                            Account objAccount = mapAccounts.get(objCase.AccountId);
                            
                            If(objAccount.get(String.ValueOf(config.Field_Name__c)) != null)
                            {
                                objCase.Case_Assign_To__c = String.ValueOf(objAccount.get(config.Field_Name__c));
                                objCase.Case_Assignment_Queue__c = '';
                            }
                            System.debug('objCase : ' + objCase);
                        }
                    }
                }
                Else If(config.Case_Entry__c != null && config.Case_Entry__c == 'Auto' && config.Active__c == true)
                {
                    If(config.Queue__c != null && groupUserMap.get(config.Queue__c) != null && config.Initial_Assignment__c != null && config.Initial_Assignment__c == 'Queue')
                    {
                        objCase.Case_Assignment_Queue__c = config.Queue__c;
                    }
                    Else If(config.Queue__c == null && config.Initial_Assignment__c != null && config.Initial_Assignment__c == 'Field')
                    {
                        System.debug(config.Field_Name__c + ' : ######################### : ' + mapAccounts.get(objCase.AccountId));
                        If(objCase.AccountId != null && mapAccounts.containsKey(objCase.AccountId) && mapAccounts.get(objCase.AccountId) != null)
                        {
                            Account objAccount = mapAccounts.get(objCase.AccountId);
                            
                            If(objAccount.get(String.ValueOf(config.Field_Name__c)) != null)
                            {
                                objCase.Case_Assign_To__c = String.ValueOf(objAccount.get(config.Field_Name__c));
                                objCase.Case_Assignment_Queue__c = '';
                            }
                            System.debug('objCase : ' + objCase);
                        }
                    }
                }
            }
        }
    }
    
    private static String getLastAssignedUser(List<String> userIds, String queueName) 
    {
        If(!userIds.isEmpty())
        {
            List<Case> lastAssignedCase = [SELECT Case_Assign_To__c, Case_Assignment_Queue__c 
                                           FROM Case 
                                           WHERE Case_Assign_To__c IN : userIds 
                                           AND Case_Assignment_Queue__c =: queueName
                                           ORDER BY CreatedDate DESC LIMIT 1
                                          ];
            return (!lastAssignedCase.isEmpty()) ? lastAssignedCase[0].Case_Assign_To__c : null;
        }
        return null;
    }
    
    public static void onBeforeUpdate(List<Case> listCases, Map<Id, Case> mapOldCases) 
    {
        calculateCaseDueDate(listCases, mapOldCases);
        // Get Client Service record type ID
        Id clientServiceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Client_Services').getRecordTypeId(); 
        // Filter cases to only process Client Service record type
        List<Case> filteredCases = new List<Case>();
        for(Case c : listCases) {
            if(c.RecordTypeId == clientServiceRecordTypeId) {
                filteredCases.add(c);
            }
        }
        // Fetch Metadata Configurations
        Map<String, Case_Routing_Config__mdt> caseRoutingConfigMap = getCaseRoutingConfigurations();
        
        Map<String, Account> mapAccounts = getAccountRecords(filteredCases, caseRoutingConfigMap);
        
        // Fetch Group Users for 'Action', 'Analyze' and 'Helpware' queues
        Map<String, List<String>> groupUserMap = getGroupUsers(new Set<String>{'Action', 'Analyze', 'Helpware'});
        
        /*Set<String> setUserIds = new Set<String>();
        For(String str : groupUserMap.keySet())
        {
            For(String str1 : groupUserMap.get(str))
            {
                setUserIds.add(str1);
            }
        }
        */    
        // Process Cases
        assignBeforeUpdateCases(filteredCases, caseRoutingConfigMap, groupUserMap, mapAccounts, mapOldCases);
    }
    
    private static void assignBeforeUpdateCases(List<Case> listCases, Map<String, Case_Routing_Config__mdt> caseRoutingConfigMap, Map<String, List<String>> groupUserMap, Map<String, Account> mapAccounts, Map<Id, Case> mapOldCases)
    {
        System.debug('listCases : ' + listCases);
        System.debug('caseRoutingConfigMap : ' + caseRoutingConfigMap);
        System.debug('groupUserMap : ' + groupUserMap);
        System.debug('mapAccounts : ' + mapAccounts);
        
        For (Case objCase : listCases) 
        {   
            If(objCase.Status != null && 
               objCase.Status != mapOldCases.get(objCase.Id).Status && 
               mapOldCases.get(objCase.Id).Status != 'Ready for QA' &&
               objCase.Status == 'Ready for QA' && 
               caseRoutingConfigMap.containsKey(objCase.Request_Type__c) && 
               caseRoutingConfigMap.get(objCase.Request_Type__c) != null &&
               caseRoutingConfigMap.get(objCase.Request_Type__c).Auto_QA_Assignment__c == true &&
               caseRoutingConfigMap.get(objCase.Request_Type__c).Active__c == true
              ){
                Case_Routing_Config__mdt config = caseRoutingConfigMap.get(objCase.Request_Type__c);
                
                System.debug('QA Queue : ' + config.QA_Queue__c);
                System.debug('-------> : ' + groupUserMap.get(config.QA_Queue__c));
                System.debug('=======> : ' + config.After_QA_Assignment__c);
                
                If(objCase.Case_Assignment_Queue__c != null && 
                   config.QA_Queue__c != null && 
                   groupUserMap.get(config.QA_Queue__c) != null && 
                   config.After_QA_Assignment__c != null && 
                   config.After_QA_Assignment__c == 'Queue'
                  )
                {
                    List<String> userIds = groupUserMap.get(config.QA_Queue__c);
                    System.debug('userIds : ' + userIds);
                    
                    Integer nextUserIndex = (getLastAssignedUserForUpdate(userIds, config.QA_Queue__c) != null) ? userIds.indexOf(getLastAssignedUserForUpdate(userIds, config.QA_Queue__c)) + 1 : 0;
                    
                    If (nextUserIndex >= userIds.size()) 
                    {
                        nextUserIndex = 0;
                    }
                    
                    System.debug('nextUserIndex : ' + nextUserIndex);
                    
                    // Assign Case
                    objCase.Case_Assign_To__c = userIds[nextUserIndex];
                    objCase.Case_Assignment_Queue__c = config.QA_Queue__c;
                }
                Else If(config.QA_Queue__c == null && config.After_QA_Assignment__c != null && config.After_QA_Assignment__c == 'Field')
                {
                    System.debug(config.QA_Field_Name__c + ' : ######################### : ' + mapAccounts.get(objCase.AccountId));
                    /*
                    If(objCase.AccountId != null && mapAccounts.containsKey(objCase.AccountId) && mapAccounts.get(objCase.AccountId) != null)
                    {
                        Account objAccount = mapAccounts.get(objCase.AccountId);
                        If(objAccount.get(String.ValueOf(config.QA_Field_Name__c)) != null)
                        {
                            objCase.Case_Assign_To__c = String.ValueOf(objAccount.get(config.QA_Field_Name__c));
                            objCase.Case_Assignment_Queue__c = '';
                        }
                        System.debug('objCase : ' + objCase);
                    }
                    */
                    If(config.QA_Field_Name__c != null && objCase.get(String.ValueOf(config.QA_Field_Name__c)) != null){
                        objCase.Case_Assign_To__c = String.ValueOf(objCase.get(config.QA_Field_Name__c));
                        objCase.Case_Assignment_Queue__c = '';
                    }
                }
            }
        }
    }
    
    private static String getLastAssignedUserForUpdate(List<String> userIds, String queueName) 
    {
        If(!userIds.isEmpty())
        {
            List<Case> lastAssignedCase = [SELECT Case_Assign_To__c, Case_Assignment_Queue__c 
                                           FROM Case 
                                           WHERE Case_Assign_To__c IN : userIds 
                                           AND Case_Assignment_Queue__c =: queueName
                                           ORDER BY LastModifiedDate DESC LIMIT 1
                                          ];
            return (!lastAssignedCase.isEmpty()) ? lastAssignedCase[0].Case_Assign_To__c : null;
        }
        return null;
    }
    
}