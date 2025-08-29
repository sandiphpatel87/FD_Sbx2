trigger TaskTrigger on Task (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        list<id> accId = new list<id>();
        for(Task obj : trigger.new){
            if(trigger.newMap.get(obj.Id).Status  != trigger.oldMap.get(obj.Id).Status && trigger.newMap.get(obj.Id).Status == 'Completed' && obj.Subject=='Rollbacks'){
                accId.add(obj.WhatId);
            }
        }
        if(accId != null && !accId.isEmpty()){
        list<Account> accList = [select id,Last_Rollback_Update__c from Account where id In: accId];
            for(Account acc :accList){
                acc.Last_Rollback_Update__c = System.today();
            }
            update accList;
        }
    }
}