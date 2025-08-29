trigger CampaignTrigger on Campaign__c (After insert) {
    if(Trigger.IsAfter && Trigger.IsInsert){
        List<Campaign_List_Item__c>CampList = new list<Campaign_List_Item__c>();
        Map<String,String> nameMap  = CampaignTabLabelMap.setMap();
        
        for(Campaign__c obj: Trigger.new){
            
            for(String key :nameMap.keySet()){
                Campaign_List_Item__c campListItem = new Campaign_List_Item__c();
                campListItem.Campaigns__c = obj.Id;
                campListItem.Name__c = key;
                if(nameMap.get(key).split(',')[0] == 'Standard'){
                    campListItem.Date_3__c = obj.Requested_Launch_Date__c;
                }
                campListItem.Type__c = nameMap.get(key).split(',')[0];
                campListItem.Stage__c = nameMap.get(key).split(',')[1];
                campListItem.SLA__c = decimal.valueOf(nameMap.get(key).split(',')[2]);
                CampList.add(campListItem);
            }
        }
        insert CampList;
    }
}