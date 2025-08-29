global class CaseAssignmentBatch implements Database.Batchable<sObject>
{
    global Database.Querylocator start(Database.BatchableContext bc)
    {
        List<String> recTypeNames = new List<String>{'Client_Services'};
        String query = 'SELECT Case_Assign_To__c, Case_Assignment_Queue__c, Request_Type__c, Status FROM Case WHERE Case_Assign_To__c = null AND Case_Assignment_Queue__c != null AND RecordType.DeveloperName IN :recTypeNames AND CreatedDate = TODAY';
        return Database.getQuerylocator(query);
    } 
    global void execute(Database.BatchableContext bc, List<Case> listCases)
    {
        System.debug('>>>> execute ' + listCases.size());
        
        Map<String, Case_Routing_Config__mdt> configMap = new Map<String, Case_Routing_Config__mdt>();
        
        for (Case_Routing_Config__mdt config : [ SELECT Id, Request_Type__c, Queue__c, Case_Entry__c, 
                                                Initial_Assignment__c, Field_Name__c
                                                FROM Case_Routing_Config__mdt
                                                WHERE Case_Entry__c = 'Auto' 
                                                AND Active__c = true
                                               ]) 
        {
            if (config.Request_Type__c != null) 
            {
                configMap.put(config.Request_Type__c, config);
            }
        }
        
        Set<String> setQueues = new Set<String>();
        
        For(Case objCase : listCases)
        {
            setQueues.add(objCase.Case_Assignment_Queue__c);
        }
        
        Map<String, List<String>> groupUserMap = new Map<String, List<String>>();
        
        // Fetch Group IDs
        Map<String, Id> groupIdMap = new Map<String, Id>();
        
        for (Group grp : [SELECT Id, Name FROM Group WHERE Name IN : setQueues AND Type = 'Queue']) 
        {
            groupIdMap.put(grp.Name, grp.Id);
        }
        
        // Fetch Users assigned to these groups
        Map<Id, List<String>> groupMembersMap = new Map<Id, List<String>>();
        
        for (GroupMember member : [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN :groupIdMap.values()]) 
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
        Set<String> setUserIds = new Set<String>();
        setQueues.clear();
        
        For (Case objCase : listCases) 
        {    
            If(objCase.Request_Type__c != null && configMap.get(objCase.Request_Type__c) != null)
            {
                Case_Routing_Config__mdt config = configMap.get(objCase.Request_Type__c);
                
                If(config.Queue__c != null && groupUserMap.get(config.Queue__c) != null && config.Initial_Assignment__c != null && config.Initial_Assignment__c == 'Queue'  && config.Case_Entry__c == 'Auto')
                {
                    setQueues.add(config.Queue__c);
                    
                    For(String str : groupUserMap.get(config.Queue__c))
                    {
                        setUserIds.add(str);
                    }
                    System.debug('setUserIds : ' + setUserIds);
                } 
            }
        }
        List<Case> listOldRecords = [SELECT Case_Assign_To__c, Case_Assignment_Queue__c, Request_Type__c 
                                     FROM Case 
                                     WHERE Case_Assign_To__c IN : setUserIds 
                                     AND Case_Assignment_Queue__c IN : setQueues
                                     ORDER BY LastModifiedDate DESC
                                    ];
        Map<String, Case> mapQueueAndCases = new Map<String, Case>();
        System.debug('listOldRecords : ' + listOldRecords);
        For(Case objCase : listOldRecords)
        {
            If(!mapQueueAndCases.containsKey(objCase.Case_Assignment_Queue__c ))
            {
                System.debug('Case Assignment Queue : ' + objCase.Case_Assignment_Queue__c);
                System.debug('Last Assigned user : ' + objCase.Case_Assign_To__c);
                mapQueueAndCases.put(objCase.Case_Assignment_Queue__c, objCase);
            }
        }
        System.debug('mapQueueAndCases : ' + mapQueueAndCases.keySet());
        System.debug('mapQueueAndCases : ' + mapQueueAndCases.values());
        System.debug('groupUserMap : ' + groupUserMap);
        Integer userNotAvailableIndex = 0;
        Map<String, Integer> mapUserIdAndIds = new  Map<String, Integer>();
        For (Case objCase : listCases) 
        {    
            If(objCase.Request_Type__c != null && configMap.get(objCase.Request_Type__c) != null)
            {
                Case_Routing_Config__mdt config = configMap.get(objCase.Request_Type__c);
                
                If(config.Queue__c != null && groupUserMap.get(config.Queue__c) != null && config.Initial_Assignment__c != null && config.Initial_Assignment__c == 'Queue')
                {
                    List<String> userIds = groupUserMap.get(config.Queue__c);
                    System.debug('userIds : ' + userIds);
                    System.debug('=========> : ' + objCase.Id);
                    System.debug('----------> : ' + objCase.Case_Assignment_Queue__c);
                    If(mapQueueAndCases.containsKey(objCase.Case_Assignment_Queue__c))
                    {
                        String caseAssignedId = mapQueueAndCases.get(objCase.Case_Assignment_Queue__c) != null && mapQueueAndCases.get(objCase.Case_Assignment_Queue__c).Case_Assign_To__c != null ? mapQueueAndCases.get(objCase.Case_Assignment_Queue__c).Case_Assign_To__c : '';
                        System.debug('caseAssignedId : ' + caseAssignedId);
                        // Fetch Last Assigned Case for User Rotation
                        
                        Integer nextUserIndex = String.isNotBlank(caseAssignedId) ? userIds.indexOf(caseAssignedId) + 1 : 0;
                        If(!mapUserIdAndIds.containsKey(objCase.Case_Assignment_Queue__c))
                        {
                            mapUserIdAndIds.put(objCase.Case_Assignment_Queue__c, nextUserIndex);
                        }
                        nextUserIndex = mapUserIdAndIds.get(objCase.Case_Assignment_Queue__c);
                        If (nextUserIndex >= userIds.size()) 
                        {
                            nextUserIndex = 0;
                        }
                        
                        System.debug('nextUserIndex : ' + nextUserIndex);
                        
                        // Assign Case
                        objCase.Case_Assign_To__c = userIds[nextUserIndex];
                        mapUserIdAndIds.put(objCase.Case_Assignment_Queue__c, nextUserIndex + 1);
                        System.debug('Case Assigned To : ' + objCase.Case_Assign_To__c);
                    }
                    Else
                    {
                        If (userNotAvailableIndex >= userIds.size()) 
                        {
                            userNotAvailableIndex = 0;
                        }
                        
                        System.debug('userNotAvailableIndex : ' + userNotAvailableIndex);
                        
                        // Assign Case
                        objCase.Case_Assign_To__c = userIds[userNotAvailableIndex];
                        System.debug('Case Assigned To : ' + objCase.Case_Assign_To__c);
                        
                        userNotAvailableIndex++;
                    }
                } 
            }
        }
        
        UPDATE listCases;
    }  
    global void finish(Database.BatchableContext bc)
    {
        // execute any post-processing operations
    }    
}