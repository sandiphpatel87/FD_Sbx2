trigger getPrimaryContact on AccountContactRelation (before insert,After Insert,before update,After delete,After update) {
    
    List<Account> accList1 = new List<Account>();
    List<Account> accList2 = new List<Account>();
    List<Account> accList3 = new List<Account>();
    Set<ID> accIds = new Set<ID>();
    if(Trigger.isInsert && Trigger.isBefore ){
        for(AccountContactRelation acct: Trigger.new){
            if(acct.Roles != null){
                if(acct.Roles.contains('Primary Contact')){
                    accIds.add(acct.AccountId);
                }
                if(acct.Roles.contains('Secondary contact')){
                    Account acctNew = new Account();
                    acctNew.Id = acct.AccountId;
                    acctNew.Secondary_Contact__c = acct.ContactId;
                    accList2.add(acctNew);
                }
            }  
        }
        if(!accList2.isEmpty()){
            update accList2;
        }
        List<AccountContactRelation> actConRelList =  [Select Id,Roles from AccountContactRelation where AccountId=: accIds AND Roles includes ('Primary Contact')];  
        System.debug('=============role==='+actConRelList);
        if(actConRelList.size() > 0){
            system.debug(' account have primary contact');
            // Add error here
            trigger.new[0].Roles.addError('Primary Contact already Exist');
        }else{
            system.debug('You r in else condition');
            for(AccountContactRelation acct: Trigger.new){
                if(acct.Roles != null){
                    if(acct.Roles.contains('Primary Contact')){
                        Account acctNew = new Account();
                        acctNew.Id = acct.AccountId;
                        acctNew.Primary_contact__c = acct.ContactId;
                        accList1.add(acctNew);
                        system.debug('You r in Primary' + accList1);
                    }
                }
            }
            if(!accList1.isEmpty()){
                update accList1; 
            }
        }
    }
      if( Trigger.isUpdate && Trigger.isbefore){
          set<Id> accConId = new set<Id>();
        for(AccountContactRelation acct: Trigger.new){
            accConId.add(acct.Id);
            if(acct.Roles != null){
                if(acct.Roles.contains('Primary Contact')){
                    accIds.add(acct.AccountId);
                }
                if(acct.Roles.contains('Secondary contact')){
                    Account acctNew = new Account();
                    acctNew.Id = acct.AccountId;
                    acctNew.Secondary_Contact__c = acct.ContactId;
                    accList2.add(acctNew);
                }
            }  
        }
        if(!accList2.isEmpty()){
            update accList2;
        }
        List<AccountContactRelation> actConRelList =  [Select Id,Roles from AccountContactRelation where AccountId=: accIds AND Roles includes ('Primary Contact') and Id !=: accConId];  
        System.debug('=============role==='+actConRelList);
        if(actConRelList.size() > 0){
            system.debug(' account have primary contact');
            // Add error here
            trigger.new[0].Roles.addError('Primary Contact already Exist');
        }else{
            system.debug('You r in else condition');
            for(AccountContactRelation acct: Trigger.new){
                if(acct.Roles != null){
                    if(acct.Roles.contains('Primary Contact')){
                        Account acctNew = new Account();
                        acctNew.Id = acct.AccountId;
                        acctNew.Primary_contact__c = acct.ContactId;
                        accList1.add(acctNew);
                        system.debug('You r in Primary' + accList1);
                    }
                }
            }
            if(!accList1.isEmpty()){
                update accList1; 
            }
        }
    }
    if(Trigger.isAfter && trigger.isdelete){
          list<AccountContactRelation> accConList = new list<AccountContactRelation>();
        for(AccountContactRelation acct: Trigger.old){
            if(acct.Roles != null){
                if(acct.Roles.contains('Secondary contact') && acct.Roles.contains('Primary Contact')){
                    Account acctNew = new Account();
                    acctNew.Id = acct.AccountId;
                    acctNew.Secondary_Contact__c = null;
                    acctNew.Primary_contact__c = null;
                    accList3.add(acctNew);
                }
                else if(acct.Roles.contains('Secondary contact')){
                    Account acctNew = new Account();
                    acctNew.Id = acct.AccountId;
                    acctNew.Secondary_Contact__c = null;
                    accList3.add(acctNew);
                }
                else if(acct.Roles.contains('Primary Contact')){
                    Account acctNew = new Account();
                    acctNew.Id = acct.AccountId;
                    acctNew.Primary_contact__c = null;
                    accList3.add(acctNew);
                }
                if(acct.Roles.contains('Secondary contact') || acct.Roles.contains('Primary Contact')){
                   accConList.add(acct);
                }
            }
            
        }
         if(!accConList.isEmpty()){
            getPrimaryContactHelper.DeleteRelatedContact(accConList);
        }
        if(!accList3.isEmpty()){
            update accList3;
        }
    }
    if(Trigger.isInsert && Trigger.isAfter){
        getPrimaryContactHelper.updateRelatedContact(Trigger.New);
    }
    if(Trigger.isUpdate && Trigger.isAfter){
        list<AccountContactRelation> accConList = new list<AccountContactRelation>();
        for( AccountContactRelation obj : Trigger.new ) {
            if( Trigger.oldMap.get( obj.Id ).Roles != Trigger.newMap.get( obj.Id  ).Roles  ){
                accConList.add(obj);
                
            }
        }
        if(!accConList.isEmpty()){
            getPrimaryContactHelper.removeRelatedContact(accConList);
        }
    }
}