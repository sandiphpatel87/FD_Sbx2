public class AccountContactRelationTriggerHelper {
    
    public static void onBeforeInsert(List<AccountContactRelation> listAccountContactRelations, Map<Id, AccountContactRelation> mapAccountContactRelation)
    {
        List<Account> accList1 = new List<Account>();
        List<Account> accList2 = new List<Account>();
        Set<ID> accIds = new Set<ID>();
        Set<ID> accIdsbilling = new Set<ID>();
        Set<ID> accIdscontract = new Set<ID>();
        Map<Id, Account> accountUpdateMap = new Map<Id, Account>();
        
        for(AccountContactRelation acct: listAccountContactRelations){
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
                if(acct.Roles.contains('Billing')){
                    accIdsbilling.add(acct.AccountId);
                }
                if(acct.Roles.contains('Contract Signer')){
                    accIdscontract.add(acct.AccountId);
                }
            }  
        }
        if(!accList2.isEmpty()){
            update accList2;
        }
        List<AccountContactRelation> actConRelList =  [Select Id,Roles from AccountContactRelation where AccountId=: accIds AND Roles includes ('Primary Contact') ];  
        System.debug('=============role==='+actConRelList);
        if(actConRelList.size() > 0){
            system.debug(' account have primary contact');
            // Add error here
            if(listAccountContactRelations[0].Roles.contains('Primary Contact')){
                listAccountContactRelations[0].Roles.addError('Primary Contact already Exist');
            }
            
        }
        else{
            system.debug('You r in else condition');
            for(AccountContactRelation acct: listAccountContactRelations){
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
        
        List<AccountContactRelation> actConRelListBilling =  [Select Id,Roles from AccountContactRelation where AccountId=: accIdsbilling AND Roles includes ('Billing') ];  
        System.debug('=============role==='+actConRelListBilling);
        if(actConRelListBilling.size() > 0){
            system.debug(' account have Billing contact');
            // Add error here
            if(listAccountContactRelations[0].Roles.contains('Billing')){
                //listAccountContactRelations[0].Roles.addError('Billing Contact already Exist');
            }
            
        }
        else{
            system.debug('You r in else condition');
            for(AccountContactRelation acct: listAccountContactRelations){
                if(acct.Roles != null){
                    if(acct.Roles.contains('Billing')){
                        if(!accountUpdateMap.containsKey(acct.AccountId)){
                            Account acctNew = new Account();
                            acctNew.Id = acct.AccountId;
                            acctNew.Billing_Contact__c = acct.ContactId;
                            accountUpdateMap.put(acct.AccountId, acctNew);
                        }
                        else{
                            (accountUpdateMap.get(acct.AccountId)).Billing_Contact__c = acct.ContactId;
                        }
                        //accList1.add(acctNew);
                        //system.debug('You r in Billing' + accList1);
                    }
                }
            }
            system.debug('accountUpdateMap ='+accountUpdateMap);
            if(accountUpdateMap.keyset().size() > 0){
                Account acc = accountUpdateMap.values();
                update acc;
            }
            /*if(!accList1.isEmpty()){
update accList1; 
}*/
        }
        
        List<AccountContactRelation> actConRelListContract =  [Select Id,Roles from AccountContactRelation where AccountId=: accIdscontract AND Roles includes ('Contract Signer') ];  
        System.debug('=============role==='+actConRelListContract);
        if(actConRelListContract.size() > 0){
            system.debug(' account have Contract Signer contact');
            // Add error here
            if(listAccountContactRelations[0].Roles.contains('Contract Signer')){
                listAccountContactRelations[0].Roles.addError('Contract Signer already Exist');
            }
            
        }
        else{
            system.debug('You r in else condition');
            for(AccountContactRelation acct: listAccountContactRelations){
                if(acct.Roles != null){
                    if(acct.Roles.contains('Contract Signer')){
                        if(!accountUpdateMap.containsKey(acct.AccountId)){
                            Account acctNew = new Account();
                            acctNew.Id = acct.AccountId;
                            acctNew.Contract_Signer__c = acct.ContactId;
                            accountUpdateMap.put(acct.AccountId, acctNew);
                        }
                        else{
                            (accountUpdateMap.get(acct.AccountId)).Contract_Signer__c = acct.ContactId;
                        }
                    }
                }
            }
            system.debug('accountUpdateMap ='+accountUpdateMap);
            if(accountUpdateMap.keyset().size() > 0){
                Account acc = accountUpdateMap.values();
                update acc;
            }
            /*if(!accList1.isEmpty()){
update accList1; 
}*/
        }
    }
    
    public static void onAfterInsert(List<AccountContactRelation> listAccountContactRelations)
    {
        updateRelatedContact(listAccountContactRelations);
        List<OpportunityContactRole> listOpportunityContactRole = new LIST<OpportunityContactRole>();
        for(AccountContactRelation accRel : listAccountContactRelations)
        {
            List<Opportunity> lstOpportunity =[SELECT ID FROM Opportunity WHERE AccountId=:accRel.AccountId];
            for(Opportunity opp: lstOpportunity ){
                OpportunityContactRole OppContactRole = new OpportunityContactRole();
                OppContactRole.OpportunityId = opp.Id;
                OppContactRole.Roles__c = accRel.Roles;
                OppContactRole.ContactId = accRel.ContactId;
                OppContactRole.Account__c = accRel.AccountId;
                listOpportunityContactRole.add(OppContactRole);
            }
        }
        insert listOpportunityContactRole;
    }
    
    public static void onBeforeUpdate(List<AccountContactRelation> listAccountContactRelations, Map<Id, AccountContactRelation> mapAccountContactRelation)
    {
        List<Account> accList1 = new List<Account>();
        List<Account> accList2 = new List<Account>();
        Set<ID> accIds = new Set<ID>();
        Set<ID> accIdsbilling = new Set<ID>();
        Set<ID> accIdscontract = new Set<ID>();
        set<ID> accConId = new set<ID>();
        Map<Id, Account> accountUpdateMap = new Map<Id, Account>();
        
        for(AccountContactRelation acct: listAccountContactRelations){
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
                //system.debug('(mapAccountContactRelation.get(acct.Id).Roles.contains(Billing)) = ' + (mapAccountContactRelation.get(acct.Id).Roles.contains('Billing')));
                if(acct.Roles.contains('Billing')){
                    accIdsbilling.add(acct.AccountId);
                }
                if(acct.Roles.contains('Contract Signer')){
                    accIdscontract.add(acct.AccountId);
                }
                if(mapAccountContactRelation.get(acct.Id).Roles != null)
                {
                    
                    if ( 
                        ((!(acct.Roles.contains('Billing'))) == (mapAccountContactRelation.get(acct.Id).Roles.contains('Billing'))) || 
                        ((!(acct.Roles.contains('Contract Signer'))) == (mapAccountContactRelation.get(acct.Id).Roles.contains('Contract Signer'))))
                    {
                        if(mapAccountContactRelation.get(acct.Id).Roles.contains('Billing')){
                            Account acctNew = new Account();
                            acctNew.Id = acct.AccountId;
                            acctNew.Billing_Contact__c = null;
                            accList2.add(acctNew);
                        }
                        else if(mapAccountContactRelation.get(acct.Id).Roles.contains('Contract Signer'))  
                        {
                            Account acctNew = new Account();
                            acctNew.Id = acct.AccountId;
                            acctNew.Contract_Signer__c = null;
                            accList2.add(acctNew);
                        }
                        
                    }
                }
            } 
            if(mapAccountContactRelation.get(acct.Id).Roles != null)
            {
                
                if ( (acct.Roles == null && mapAccountContactRelation.get(acct.Id).Roles.contains('Billing')) ||  
                    (acct.Roles == null && mapAccountContactRelation.get(acct.Id).Roles.contains('Contract Signer')))
                {
                    
                    if(mapAccountContactRelation.get(acct.Id).Roles.contains('Billing') && mapAccountContactRelation.get(acct.Id).Roles.contains('Contract Signer')){
                        Account acctNew = new Account();
                        acctNew.Id = acct.AccountId;
                        acctNew.Billing_Contact__c = null;
                        acctNew.Contract_Signer__c = null;
                        accList2.add(acctNew);
                    }
                    else if(mapAccountContactRelation.get(acct.Id).Roles.contains('Billing')){
                        Account acctNew = new Account();
                        acctNew.Id = acct.AccountId;
                        acctNew.Billing_Contact__c = null;
                        accList2.add(acctNew);
                    }
                    else  
                    {
                        Account acctNew = new Account();
                        acctNew.Id = acct.AccountId;
                        acctNew.Contract_Signer__c = null;
                        accList2.add(acctNew);
                    }
                    
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
            listAccountContactRelations[0].Roles.addError('Primary Contact already Exist');
        }
        else{
            system.debug('You r in else condition');
            for(AccountContactRelation acct: listAccountContactRelations){
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
        
        List<AccountContactRelation> actConRelListBilling =  [Select Id,Roles from AccountContactRelation where AccountId=: accIdsbilling AND Roles includes ('Billing') and Id !=: accConId];  
        System.debug('=============role==='+actConRelListBilling);
        if(actConRelListBilling.size() > 0){
            system.debug(' account have billing contact');
            // Add error here
            //listAccountContactRelations[0].Roles.addError('Billing Contact already Exist');
        }
        else{
            system.debug('You r in else condition');
            for(AccountContactRelation acct: listAccountContactRelations){
                if(acct.Roles != null){
                    if(acct.Roles.contains('Billing')){
                        if(!accountUpdateMap.containsKey(acct.AccountId)){
                            Account acctNew = new Account();
                            acctNew.Id = acct.AccountId;
                            acctNew.Billing_Contact__c = acct.ContactId;
                            accountUpdateMap.put(acct.AccountId, acctNew);
                        }
                        else{
                            (accountUpdateMap.get(acct.AccountId)).Billing_Contact__c = acct.ContactId;
                        }
                    }
                }
            }
            system.debug('accountUpdateMap ='+accountUpdateMap);
            if(accountUpdateMap.keyset().size() > 0){
                Account acc = accountUpdateMap.values();
                update acc;
            }
            /*if(!accList1.isEmpty()){
update accList1; 
}*/
        }
        
        List<AccountContactRelation> actConRelListContract =  [Select Id,Roles from AccountContactRelation where AccountId=: accIdscontract AND Roles includes ('Contract Signer') and Id !=: accConId];  
        System.debug('=============role==='+actConRelListContract);
        if(actConRelListContract.size() > 0){
            system.debug(' account have Contract Signer contact');
            // Add error here
            listAccountContactRelations[0].Roles.addError('Contract Signer Contact already Exist');
        }
        else{
            system.debug('You r in else condition');
            for(AccountContactRelation acct: listAccountContactRelations){
                if(acct.Roles != null){
                    if(acct.Roles.contains('Contract Signer')){
                        if(!accountUpdateMap.containsKey(acct.AccountId)){
                            Account acctNew = new Account();
                            acctNew.Id = acct.AccountId;
                            acctNew.Contract_Signer__c = acct.ContactId;
                            accountUpdateMap.put(acct.AccountId, acctNew);
                        }
                        else{
                            (accountUpdateMap.get(acct.AccountId)).Contract_Signer__c = acct.ContactId;
                        }
                    }
                }
            }
            system.debug('accountUpdateMap ='+accountUpdateMap);
            System.debug('keyset = '+ accountUpdateMap.keyset());
            System.debug('keyset = '+ accountUpdateMap.keyset().SIZE());
            if(accountUpdateMap.keyset().size() > 0){
                Account acc = accountUpdateMap.values();
                update acc;
            }
            /*if(!accList1.isEmpty()){
update accList1; 
}*/
        }
    }
    
    public static void onAfterUpdate(List<AccountContactRelation> listAccountContactRelations, Map<Id, AccountContactRelation> newMapAccountContactRelation, Map<Id, AccountContactRelation> oldMapAccountContactRelation)
    {
        list<AccountContactRelation> accConList = new list<AccountContactRelation>();
        for( AccountContactRelation obj : listAccountContactRelations ) {
            if( oldMapAccountContactRelation.get( obj.Id ).Roles != newMapAccountContactRelation.get( obj.Id  ).Roles  ){
                /*if(   (oldMapAccountContactRelation.get( obj.Id ).Roles.contains('Primary Contact')   && ((newMapAccountContactRelation.get( obj.Id ).Roles =='') || (!(newMapAccountContactRelation.get( obj.Id ).Roles.contains('Primary Contact')))))
|| (oldMapAccountContactRelation.get( obj.Id ).Roles.contains('Secondary contact') && ((newMapAccountContactRelation.get( obj.Id ).Roles =='') || (!(newMapAccountContactRelation.get( obj.Id ).Roles.contains('Secondary contact')))))
|| (newMapAccountContactRelation.get( obj.Id ).Roles.contains('Primary Contact')   && ((oldMapAccountContactRelation.get( obj.Id ).Roles =='') || (!(oldMapAccountContactRelation.get( obj.Id ).Roles.contains('Primary Contact')))))
|| (newMapAccountContactRelation.get( obj.Id ).Roles.contains('Secondary contact') && ((oldMapAccountContactRelation.get( obj.Id ).Roles =='') || (!(oldMapAccountContactRelation.get( obj.Id ).Roles.contains('Secondary contact')))))
)*/
                {
                    accConList.add(obj);
                }
            }
        }
        if(!accConList.isEmpty()){
            removeRelatedContact(accConList);
        }
        
        List<OpportunityContactRole> listOpportunityContactRole = new LIST<OpportunityContactRole>();
        List<OpportunityContactRole> listOpportunityContactRoleToInsert = new LIST<OpportunityContactRole>();
        
        for(AccountContactRelation accRel : listAccountContactRelations)
        {
            List<OpportunityContactRole> lstOpportunityContactRole =[SELECT ID,Roles__c FROM OpportunityContactRole WHERE 
                                                                     Account__c=:accRel.AccountId AND ContactId =: accRel.ContactId];
            if(lstOpportunityContactRole.size()>0){
                for(OpportunityContactRole opp: lstOpportunityContactRole ){
                    opp.Roles__c = accRel.Roles;
                    listOpportunityContactRole.add(opp);
                }
            }
            else{
                
                List<Opportunity> lstOpportunity =[SELECT ID FROM Opportunity WHERE AccountId=:accRel.AccountId];
                for(Opportunity opp: lstOpportunity ){
                    OpportunityContactRole OppContactRole = new OpportunityContactRole();
                    OppContactRole.OpportunityId = opp.Id;
                    OppContactRole.Roles__c = accRel.Roles;
                    OppContactRole.ContactId = accRel.ContactId;
                    OppContactRole.Account__c = accRel.AccountId;
                    listOpportunityContactRoleToInsert.add(OppContactRole);
                }
            }
        }
        insert listOpportunityContactRoleToInsert;
        update listOpportunityContactRole;
    }
    
    public static void onAfterDelete(List<AccountContactRelation> listAccountContactRelations)
    {
        List<Account> accList3 = new List<Account>();
        
        list<AccountContactRelation> accConList = new list<AccountContactRelation>();
        for(AccountContactRelation acct: listAccountContactRelations){
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
                else if(acct.Roles.contains('Billing') && acct.Roles.contains('Contract Signer')){
                    Account acctNew = new Account();
                    acctNew.Id = acct.AccountId;
                    acctNew.Billing_Contact__c = null;
                    acctNew.Contract_Signer__c = null;
                    accList3.add(acctNew);
                }
                else if(acct.Roles.contains('Billing')){
                    Account acctNew = new Account();
                    acctNew.Id = acct.AccountId;
                    acctNew.Billing_Contact__c = null;
                    accList3.add(acctNew);
                }
                else if(acct.Roles.contains('Contract Signer')){
                    Account acctNew = new Account();
                    acctNew.Id = acct.AccountId;
                    acctNew.Contract_Signer__c = null;
                    accList3.add(acctNew);
                }
                if(acct.Roles.contains('Secondary contact') || acct.Roles.contains('Primary Contact')){
                    accConList.add(acct);
                }
            }
            
        }
        if(!accConList.isEmpty()){
            DeleteRelatedContact(accConList);
        }
        if(!accList3.isEmpty()){
            update accList3;
        }
        
        
        List<OpportunityContactRole> listOpportunityContactRole = new LIST<OpportunityContactRole>();
        for(AccountContactRelation accRel : listAccountContactRelations)
        {
            List<OpportunityContactRole> lstOpportunityContactRole =[SELECT ID,Roles__c FROM OpportunityContactRole WHERE 
                                                                     Account__c=:accRel.AccountId AND ContactId =: accRel.ContactId];
            for(OpportunityContactRole opp: lstOpportunityContactRole ){
                listOpportunityContactRole.add(opp);
            }
        }
        delete listOpportunityContactRole;
    }
    
    public static void updateRelatedContact(list<AccountContactRelation> accConRelation){
        list<id> ConId = new list<Id>();
        set<Id>accId = new set<Id>();
        map<Id,list<AccountContactRelation>> mapOfConRelation = new  map<Id,list<AccountContactRelation>>();
        for(AccountContactRelation obj : accConRelation){
            ConId.add(obj.ContactId);
            accId.add(obj.AccountId);
            if (mapOfConRelation.containsKey(obj.ContactId)) {
                mapOfConRelation.get(obj.ContactId).add(obj); 
            } else {
                List < AccountContactRelation > lstcnts = new List < AccountContactRelation > ();
                lstcnts.add(obj);
                mapOfConRelation.put(obj.ContactId, lstcnts);
            }
        }
        List<contact>conList = [select id,Primary_Contact__c,Secondary_Contact__c,Primary_Account__c,Secondary_Account__c from contact where Id In:ConId];
        Map<Id,Account> accountMap = new Map<Id,Account>([Select id, Name From Account Where Id IN :accId]);
        
        for(Contact con : conList){
            String primaryAccount ='';
            String secondaryAccount='';
            if(mapOfConRelation.containsKey(con.Id) ){
                for(AccountContactRelation obj :mapOfConRelation.get(con.Id)){
                    if(con.Id == obj.ContactId && obj.Roles !=null && obj.Roles !='()'){
                        if(obj.Roles.contains('Secondary contact') || obj.Roles.contains('Primary Contact')){
                            if(obj.Roles.contains('Primary Contact')){
                                con.Primary_Contact__c = true;
                                if(con.Primary_Account__c != null ){
                                    primaryAccount = accountMap.get(obj.AccountId).Name+','+con.Primary_Account__c; 
                                }
                                else{
                                    primaryAccount = accountMap.get(obj.AccountId).Name+','+primaryAccount; 
                                }
                                con.Primary_Account__c = primaryAccount;
                                system.debug('-===='+accountMap.get(obj.AccountId).Name);
                            }
                            if(obj.Roles.contains('Secondary contact')){
                                con.Secondary_Contact__c = true;
                                if(con.Secondary_Account__c != null){
                                    secondaryAccount = accountMap.get(obj.AccountId).Name+','+con.Secondary_Account__c ;
                                }
                                else{
                                    secondaryAccount = accountMap.get(obj.AccountId).Name+','+secondaryAccount ;  
                                }
                                con.Secondary_Account__c  = secondaryAccount;
                                system.debug('-==secondaryAccount  =='+secondaryAccount);
                                system.debug('-===='+accountMap.get(obj.AccountId).Name);
                            }
                        }
                        
                    }
                }
                
            }
        }
        update conList;  
    }
    public static void removeRelatedContact(list<AccountContactRelation> accConRelation){
        list<id> ConId = new list<Id>();
        list<id> removeConId = new list<Id>();
        set<Id>accId = new set<Id>();
        map<Id,list<AccountContactRelation>> mapOfConRelation = new  map<Id,list<AccountContactRelation>>();
        map<Id,list<AccountContactRelation>> mapOfRemoveConRelation = new  map<Id,list<AccountContactRelation>>();
        for(AccountContactRelation obj : accConRelation){
            ConId.add(obj.ContactId);
        }
        System.debug('==ConId==='+ConId);
        List<contact>conList = [select id,Primary_Contact__c,Secondary_Contact__c,Primary_Account__c,Secondary_Account__c from contact where Id In:ConId];
        Map<Id,Account> accountMap = new Map<Id,Account>([Select id, Name From Account Where Id IN :accId]);
        List < AccountContactRelation > reAccConList = new List < AccountContactRelation > ();
        reAccConList = [select id,Roles, contactId,Account.Name from AccountContactRelation where contactId In: ConId and Roles != null];
        System.debug('==reAccConList==='+reAccConList);
        if(!reAccConList.isEmpty()){ 
            for(AccountContactRelation obj :reAccConList){
                if (mapOfRemoveConRelation.containsKey(obj.ContactId)) {
                    mapOfRemoveConRelation.get(obj.ContactId).add(obj); 
                } else {
                    List < AccountContactRelation > lstcnts = new List < AccountContactRelation > ();
                    lstcnts.add(obj);
                    mapOfRemoveConRelation.put(obj.ContactId, lstcnts);
                }
            }
        }
        for(Contact cont : conList){
            String primaryAccount ='';
            String secondaryAccount='';
            if(!reAccConList.isEmpty()){ 
                if(mapOfRemoveConRelation.containsKey(cont.Id) ){
                    for(AccountContactRelation obj :mapOfRemoveConRelation.get(cont.Id)){
                        
                        if(obj.Roles.contains('Primary Contact')){
                            
                            primaryAccount = obj.Account.Name+', '+primaryAccount; 
                            system.debug('-===='+obj.Account.Name);
                        }
                        
                        if(obj.Roles.contains('Secondary contact')){
                            
                            secondaryAccount = obj.Account.Name+','+secondaryAccount ;  
                            system.debug('-==secondaryAccount  =='+secondaryAccount);
                            system.debug('-===='+obj.Account.Name);
                        }
                    }
                    
                }
            }
            
            system.debug('-==secondaryAccount  =='+secondaryAccount);
            system.debug('-==primaryAccount  =='+primaryAccount);
            if(primaryAccount != null && primaryAccount != ''){
                cont.Primary_Contact__c = true;
            }
            else{
                cont.Primary_Contact__c = false; 
            }
            if(secondaryAccount != null && secondaryAccount != ''){
                cont.Secondary_Contact__c = true;
            }
            else{
                cont.Secondary_Contact__c = false;
            }
            cont.Primary_Account__c = primaryAccount;
            cont.Secondary_Account__c  = secondaryAccount;
        }
        
        if(!conList.isEmpty()){
            update conList; 
        }
        
    }
    public static void DeleteRelatedContact(list<AccountContactRelation> accConRelation){
        list<id> ConId = new list<Id>();
        list<id> removeConId = new list<Id>();
        set<Id>accId = new set<Id>(); 
        map<Id,list<AccountContactRelation>> mapOfConRelation = new  map<Id,list<AccountContactRelation>>();
        map<Id,list<AccountContactRelation>> mapOfRemoveConRelation = new  map<Id,list<AccountContactRelation>>();
        for(AccountContactRelation obj : accConRelation){
            ConId.add(obj.ContactId);
        }
        System.debug('==ConId==='+ConId);
        List<contact>conList = [select id,Primary_Contact__c,Secondary_Contact__c,Primary_Account__c,Secondary_Account__c from contact where Id In:ConId];
        Map<Id,Account> accountMap = new Map<Id,Account>([Select id, Name From Account Where Id IN :accId]);
        List < AccountContactRelation > reAccConList = new List < AccountContactRelation > ();
        reAccConList = [select id,Roles, contactId,Account.Name from AccountContactRelation where contactId In: ConId and Roles != null];
        System.debug('==reAccConList==='+reAccConList);
        if(!reAccConList.isEmpty()){
            for(AccountContactRelation obj :reAccConList){
                if (mapOfRemoveConRelation.containsKey(obj.ContactId)) {
                    mapOfRemoveConRelation.get(obj.ContactId).add(obj); 
                } else {
                    List < AccountContactRelation > lstcnts = new List < AccountContactRelation > ();
                    lstcnts.add(obj);
                    mapOfRemoveConRelation.put(obj.ContactId, lstcnts);
                }
            }
        } 
        
        for(Contact cont : conList){
            String primaryAccount ='';
            String secondaryAccount='';
            if(!reAccConList.isEmpty()){ 
                if(mapOfRemoveConRelation.containsKey(cont.Id) ){
                    for(AccountContactRelation obj :mapOfRemoveConRelation.get(cont.Id)){
                        
                        if(obj.Roles.contains('Primary Contact')){
                            
                            primaryAccount = obj.Account.Name+', '+primaryAccount; 
                            system.debug('-===='+obj.Account.Name);
                        }
                        
                        if(obj.Roles.contains('Secondary contact')){
                            
                            secondaryAccount = obj.Account.Name+','+secondaryAccount ;  
                            system.debug('-==secondaryAccount  =='+secondaryAccount);
                            system.debug('-===='+obj.Account.Name);
                        }
                    }
                } 
            }
            system.debug('-==secondaryAccount  =='+secondaryAccount);
            system.debug('-==primaryAccount  =='+primaryAccount);
            if(primaryAccount != null && primaryAccount != ''){
                cont.Primary_Contact__c = true;
            }
            else{
                cont.Primary_Contact__c = false; 
            }
            if(secondaryAccount != null && secondaryAccount != ''){
                cont.Secondary_Contact__c = true;
            }
            else{
                cont.Secondary_Contact__c = false;
            }
            cont.Primary_Account__c = primaryAccount;
            cont.Secondary_Account__c  = secondaryAccount;
            
        }
        if(!conList.isEmpty()){
            update conList; 
        }
        
    }
}