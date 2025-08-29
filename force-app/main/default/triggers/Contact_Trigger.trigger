trigger Contact_Trigger on Contact (After update) {
    
    if(Trigger.isUpdate && Trigger.isAfter && !TriggerUpdate.firstcall){
       
        //list<AccountContactRelation> accConList = new list<AccountContactRelation>();
         list<AccountContactRelation> accConListDirect = new list<AccountContactRelation>();
       
        set<Id> conId = new set<Id>();
        for(Contact obj : trigger.new){
            if((trigger.newMap.get(obj.Id).Active__c != trigger.oldMap.get(obj.Id).Active__c || trigger.newMap.get(obj.Id).AccountId != trigger.oldMap.get(obj.Id).AccountId) &&  trigger.newMap.get(obj.Id).Active__c == false  ){
                conId.add(obj.Id);
            }
        }
        if(!conId.isEmpty() && conId != null){
           // accConList = [select id from AccountContactRelation where ContactId In:conId and IsDirect = false];
            accConListDirect = [select id,Contact.AccountId,ContactId,Roles,IsDirect from AccountContactRelation where ContactId In:conId AND IsDirect = true];
            list<Contact> conList = new list<Contact>();
            String customLabelValue = System.Label.InActive_Contact;
            System.debug('=customLabelValue=='+customLabelValue);
            Account acc = [Select id from Account where Name =: customLabelValue];
            for(AccountContactRelation accObj :accConListDirect){
                if(accObj.IsDirect == true){
                    Contact con = new Contact();
                    con.AccountId = acc.Id;
                    con.Id = accObj.ContactId;
                    conList.add(con);
                    accObj.Roles = null;
                }
                
            }
            TriggerUpdate.firstcall = true;
            if(!conList.isEmpty()){
                update accConListDirect;
                update conList;
                // delete accConListDirect;
                
                
                Database.DeleteResult[] drList = Database.delete(accConListDirect, false);
                
                // Iterate through each returned result
                for(Database.DeleteResult dr : drList) {
                    if (dr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully deleted AccountContactRelation with ID: ' + dr.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : dr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('AccountContactRelation fields that affected this error: ' + err.getFields());
                        }
                    }
                }
               
            }
           
         // System.debug('=accConList=='+accConList);
          //  delete accConList;
        }
    }
}