public class CampaignRecordCreated {
@AuraEnabled
    public static opportunity createCampaign(String oppId){
        opportunity opp = new opportunity();
        opp.Id = oppId;
        opp.Campaign_Created__c = true;
        update opp;
        return opp;
    }
}