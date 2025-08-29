public class getPrimaryContactHelper {
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