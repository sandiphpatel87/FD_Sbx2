global class UpdateOpportunityStatusBatch implements Database.Batchable<sObject> , Database.Stateful
{
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        String query = 'SELECT Id, StageName, Contract_Signed_Date__c, AccountId, Account.Sub_Parent__c, Account.NCM_Management_Group__c, Account.NCM_20_Group_2__c, NCM_20_Group_Code__c,Account.Sub_Parent__r.Count_NCM_20_Group__c,Account.NCM_Management_Group__r.Count_NCM_Management_Group__c,Account.NCM_20_Group_2__r.Count_NCM_20_Group_2__c,Account.Sub_Parent__r.Type__c,Account.NCM_Management_Group__r.Type__c,Account.NCM_20_Group_2__r.Type__c FROM Opportunity WHERE AccountId!= Null AND Type__c = \'NCM\' AND Contract_Signed_Date__c != null AND StageName =\'Enrollment Pending\' ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope) 
    {
        
            Set<String> setAccountIds = new Set<String>();
             List<Opportunity> listOpportunityToUpdates = new List<Opportunity>();
             Set<Opportunity> setOpportunityToUpdates = new Set<Opportunity>();
            For(Opportunity objOpportunity : scope)
            {
                If(objOpportunity.Account.Sub_Parent__c != null && objOpportunity.Account.Sub_Parent__r.Type__c != null)
                {
                    if(objOpportunity.Account.Sub_Parent__r.Type__c.contains('NCM 20 Group'))
                        setAccountIds.add(objOpportunity.Account.Sub_Parent__c);   
                }
                If(objOpportunity.Account.NCM_Management_Group__c != null && objOpportunity.Account.NCM_Management_Group__r.Type__c != null)
                {
                    if(objOpportunity.Account.NCM_Management_Group__r.Type__c.contains('NCM 20 Group'))
                        setAccountIds.add(objOpportunity.Account.NCM_Management_Group__c );   
                }
                If(objOpportunity.Account.NCM_20_Group_2__c != null && objOpportunity.Account.NCM_20_Group_2__r.Type__c != null)
                {
                    if(objOpportunity.Account.NCM_20_Group_2__r.Type__c.contains('NCM 20 Group'))
                        setAccountIds.add(objOpportunity.Account.NCM_20_Group_2__c);   
                }
            }
            system.debug('setAccountIds ======================> ' + setAccountIds);
            
            Map<String, List<ID>> mapNCM20GroupCodeAndAccounts = new Map<String, List<ID>>();
            
            
            If(!setAccountIds.isEmpty())
            {
                List<Account> listChildAccounts = [SELECT Id, Name, Count_NCM_20_Group__c, Count_NCM_Management_Group__c, 
                                                   Count_NCM_20_Group_2__c,Count_NCM_Total__c
                                                   FROM Account 
                                                   WHERE Id IN : setAccountIds];
                system.debug('listChildAccounts ======================> ' + listChildAccounts);
                
                For(Account objAccount : listChildAccounts)
                {
                    If(objAccount.Name != null && objAccount.Name.indexOf('(') != -1)
                    {
                        String theString = objAccount.Name;
                        String[] sVal = New String[]{};
                            sVal = theString.split('\\(');
                        String finalString = sVal[1].subString(0,sVal[1].length()-1);
                        
                        If(!mapNCM20GroupCodeAndAccounts.containsKey(finalString))
                        {
                            mapNCM20GroupCodeAndAccounts.put(finalString, new List<ID>());
                        }
                        
                        mapNCM20GroupCodeAndAccounts.get(finalString).add(objAccount.ID);
                        
                    }
                }                
                system.debug('mapNCM20GroupCodeAndAccounts ======================> ' + mapNCM20GroupCodeAndAccounts.keySet());
                
                for(String NCM20GroupCode: mapNCM20GroupCodeAndAccounts.keySet())
                {
                    List<Opportunity> listOpportunityUpdates = new List<Opportunity>();
                 
                    Integer count = 0;
                    Integer countNCMGroupManagement = 0;
                    Integer countNCM20Group2 = 0;
                    Integer total = 0;
                 
                    For(Opportunity objOpportunity : scope)
                    {                   
                        List<ID> accIdList = mapNCM20GroupCodeAndAccounts.get(NCM20GroupCode);
                        if(objOpportunity.NCM_20_Group_Code__c == NCM20GroupCode && objOpportunity.Account.Sub_Parent__c != null )
                        {
                            if(accIdList.contains(objOpportunity.Account.Sub_Parent__c))
                            {
                                count++;
                                listOpportunityUpdates.add(objOpportunity);
                            }
                        }
                        if(objOpportunity.NCM_20_Group_Code__c == NCM20GroupCode && objOpportunity.Account.NCM_Management_Group__c != null)
                        {
                            if(accIdList.contains(objOpportunity.Account.NCM_Management_Group__c))
                            {
                                countNCMGroupManagement++;
                                listOpportunityUpdates.add(objOpportunity);
                            }
                        }
                        if(objOpportunity.NCM_20_Group_Code__c == NCM20GroupCode && objOpportunity.Account.NCM_20_Group_2__c != null)
                        {
                            if(accIdList.contains(objOpportunity.Account.NCM_20_Group_2__c))
                            {
                                countNCM20Group2++;
                                listOpportunityUpdates.add(objOpportunity);
                            }
                        }                        
                    
                    }                    
                    
                    total = count + countNCMGroupManagement + countNCM20Group2;
                    system.debug('mapNCM20GroupCodeAndAccounts.get(NCM20GroupCode) ======================> ' + mapNCM20GroupCodeAndAccounts.get(NCM20GroupCode));
                    system.debug('NCM20GroupCode = '+NCM20GroupCode);
                    system.debug('count = '+count);
                    system.debug('countNCMGroupManagement = '+countNCMGroupManagement);
                    system.debug('countNCM20Group2 = '+countNCM20Group2);
                    system.debug('total = '+total);
                    system.debug('listOpportunityUpdates = '+listOpportunityUpdates);
                    
                    For(Account objAccount : listChildAccounts)
                    {
                        If(mapNCM20GroupCodeAndAccounts.get(NCM20GroupCode).contains(objAccount.id))
                        {
                            If(objAccount.Count_NCM_20_Group__c != null && (objAccount.Count_NCM_Total__c > 10 || objAccount.Count_NCM_Total__c == 10))
                            {
                                objAccount.Count_NCM_20_Group__c = objAccount.Count_NCM_20_Group__c + count;
                                //objAccount.Count_NCM_20_Group__c = count;
                            }
                            else{objAccount.Count_NCM_20_Group__c = count;}
                            If(objAccount.Count_NCM_Management_Group__c != null && (objAccount.Count_NCM_Total__c > 10 || objAccount.Count_NCM_Total__c == 10))
                            {
                                objAccount.Count_NCM_Management_Group__c = objAccount.Count_NCM_Management_Group__c + countNCMGroupManagement;
                                //objAccount.Count_NCM_Management_Group__c = countNCMGroupManagement;
                            }
                            else{objAccount.Count_NCM_Management_Group__c = countNCMGroupManagement;}
                            If(objAccount.Count_NCM_20_Group_2__c != null && (objAccount.Count_NCM_Total__c > 10 || objAccount.Count_NCM_Total__c == 10))
                            {
                                objAccount.Count_NCM_20_Group_2__c = objAccount.Count_NCM_20_Group_2__c + countNCM20Group2;
                                //objAccount.Count_NCM_20_Group_2__c = countNCM20Group2;
                            }
                            else{objAccount.Count_NCM_20_Group_2__c = countNCM20Group2;}
                            
                            If(total > 10 || total == 10 || objAccount.Count_NCM_Total__c > 10 || objAccount.Count_NCM_Total__c == 10)
                            { 
                                for(Opportunity objOpportunity : listOpportunityUpdates){
                                    if(objOpportunity.StageName == 'Enrollment Pending'){
                                        objOpportunity.StageName='Onboarding';
                                        setOpportunityToUpdates.add(objOpportunity);
                                    }                                      
                                }
                            }
                            
                            listOpportunityToUpdates = new List<Opportunity>(setOpportunityToUpdates);
                        }
                    }
                }
                system.debug('listChildAccounts ======================> ' + listChildAccounts);
                system.debug('listOpportunityToUpdates ======================> ' + listOpportunityToUpdates);
                
                
                If(!listChildAccounts.isEmpty())
                {
                     UPDATE listChildAccounts;
                }
                If(!listOpportunityToUpdates.isEmpty())
                {
                    UPDATE listOpportunityToUpdates;
                }
            }
        
    }
    
    
    
    global void finish(Database.BatchableContext BC) 
    {
        // execute any post-processing operations
    }
}