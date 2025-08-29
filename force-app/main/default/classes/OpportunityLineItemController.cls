public class OpportunityLineItemController {
    
    @AuraEnabled
    public static List<OpportunityLineItem> getProduct(Id objIds){
        String sObjName = objIds.getSObjectType().getDescribe().getName();
        System.debug('==sObjName=='+sObjName);
        list<Opportunity> opp = new  list<Opportunity>();
        List<OpportunityLineItem> productList = new List<OpportunityLineItem>();
        if(sObjName == 'Account'){
            System.debug('==sObjName10=='+sObjName);
            // Account acc = [Select ID from Account where Id=:accIds];
             opp = [Select ID, AccountID,Stagename,Createddate from Opportunity 
                               where AccountID =: objIds AND Stagename='Live' Order By Createddate DESC];
        }
        else if(sObjName == 'Onboarding__c'){
            System.debug('==sObjName=16='+sObjName);
            Onboarding__c onboardingObj =[select id,Opportunity__c from Onboarding__c where Id =: objIds];
            opp = [Select ID, AccountID,Stagename,Createddate from Opportunity 
                   where Id =: onboardingObj.Opportunity__c 
                   Order By Createddate DESC];
            
        }
        if(opp != null && !opp.isEmpty()){
             productList = [SELECT Id, OpportunityId,Name,MRR__c,Profit_center_new__c,Profit_center_service__c,
                                                     Profit_center_used__c FROM OpportunityLineItem WHERE OpportunityId IN :opp];
            
        }
            return productList;
    }
}