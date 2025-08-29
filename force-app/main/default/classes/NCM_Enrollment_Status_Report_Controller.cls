public class NCM_Enrollment_Status_Report_Controller 
{
    @AuraEnabled
    public static List<AccountWrapper> getAccountRelatedOpportunityAndContact(String searchGroupCode, String searchGroupName) 
    {
        List<AccountWrapper> listAccountWrappers = new List<AccountWrapper>();
        
        String query = 'SELECT Id, AccountId FROM  Opportunity WHERE (StageName = \'Onboarding\' OR StageName = \'Contract Sent\') AND (Type__c = \'NCM\' OR Type__c = \'Business Intelligence\')';
        
        If(String.isNotBlank(searchGroupCode))
        {
            query = query + ' AND NCM_20_Group_Code__c =: searchGroupCode';
        }
        
        If(String.isNotBlank(searchGroupName))
        {
            query = query + ' AND NCM_20_Group__c =: searchGroupName';
        }
        
        system.debug('Query : ' + query);
        
        List <Opportunity> listOpportunities = Database.query(query);
        
        If(!listOpportunities.isEmpty())
        {
            Set<String> setAccountIds = new Set<String>();
            
            For(Opportunity objOpportunity : listOpportunities)
            {
                If(objOpportunity.AccountId != null)
                {
                    setAccountIds.add(objOpportunity.AccountId);
                }
            }
            
            If(!setAccountIds.isEmpty())
            {
                List<Account> listAccounts = [SELECT Id, Name, 
                                              (
                                                  SELECT Id, Name, StageName, Contract_Sent_Date__c, Contract_Signed_Date__c, Enrollment_Deadline__c
                                                  FROM Opportunities
                                              ),
                                              (
                                                  SELECT Id, Name, Email FROM Contacts
                                              )
                                              FROM Account 
                                              WHERE Id IN : setAccountIds
                                              ORDER BY Name ASC
                                             ];
                
                For(Account objAccount : listAccounts)
                {
                    AccountWrapper objAccountWrapper = new AccountWrapper();
                    objAccountWrapper.objAccount = objAccount;
                    objAccountWrapper.listOpportunity = objAccount.Opportunities;
                    objAccountWrapper.listContacts = objAccount.Contacts;
                    objAccountWrapper.isShowContacts = objAccount.Contacts.size() > 0 ? true : false;
                    objAccountWrapper.isShowOpportunities = objAccount.Opportunities.size() > 0 ? true : false;
                    listAccountWrappers.add(objAccountWrapper);
                }
            }
        }
        
        return listAccountWrappers;
    }
    
    public class AccountWrapper
    {
        @AuraEnabled
        public Account objAccount;
        @AuraEnabled
        public List<Opportunity> listOpportunity;
        @AuraEnabled
        public List<Contact> listContacts;
        @AuraEnabled
        public Boolean isShowContacts;
        @AuraEnabled
        public Boolean isShowOpportunities;
    }
}