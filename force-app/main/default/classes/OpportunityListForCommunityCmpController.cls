public class OpportunityListForCommunityCmpController {
    
    @AuraEnabled
    public static List<Opportunity> getOpportunities(Id loggedInUserId){

       List<User> lstUser = [Select Id,ContactId,Contact.Email from User where Id = :loggedInUserId];
        if(lstUser.size() > 0)
        {
             
           //List<Contact> contact = [Select Id,AccountId,Email from Contact where Id = :lstUser[0].ContactId];
            
            List<AccountContactRelation> accConRelList= [SELECT Id,AccountId,Roles,Contact.AccountId  
                                                                 FROM AccountContactRelation 
                                                                 //WHERE ContactId  =: lstUser[0].ContactId 
                                                         Where Contact.Email =: lstUser[0].Contact.Email];
                                                                 //AND Roles includes ('Contract Signer')];
            set<ID> setAccId = new Set<Id>();
            for(AccountContactRelation accRel: accConRelList)
            {
                setAccId.add(accRel.AccountId);
            }
            system.debug('setAccId ---------------'+setAccId);
            if(accConRelList.size() > 0){
                List<Opportunity> opportunityList = [SELECT  Id,Name,Account.Name,CreatedDate,Contract_Signed_Date__c,PDF_File_ID__c
                                                     FROM Opportunity 
                                                     WHERE AccountId =:setAccId 
                                                     AND Type__c = 'NCM' AND (StageName ='Contract Sent'      OR
                                                                              StageName ='Enrollment Pending' OR 
                                                                              StageName ='Onboarding'         OR 
                                                                              StageName ='Live')
                                                     ORDER BY CreatedDate  DESC];
                
                return opportunityList;
            }else
            {
           	List<Opportunity> opportunityList = new List<Opportunity> ();
            return opportunityList;
            }
        }
        else{
            List<Opportunity> opportunityList = new List<Opportunity> ();
            
            return opportunityList;
        }
       
    }
}