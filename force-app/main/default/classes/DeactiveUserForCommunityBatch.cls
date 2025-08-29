global class DeactiveUserForCommunityBatch implements Database.Batchable<sObject> 
{
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        String query = 'SELECT Id,Contract_Signer_Email__c,Contract_Sent_Date__c,Deactive_Community_User_On__c FROM Opportunity WHERE Deactive_Community_User_On__c = TODAY ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> listOpportunities) 
    {
        List<User> userToUpdate = new List<User>();
        If(!listOpportunities.isEmpty()){
            For(Opportunity objOpportunity : listOpportunities)
            {
                if(objOpportunity.Contract_Signer_Email__c != '')
                {
                    List<User> user=[SELECT Id,FirstName, LastName, UserName,IsActive
                                     From User 
                                     WHERE Email =: objOpportunity.Contract_Signer_Email__c];
                    
                    
                    if(user.size() > 0 )
                    {
                        user[0].IsActive = FALSE;
                        userToUpdate.add(user[0]);
                    }
                }
            }
        } 
        update userToUpdate;
    }
    global void finish(Database.BatchableContext BC) 
    {
        // execute any post-processing operations
    }
}