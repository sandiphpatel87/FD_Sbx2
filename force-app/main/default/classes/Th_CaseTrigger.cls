public class Th_CaseTrigger 
{
	public static void onAfterUpdate(Map<Id, Case> mapNewCases, Map<Id, Case> mapOldCases)
    {
        If(!mapNewCases.isEmpty())
        {
            Set<String> setAccountIds = new Set<String>();
                        
            For(Case objCase : mapNewCases.values())
            {
                If(objCase.AccountId != null && objCase.Request_Type__c != null && objCase.Request_Type__c == 'Performance Review')
                {
                    setAccountIds.add(objCase.AccountId);
                }
            }
            
            If(!setAccountIds.isEmpty())
            {
                List<Account> listAccounts = [SELECT Id, 
                                              (SELECT Id, Is_this_client_at_risk_for_cancellation__c 
                                               FROM Cases 
                                               WHERE Request_Type__c = 'Performance Review' 
                                               ORDER BY Createddate DESC LIMIT 1
                                              ) 
                                              FROM Account 
                                              WHERE Id IN : setAccountIds
                                             ];
                
                If(!listAccounts.isEmpty())
                {
                    For(Account objAccount : listAccounts)
                    {
                        If(objAccount.Cases != null && !objAccount.Cases.isEmpty())
                        {                            
                            If(mapOldCases.containsKey(objAccount.Cases[0].Id) && 
                               mapNewCases.containsKey(objAccount.Cases[0].Id) && 
                               mapNewCases.get(objAccount.Cases[0].Id).Is_this_client_at_risk_for_cancellation__c == 'Yes' && 
                               mapNewCases.get(objAccount.Cases[0].Id).Is_this_client_at_risk_for_cancellation__c != mapOldCases.get(objAccount.Cases[0].Id).Is_this_client_at_risk_for_cancellation__c)
                            {
                                objAccount.Case_Risk_For_Cancellation__c = true;
                            }
                            Else If(mapOldCases.containsKey(objAccount.Cases[0].Id) && 
                               mapNewCases.containsKey(objAccount.Cases[0].Id) && 
                               mapNewCases.get(objAccount.Cases[0].Id).Is_this_client_at_risk_for_cancellation__c != 'Yes' && 
                               mapNewCases.get(objAccount.Cases[0].Id).Is_this_client_at_risk_for_cancellation__c != mapOldCases.get(objAccount.Cases[0].Id).Is_this_client_at_risk_for_cancellation__c)
                            {
                                objAccount.Case_Risk_For_Cancellation__c = false;
                            }
                        }
                    }
                    
                    UPDATE listAccounts;
                }
            }
        }
    }
}