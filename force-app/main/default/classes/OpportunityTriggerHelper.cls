public class OpportunityTriggerHelper 
{
    public static Boolean isFirstTime = true;
    
    public static void onAfterInsert(List<Opportunity> listOpportunities)
    {
        List<Account> acclist;
        Set<Account> accSet = new Set<Account>();
        For(Opportunity objOpportunity : listOpportunities)
        { 
            Account acc= [SELECT id,Stop_Count_Days_Since_Last_PR_Closed__c FROM Account where ID =: objOpportunity.AccountId];
            acc.Stop_Count_Days_Since_Last_PR_Closed__c = false;
            accSet.add(acc);
        }
        acclist = new List<Account>(accSet);
        update acclist;
    }
    
    public static void onAfterUpdate(List<Opportunity> listOpportunities, Map<Id, Opportunity> mapOpportunities)
    {
        If(!listOpportunities.isEmpty())
        {
            Set<String> setContactEmails = new Set<String>();
            List<String> listContactEmails = new List<String>();
            Map<Id,List<String>> mapAccIdEmail = new Map<Id,List<String>>();
            Map<String,List<String>> mapOfEmailAndRole = new Map<String,List<String>>();
            List<Contact> contactListToInsert = new List<Contact>();
            Map<String,contactDetails> mapOfEmailAndContactDetails = new Map<String,contactDetails>();
            List<AccountContactRelation> listAccountContactRelations = new List<AccountContactRelation>();
            For(Opportunity objOpportunity : listOpportunities)
            {   
                if(OpportunityTriggerHelper.isFirstTime){
                System.Debug('IF check for user creation');
                    
                    If(objOpportunity.Type__c == 'NCM' && objOpportunity.StageName == 'Contract Sent' &&  
                       (objOpportunity.StageName != mapOpportunities.get(objOpportunity.Id).StageName) && 
                       (objOpportunity.Sys_DocuSign_Status__c == '' || objOpportunity.Sys_DocuSign_Status__c == null) )
                    {
                        System.Debug('IF check for user creation 2');
                        OpportunityTriggerHelper.isFirstTime = false;
                        List<AccountContactRelation> accConRelList= [SELECT Id,AccountId,Roles,Contact.AccountId  
                                                                     FROM AccountContactRelation 
                                                                     WHERE AccountId  =: objOpportunity.AccountId 
                                                                     AND Roles includes ('Contract Signer')];
                        System.Debug('accConRelList size : ' + accConRelList.size() );
                        if(accConRelList.size() > 0)
                        {
                            Account a = [SELECT name,IsPartner FROM Account WHERE Id =: accConRelList[0].Contact.AccountId];
                            a.IsPartner = TRUE;
                            Update a;
                            Account oppAcc =[SELECT name FROM Account where Id =:objOpportunity.AccountId];
                            System.Debug('Calling Create Comm User method');
                            createCommunityUser(objOpportunity.Contract_Signer__c,objOpportunity.Contract_Signer_Email__c, a.Id,objOpportunity.ID,objOpportunity.OwnerId,a.Name,oppAcc.Name);
                        }
                    }
                }
                if(objOpportunity.Type__c == 'Digital Advertising' && objOpportunity.StageName == 'Lost' &&
                   (objOpportunity.StageName != mapOpportunities.get(objOpportunity.Id).StageName)){
                       
                       List<Account> acclist = [SELECT Id,Stop_Count_Days_Since_Last_PR_Closed__c, (SELECT id FROM Opportunities where Type__c ='Digital Advertising' Order BY CreatedDate DESC LIMIT 1) FROM Account WHERE ID =:objOpportunity.AccountId];
                       if(acclist[0].Opportunities[0].Id == objOpportunity.Id)
                       {
                           acclist[0].Stop_Count_Days_Since_Last_PR_Closed__c = true; 
                       }
                       update acclist;
                   }
                If(objOpportunity.NCM_Composite_Email__c != null && objOpportunity.NCM_Composite_Email__c != mapOpportunities.get(objOpportunity.Id).NCM_Composite_Email__c)
                {
                    if(mapOfEmailAndRole.containskey(objOpportunity.NCM_Composite_Email__c)){
                        List<String> strList = mapOfEmailAndRole.get(objOpportunity.NCM_Composite_Email__c);
                        strList.add('NCM Login');
                        mapOfEmailAndRole.put(objOpportunity.NCM_Composite_Email__c,strList);
                    }
                    else{
                        mapOfEmailAndRole.put(objOpportunity.NCM_Composite_Email__c,new List<String>{'NCM Login'}); 
                    } 
                    setContactEmails.add(objOpportunity.NCM_Composite_Email__c);
                    listContactEmails.add(objOpportunity.NCM_Composite_Email__c);
                    if(mapAccIdEmail.containskey(objOpportunity.AccountId)){
                        List<String> strList = mapAccIdEmail.get(objOpportunity.AccountId);
                        strList.add(objOpportunity.NCM_Composite_Email__c);
                        mapAccIdEmail.put(objOpportunity.AccountId,strList);
                    }
                    else{
                        mapAccIdEmail.put(objOpportunity.AccountId,new List<String>{objOpportunity.NCM_Composite_Email__c});
                    } 
                    
                    contactDetails cd = new contactDetails();
                    cd.firstName=objOpportunity.NCM_Composite_First_Name__c;
                    cd.lastName=objOpportunity.NCM_Composite_Last_Name__c;
                    cd.accountId = objOpportunity.AccountId;
                    cd.ownerId = objOpportunity.Account.ownerId;
                    mapOfEmailAndContactDetails.put(objOpportunity.NCM_Composite_Email__c, cd);
                }
                
                If(objOpportunity.GA_Contact_Email__c != null && objOpportunity.GA_Contact_Email__c != mapOpportunities.get(objOpportunity.Id).GA_Contact_Email__c)
                {
                    if(mapOfEmailAndRole.containskey(objOpportunity.GA_Contact_Email__c)){
                        List<String> strList = mapOfEmailAndRole.get(objOpportunity.GA_Contact_Email__c);
                        if(objOpportunity.Type__c != 'NCM')
                        {
                            strList.add('Analytics');
                        }
                        else
                        {
                            strList.add('Paid Search Provider');
                        }
                        mapOfEmailAndRole.put(objOpportunity.GA_Contact_Email__c,strList);
                    }
                    else{
                        if(objOpportunity.Type__c != 'NCM')
                        {
                            mapOfEmailAndRole.put(objOpportunity.GA_Contact_Email__c,new List<String>{'Analytics'}); 
                        }
                        else{
                            mapOfEmailAndRole.put(objOpportunity.GA_Contact_Email__c,new List<String>{'Paid Search Provider'});
                        }
                    } 
                    setContactEmails.add(objOpportunity.GA_Contact_Email__c);
                    listContactEmails.add(objOpportunity.GA_Contact_Email__c);
                    if(mapAccIdEmail.containskey(objOpportunity.AccountId)){
                        List<String> strList = mapAccIdEmail.get(objOpportunity.AccountId);
                        strList.add(objOpportunity.GA_Contact_Email__c);
                        mapAccIdEmail.put(objOpportunity.AccountId,strList);
                    }
                    else{
                        mapAccIdEmail.put(objOpportunity.AccountId,new List<String>{objOpportunity.GA_Contact_Email__c});
                    } 
                    
                    contactDetails cd = new contactDetails();
                    cd.firstName=objOpportunity.GA_Contact_First_Name__c;
                    cd.lastName=objOpportunity.GA_Contact_Last_Name__c;
                    cd.accountId = objOpportunity.AccountId;
                    cd.ownerId = objOpportunity.Account.ownerId;
                    mapOfEmailAndContactDetails.put(objOpportunity.GA_Contact_Email__c, cd);
                }
                
                If(objOpportunity.Inventory_Contact_Email__c != null && objOpportunity.Inventory_Contact_Email__c != mapOpportunities.get(objOpportunity.Id).Inventory_Contact_Email__c)
                {
                    if(mapOfEmailAndRole.containskey(objOpportunity.Inventory_Contact_Email__c)){
                        List<String> strList = mapOfEmailAndRole.get(objOpportunity.Inventory_Contact_Email__c);
                        strList.add('Inventory');
                        mapOfEmailAndRole.put(objOpportunity.Inventory_Contact_Email__c,strList);
                    }
                    else{
                        mapOfEmailAndRole.put(objOpportunity.Inventory_Contact_Email__c,new List<String>{'Inventory'}); 
                    }
                    setContactEmails.add(objOpportunity.Inventory_Contact_Email__c);
                    listContactEmails.add(objOpportunity.Inventory_Contact_Email__c);
                    if(mapAccIdEmail.containskey(objOpportunity.AccountId)){
                        List<String> strList = mapAccIdEmail.get(objOpportunity.AccountId);
                        strList.add(objOpportunity.Inventory_Contact_Email__c);
                        mapAccIdEmail.put(objOpportunity.AccountId,strList);
                    }
                    else{
                        mapAccIdEmail.put(objOpportunity.AccountId,new List<String>{objOpportunity.Inventory_Contact_Email__c});
                    }
                    
                    contactDetails cd = new contactDetails();
                    cd.firstName=objOpportunity.Inventory_Contact_First_Name__c;
                    cd.lastName=objOpportunity.Inventory_Contact_Last_Name__c;
                    cd.accountId = objOpportunity.AccountId;
                    cd.ownerId = objOpportunity.Account.ownerId;
                    mapOfEmailAndContactDetails.put(objOpportunity.Inventory_Contact_Email__c, cd);
                    
                }
                
                If(objOpportunity.Onboarding_Contact_Email__c != null && objOpportunity.Onboarding_Contact_Email__c != mapOpportunities.get(objOpportunity.Id).Onboarding_Contact_Email__c)
                {
                    if(mapOfEmailAndRole.containskey(objOpportunity.Onboarding_Contact_Email__c)){
                        List<String> strList = mapOfEmailAndRole.get(objOpportunity.Onboarding_Contact_Email__c);
                        strList.add('Onboarding');
                        mapOfEmailAndRole.put(objOpportunity.Onboarding_Contact_Email__c,strList);
                    }
                    else{
                        mapOfEmailAndRole.put(objOpportunity.Onboarding_Contact_Email__c,new List<String>{'Onboarding'}); 
                    }
                    setContactEmails.add(objOpportunity.Onboarding_Contact_Email__c);
                    listContactEmails.add(objOpportunity.Onboarding_Contact_Email__c);
                    if(mapAccIdEmail.containskey(objOpportunity.AccountId)){
                        List<String> strList = mapAccIdEmail.get(objOpportunity.AccountId);
                        strList.add(objOpportunity.Onboarding_Contact_Email__c);
                        mapAccIdEmail.put(objOpportunity.AccountId,strList);
                    }
                    else{
                        mapAccIdEmail.put(objOpportunity.AccountId,new List<String>{objOpportunity.Onboarding_Contact_Email__c});
                    }
                    
                    contactDetails cd = new contactDetails();
                    cd.firstName=objOpportunity.Onboarding_Contact_First_Name__c;
                    cd.lastName=objOpportunity.Onboarding_Contact_Last_Name__c;
                    cd.accountId = objOpportunity.AccountId;
                    cd.ownerId = objOpportunity.Account.ownerId;
                    mapOfEmailAndContactDetails.put(objOpportunity.Onboarding_Contact_Email__c, cd);
                }   
                
                If(objOpportunity.Billing_Contact_Email__c != null && objOpportunity.Billing_Contact_Email__c != mapOpportunities.get(objOpportunity.Id).Billing_Contact_Email__c)
                {
                    if(mapOfEmailAndRole.containskey(objOpportunity.Billing_Contact_Email__c)){
                        List<String> strList = mapOfEmailAndRole.get(objOpportunity.Billing_Contact_Email__c);
                        strList.add('Billing');
                        mapOfEmailAndRole.put(objOpportunity.Billing_Contact_Email__c,strList);
                    }
                    else{
                        mapOfEmailAndRole.put(objOpportunity.Billing_Contact_Email__c,new List<String>{'Billing'}); 
                    }
                    setContactEmails.add(objOpportunity.Billing_Contact_Email__c);
                    listContactEmails.add(objOpportunity.Billing_Contact_Email__c);
                    if(mapAccIdEmail.containskey(objOpportunity.AccountId)){
                        List<String> strList = mapAccIdEmail.get(objOpportunity.AccountId);
                        strList.add(objOpportunity.Billing_Contact_Email__c);
                        mapAccIdEmail.put(objOpportunity.AccountId,strList);
                    }
                    else{
                        mapAccIdEmail.put(objOpportunity.AccountId,new List<String>{objOpportunity.Billing_Contact_Email__c});
                    }
                    
                    contactDetails cd = new contactDetails();
                    cd.firstName=objOpportunity.Billing_Contact_First_Name__c;
                    cd.lastName=objOpportunity.Billing_Contact_Last_Name__c;
                    cd.accountId = objOpportunity.AccountId;
                    cd.ownerId = objOpportunity.Account.ownerId;
                    mapOfEmailAndContactDetails.put(objOpportunity.Billing_Contact_Email__c, cd);
                } 
                
                If(objOpportunity.Contract_Signer_Email__c != null && objOpportunity.Contract_Signer_Email__c != mapOpportunities.get(objOpportunity.Id).Contract_Signer_Email__c)
                {
                    List<AccountContactRelation> accConRel= [SeLECT id,Roles from AccountContactRelation where AccountId =:objOpportunity.AccountId AND Contact.Email =:mapOpportunities.get(objOpportunity.Id).Contract_Signer_Email__c];
                    if(!accConRel.isEmpty()){
                        List<String> lstRoles = new List<String>();
                        If(accConRel[0].Roles != null)
                           lstRoles = ((accConRel[0].Roles).split(';'));
                         String updatedRoles;
                        if(lstRoles.contains('Contract Signer'))
                        {
                             updatedRoles = (accConRel[0].Roles).remove('Contract Signer');
                        }
                        accConRel[0].Roles = updatedRoles;
                       listAccountContactRelations.add(accConRel[0]);
                    }
                    
                    if(mapOfEmailAndRole.containskey(objOpportunity.Contract_Signer_Email__c)){
                        List<String> strList = mapOfEmailAndRole.get(objOpportunity.Contract_Signer_Email__c);
                        strList.add('Contract Signer');
                        mapOfEmailAndRole.put(objOpportunity.Contract_Signer_Email__c,strList);
                    }
                    else{
                        mapOfEmailAndRole.put(objOpportunity.Contract_Signer_Email__c,new List<String>{'Contract Signer'}); 
                    }
                    setContactEmails.add(objOpportunity.Contract_Signer_Email__c);
                    listContactEmails.add(objOpportunity.Contract_Signer_Email__c);
                    if(mapAccIdEmail.containskey(objOpportunity.AccountId)){
                        List<String> strList = mapAccIdEmail.get(objOpportunity.AccountId);
                        strList.add(objOpportunity.Contract_Signer_Email__c);
                        mapAccIdEmail.put(objOpportunity.AccountId,strList);
                    }
                    else{
                        mapAccIdEmail.put(objOpportunity.AccountId,new List<String>{objOpportunity.Contract_Signer_Email__c});
                    }
                    
                    contactDetails cd = new contactDetails();
                    cd.lastName=objOpportunity.Contract_Signer__c;
                    cd.title=objOpportunity.Contract_Signer_Title__c;
                    cd.phone=objOpportunity.Contract_Signer_Phone__c;
                    cd.accountId = objOpportunity.AccountId;
                    cd.ownerId = objOpportunity.Account.ownerId;
                    mapOfEmailAndContactDetails.put(objOpportunity.Contract_Signer_Email__c, cd);
                } 
            }
            
            If(!listAccountContactRelations.isEmpty())
            {
                UPDATE listAccountContactRelations;
            }
            
            if(!listContactEmails.isEmpty())
            {
                List<Contact> listOfContacts = [SELECT ID, accountId, Email
                                                FROM Contact 
                                                WHERE  Email IN : listContactEmails];
                List<String> emailOnContact = new List<String>();
                if(listContactEmails.size() != listOfContacts.size())
                {
                    for(Contact objContact : listOfContacts)
                    {
                        emailOnContact.add(objContact.Email);
                    }
                    for(String emailId: setContactEmails)
                    {
                        If(!emailOnContact.contains(emailId))
                        {
                            contactDetails cd = mapOfEmailAndContactDetails.get(emailId);
                            System.debug('emailFromSet --> '+emailId);
                            Contact newContact;
                            system.debug('cd.ownerId = ' +cd.ownerId);
                            if(cd.ownerId != '' && cd.ownerId != null){
                                newContact = new Contact (Email=emailId,LastName=cd.lastName,FirstName=cd.firstName,AccountId=cd.accountId,OwnerId = cd.ownerId,Title__c=cd.Title,Phone=cd.phone);
                            }
                            else{ 
                                newContact = new Contact (Email=emailId,LastName=cd.lastName,FirstName=cd.firstName,AccountId=cd.accountId,Title__c=cd.Title,Phone=cd.phone);
                            }
                            contactListToInsert.add(newContact);
                        }
                    }
                    System.debug('contactListToInsert --> '+contactListToInsert);
                    insert contactListToInsert;
                }
                
            }
            
            If(!setContactEmails.isEmpty())
            {
                Map<String, AccountContactRelation> mapAccountContactRelations = new Map<String, AccountContactRelation>();
                Map<String, Contact> mapContactWithSameEmails = new Map<String, Contact>();
                Map<String, List<Contact>> mapAccountIdAndContacts = new Map<String, List<Contact>>();
                List<AccountContactRelation> accConRelList = new List<AccountContactRelation>();
                List<AccountContactRelation> accountRelationList = new List<AccountContactRelation>();
                
                List<Contact> listContacts = [SELECT ID, accountId, Email,
                                              (SELECT Id, Roles, accountId, contactId FROM AccountContactRelations) 
                                              FROM Contact 
                                              WHERE Email IN : setContactEmails AND accountId IN : mapAccIdEmail.keySet() 
                                             ];
                List<Contact> listAllContacts = [SELECT ID, accountId, Email,
                                                 (SELECT Id, Roles, accountId, contactId FROM AccountContactRelations WHERE accountId IN : mapAccIdEmail.keySet()) 
                                                 FROM Contact 
                                                 WHERE Email IN : setContactEmails];
                
                system.debug('listAllContacts --->  '+listAllContacts);
                
                for(integer i = 0; i<listAllContacts.size(); i++) 
                {
                    if(!listContacts.contains(listAllContacts[i]))
                    {
                        system.debug('listAllContacts[i].Contact --->  '+listAllContacts[i]);
                        system.debug('listAllContacts[i].AccountContactRelations --->  '+listAllContacts[i].AccountContactRelations);
                        
                        
                        if(listAllContacts[i].AccountContactRelations.size() == 0){
                            
                            
                            List<String> roleList = mapOfEmailAndRole.get(listAllContacts[i].Email);
                            AccountContactRelation accConRel = new AccountContactRelation();
                            accConRel.Roles = String.join(roleList, ';');
                            accConRel.ContactId = listAllContacts[i].Id; 
                            
                            for(String key : mapAccIdEmail.keySet()){
                                if(mapAccIdEmail.get(key).contains(listAllContacts[i].Email)){
                                    system.debug('key --------> '+ key);
                                    accConRel.AccountId = key;
                                }
                            }
                            system.debug('accConRel '+accConRel);
                            accConRelList.add(accConRel);
                            setContactEmails.remove(listAllContacts[i].Email);
                        }
                        else{
                            system.debug('listAllContacts[i].Contact --->  '+listAllContacts[i]);
                        }
                    }
                }
                
                system.debug('setContactEmails --->  '+setContactEmails);
                system.debug('mapOfEmailAndRole --->  '+mapOfEmailAndRole);
                
                If(!listAllContacts.isEmpty())
                {            
                    For(Contact objContact : listAllContacts)
                    {
                        If(objContact.AccountId != null && !mapAccountIdAndContacts.containsKey(objContact.AccountId))
                        {
                            if(objContact.AccountContactRelations.size()>0)
                                mapAccountIdAndContacts.put(objContact.AccountContactRelations[0].AccountId, new List<Contact>{objContact});  
                        }
                        If(objContact.AccountId != null)
                        {if(objContact.AccountContactRelations.size()>0)
                            mapAccountIdAndContacts.get(objContact.AccountContactRelations[0].AccountId).add(objContact);   
                        }
                    }
                }
                system.debug('mapAccountIdAndContacts --->  '+mapAccountIdAndContacts);
                
                For(Opportunity objOpportunity : listOpportunities)
                {
                    system.debug('objOpportunity.AccountId  --> '+objOpportunity.AccountId );
                    system.debug('objOpportunity.AccountId  --> '+mapAccountIdAndContacts.containsKey(objOpportunity.AccountId) );
                    
                    If(objOpportunity.AccountId != null && mapAccountIdAndContacts.containsKey(objOpportunity.AccountId) && mapAccountIdAndContacts.get(objOpportunity.AccountId) != null)
                    {
                        system.debug('In if --> ');
                        For(Contact objContact : mapAccountIdAndContacts.get(objOpportunity.AccountId))
                        {
                            If(objOpportunity.Inventory_Contact_Email__c != null && objOpportunity.Inventory_Contact_Email__c == objContact.Email)
                            {
                                //If AccountContactRelation Record exist
                                If(objContact.AccountContactRelations.size() > 0)
                                {
                                    For(AccountContactRelation objAccountContactRelation : objContact.AccountContactRelations) 
                                    {
                                        List<String> listStrings = new List<String>();
                                        
                                        If(objAccountContactRelation.Roles != null)
                                        {
                                            If(objAccountContactRelation.Roles.contains(';'))
                                            {
                                                listStrings.addAll(objAccountContactRelation.Roles.split(';'));  
                                            }
                                            Else
                                            {
                                                listStrings.add(objAccountContactRelation.Roles);  
                                            }
                                            
                                            If(!listStrings.contains('Inventory'))
                                            {
                                                listStrings.add('Inventory');
                                                
                                                objAccountContactRelation.Roles = String.join(listStrings, ';');
                                                
                                                mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                            }
                                        }
                                        Else
                                        {
                                            listStrings.add('Inventory');
                                            
                                            objAccountContactRelation.Roles = String.join(listStrings, ';');
                                            
                                            mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                        }
                                    }
                                }
                                else{
                                    List<String> roleList = mapOfEmailAndRole.get(objOpportunity.Inventory_Contact_Email__c);
                                    system.debug('roleList ----> '+roleList);
                                    AccountContactRelation accConRel = new AccountContactRelation();
                                    accConRel.Roles = String.join(roleList, ';');
                                    accConRel.ContactId = objContact.Id; 
                                    accConRel.AccountId = objContact.AccountId;
                                    accountRelationList.add(accConRel);
                                }
                            }
                            
                            If(objOpportunity.NCM_Composite_Email__c != null && objOpportunity.NCM_Composite_Email__c == objContact.Email)
                            {
                                //If AccountContactRelation Record exist
                                If(objContact.AccountContactRelations.size() > 0)
                                {
                                    For(AccountContactRelation objAccountContactRelation : objContact.AccountContactRelations) 
                                    {
                                        List<String> listStrings = new List<String>();
                                        
                                        If(objAccountContactRelation.Roles != null)
                                        {
                                            If(objAccountContactRelation.Roles.contains(';'))
                                            {
                                                listStrings.addAll(objAccountContactRelation.Roles.split(';'));  
                                            }
                                            Else
                                            {
                                                listStrings.add(objAccountContactRelation.Roles);  
                                            }
                                            
                                            If(!listStrings.contains('NCM Login'))
                                            {
                                                listStrings.add('NCM Login');
                                                
                                                objAccountContactRelation.Roles = String.join(listStrings, ';');
                                                
                                                mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                            }
                                        }
                                        Else
                                        {
                                            
                                            listStrings.add('NCM Login');
                                            
                                            objAccountContactRelation.Roles = String.join(listStrings, ';');
                                            
                                            mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                        }
                                    }
                                }
                                else{
                                    List<String> roleList = mapOfEmailAndRole.get(objOpportunity.NCM_Composite_Email__c);
                                    system.debug('roleList ----> '+roleList);
                                    AccountContactRelation accConRel = new AccountContactRelation();
                                    accConRel.Roles = String.join(roleList, ';');
                                    accConRel.ContactId = objContact.Id; 
                                    accConRel.AccountId = objContact.AccountId;
                                    accountRelationList.add(accConRel);
                                }
                            }
                            
                            If(objOpportunity.GA_Contact_Email__c != null && objOpportunity.GA_Contact_Email__c == objContact.Email)
                            {
                                //If AccountContactRelation Record exist
                                If(objContact.AccountContactRelations.size() > 0)
                                {
                                    For(AccountContactRelation objAccountContactRelation : objContact.AccountContactRelations) 
                                    {
                                        List<String> listStrings = new List<String>();
                                        
                                        If(objAccountContactRelation.Roles != null)
                                        {
                                            If(objAccountContactRelation.Roles.contains(';'))
                                            {
                                                listStrings.addAll(objAccountContactRelation.Roles.split(';'));  
                                            }
                                            Else
                                            {
                                                listStrings.add(objAccountContactRelation.Roles);  
                                            }
                                            if(objOpportunity.Type__c != 'NCM')
                                            {
                                                If(!listStrings.contains('Analytics'))
                                                {
                                                    listStrings.add('Analytics');
                                                    
                                                    objAccountContactRelation.Roles = String.join(listStrings, ';');
                                                    
                                                    mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                                }
                                            }
                                            else{
                                                If(!listStrings.contains('Paid Search Provider'))
                                                {
                                                    listStrings.add('Paid Search Provider');
                                                    
                                                    objAccountContactRelation.Roles = String.join(listStrings, ';');
                                                    
                                                    mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                                }
                                            }
                                        }
                                        Else
                                        {
                                            if(objOpportunity.Type__c != 'NCM')
                                            {listStrings.add('Analytics');}
                                            else{
                                                listStrings.add('Paid Search Provider');
                                            }
                                            
                                            objAccountContactRelation.Roles = String.join(listStrings, ';');
                                            
                                            mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                        }
                                    }
                                }
                                else{
                                    List<String> roleList = mapOfEmailAndRole.get(objOpportunity.GA_Contact_Email__c);
                                    system.debug('roleList ----> '+roleList);
                                    AccountContactRelation accConRel = new AccountContactRelation();
                                    accConRel.Roles = String.join(roleList, ';');
                                    accConRel.ContactId = objContact.Id; 
                                    accConRel.AccountId = objContact.AccountId;
                                    accountRelationList.add(accConRel);
                                }
                            }
                            
                            If(objOpportunity.Onboarding_Contact_Email__c != null && objOpportunity.Onboarding_Contact_Email__c == objContact.Email)
                            {
                                //If AccountContactRelation Record exist
                                If(objContact.AccountContactRelations.size() > 0)
                                {
                                    For(AccountContactRelation objAccountContactRelation : objContact.AccountContactRelations) 
                                    {
                                        List<String> listStrings = new List<String>();
                                        
                                        If(objAccountContactRelation.Roles != null)
                                        {
                                            If(objAccountContactRelation.Roles.contains(';'))
                                            {
                                                listStrings.addAll(objAccountContactRelation.Roles.split(';'));  
                                            }
                                            Else
                                            {
                                                listStrings.add(objAccountContactRelation.Roles);  
                                            }
                                            
                                            If(!listStrings.contains('Onboarding'))
                                            {
                                                listStrings.add('Onboarding');
                                                
                                                objAccountContactRelation.Roles = String.join(listStrings, ';');
                                                
                                                mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                            }
                                        }
                                        Else
                                        {
                                            listStrings.add('Onboarding');
                                            
                                            objAccountContactRelation.Roles = String.join(listStrings, ';');
                                            
                                            mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                        }
                                    }
                                }
                                else{
                                    List<String> roleList = mapOfEmailAndRole.get(objOpportunity.Onboarding_Contact_Email__c);
                                    system.debug('roleList ----> '+roleList);
                                    AccountContactRelation accConRel = new AccountContactRelation();
                                    accConRel.Roles = String.join(roleList, ';');
                                    accConRel.ContactId = objContact.Id; 
                                    accConRel.AccountId = objContact.AccountId;
                                    accountRelationList.add(accConRel);
                                }
                            }
                            
                            If(objOpportunity.Billing_Contact_Email__c != null && objOpportunity.Billing_Contact_Email__c == objContact.Email)
                            {
                                //If AccountContactRelation Record exist
                                If(objContact.AccountContactRelations.size() > 0)
                                {
                                    For(AccountContactRelation objAccountContactRelation : objContact.AccountContactRelations) 
                                    {
                                        List<String> listStrings = new List<String>();
                                        
                                        If(objAccountContactRelation.Roles != null)
                                        {
                                            If(objAccountContactRelation.Roles.contains(';'))
                                            {
                                                listStrings.addAll(objAccountContactRelation.Roles.split(';'));  
                                            }
                                            Else
                                            {
                                                listStrings.add(objAccountContactRelation.Roles);  
                                            }
                                            
                                            If(!listStrings.contains('Billing'))
                                            {
                                                listStrings.add('Billing');
                                                
                                                objAccountContactRelation.Roles = String.join(listStrings, ';');
                                                
                                                mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                            }
                                        }
                                        Else
                                        {
                                            listStrings.add('Billing');
                                            
                                            objAccountContactRelation.Roles = String.join(listStrings, ';');
                                            
                                            mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                        }
                                    }
                                }
                                else{
                                    List<String> roleList = mapOfEmailAndRole.get(objOpportunity.Billing_Contact_Email__c);
                                    system.debug('roleList ----> '+roleList);
                                    AccountContactRelation accConRel = new AccountContactRelation();
                                    accConRel.Roles = String.join(roleList, ';');
                                    accConRel.ContactId = objContact.Id; 
                                    accConRel.AccountId = objContact.AccountId;
                                    accountRelationList.add(accConRel);
                                }
                            }
                            
                            If(objOpportunity.Contract_Signer_Email__c != null && objOpportunity.Contract_Signer_Email__c == objContact.Email)
                            {
                                //If AccountContactRelation Record exist
                                If(objContact.AccountContactRelations.size() > 0)
                                {
                                    For(AccountContactRelation objAccountContactRelation : objContact.AccountContactRelations) 
                                    {
                                        List<String> listStrings = new List<String>();
                                        
                                        If(objAccountContactRelation.Roles != null)
                                        {
                                            If(objAccountContactRelation.Roles.contains(';'))
                                            {
                                                listStrings.addAll(objAccountContactRelation.Roles.split(';'));  
                                            }
                                            Else
                                            {
                                                listStrings.add(objAccountContactRelation.Roles);  
                                            }
                                            
                                            If(!listStrings.contains('Contract Signer'))
                                            {
                                                listStrings.add('Contract Signer');
                                                
                                                objAccountContactRelation.Roles = String.join(listStrings, ';');
                                                
                                                mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                            }
                                        }
                                        Else
                                        {
                                            listStrings.add('Contract Signer');
                                            
                                            objAccountContactRelation.Roles = String.join(listStrings, ';');
                                            
                                            mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                        }
                                    }
                                }
                                else{
                                    List<String> roleList = mapOfEmailAndRole.get(objOpportunity.Contract_Signer_Email__c);
                                    system.debug('roleList ----> '+roleList);
                                    AccountContactRelation accConRel = new AccountContactRelation();
                                    accConRel.Roles = String.join(roleList, ';');
                                    accConRel.ContactId = objContact.Id; 
                                    accConRel.AccountId = objContact.AccountId;
                                    accountRelationList.add(accConRel);
                                }
                            }
                        }
                    }
                    If(!mapAccountContactRelations.isEmpty())
                    {
                        UPDATE mapAccountContactRelations.values();
                    }
                    If(accountRelationList.size()>0)
                    {
                        List<String> listStrings = new List<String>();
                        
                        listStrings.add(Json.serialize(accountRelationList));
                        
                        updateAccountContactRelationRecord(listStrings);
                    }
                    system.debug('accConRelList --> '+accConRelList);
                    If(accConRelList.size()>0)
                    {
                        INSERT accConRelList;
                    }
                }
            }
            
        }
    }
    public class contactDetails{
        public String firstName{get;set;}
        public String lastName{get;set;}
        public Id accountId{get;set;}
        public Id ownerId{get;set;}
        public String title{get;set;}
        public String phone{get;set;}
    }
    @future
    public static void updateAccountContactRelationRecord(List<String> listStrings)
    {
        List<AccountContactRelation> accountRelationList = new List<AccountContactRelation>();
        accountRelationList = (List<AccountContactRelation>)Json.deserialize(listStrings[0], List<AccountContactRelation>.class);
        system.debug('accountRelationList -----> '+ accountRelationList);
        If(accountRelationList.size()>0)
        {
            INSERT accountRelationList;
        }
    }
    
    public static void onBeforeUpdate(List<Opportunity> listOpportunities, Map<Id, Opportunity> mapOpportunities)
    {
        List<Profile> listProfiles = [SELECT Id, Name 
                                      FROM Profile 
                                      WHERE Name = 'Foundation Partner Community'
                                     ];
        Set<ID> setOppAccountIds = new Set<ID>();
        For(Opportunity objOpportunity : listOpportunities)
        {
            setOppAccountIds.add(objOpportunity.AccountId);
            If(mapOpportunities.get(objOpportunity.Id).Contract_Signed_Date__c != null && !listProfiles.isEmpty() && listProfiles[0].Id == UserInfo.getProfileId())
            {
                // objOpportunity.addError('You can not update this record, Please contact to your system administrator.!!');
            }
            if(objOpportunity.Contract_Signer_Title__c != mapOpportunities.get(objOpportunity.Id).Contract_Signer_Title__c)
            {
                List<Contact> contact = [SELECT Id,Title__c FROM CONTACT WHERE AccountId =: objOpportunity.AccountId AND Email =: objOpportunity.Contract_Signer_Email__c];
                if(contact.size()>0){
                    contact[0].Title__c = objOpportunity.Contract_Signer_Title__c;
                }
                update contact;
            }
            If(objOpportunity.StageName == 'Contract Sent' &&  objOpportunity.StageName != mapOpportunities.get(objOpportunity.Id).StageName)
            {
                if(objOpportunity.Type__c == 'NCM' && (objOpportunity.Sys_DocuSign_Status__c == '' || objOpportunity.Sys_DocuSign_Status__c == null))
                {
                    objOpportunity.Need_To_Send_welcome_Email__c = TRUE;
                }
                
                //update contract signer details on opportunity
                List<AccountContactRelation> accConRelList= [select Id,AccountId,Contact.Name, Contact.Title__c,Contact.Email,Roles from AccountContactRelation where AccountId =: objOpportunity.AccountId and Roles includes ('Contract Signer')];
                if(accConRelList.size() > 0)
                {
                    objOpportunity.Contract_Signer__c = accConRelList[0].Contact.Name;
                    //objOpportunity.Contract_Signer_Title__c = accConRelList[0].Contact.Title__c;
                    objOpportunity.Contract_Signer_Email__c = accConRelList[0].Contact.Email;
                }
            }
        }
        
        //Start - Added by sandip to update flag Go_To_Enrolment_Pending__c
        system.debug('Start - Added by sandip to update flag Go_To_Enrolment_Pending__c');
        
        Map<String, List<Account>> mapNCM20GroupCodeAndAccounts = new Map<String, List<Account>>();
        Set<String> setSubAccountIds = new Set<String>();
        
        List<Account> listAccounts =[SELECT Id, Name, Sub_Parent__c,Sub_Parent__r.Type__c, Sub_Parent__r.NCM_20_Parent_Status__c, NCM_Management_Group__c,
                                     NCM_Management_Group__r.Type__c, NCM_Management_Group__r.NCM_20_Parent_Status__c, NCM_20_Group_2__c,NCM_20_Group_2__r.Type__c, NCM_20_Group_2__r.NCM_20_Parent_Status__c   
                                     FROM Account 
                                     WHERE ID IN: setOppAccountIds AND 
                                     (Sub_Parent__c != null OR NCM_Management_Group__c != null OR NCM_20_Group_2__c != null)];
        Set<String> setParentAccountIds = new Set<String>();
        If(!listAccounts.isEmpty())
        {
            Set<String> setAccountIds = new Set<String>();
            
            For(Account objAccount : listAccounts)
            {
                setParentAccountIds.add(objAccount.Id);
                If(objAccount.Sub_Parent__c != null && objAccount.Sub_Parent__r.Type__c != null)
                {
                    if(objAccount.Sub_Parent__r.Type__c.contains('NCM 20 Group') && objAccount.Sub_Parent__r.NCM_20_Parent_Status__c != 'Live' && objAccount.Sub_Parent__r.NCM_20_Parent_Status__c != 'Onboarding')
                        setAccountIds.add(objAccount.Sub_Parent__c);   
                }
                If(objAccount.NCM_Management_Group__c != null && objAccount.NCM_Management_Group__r.Type__c != null)
                {
                    if(objAccount.NCM_Management_Group__r.Type__c.contains('NCM 20 Group') && objAccount.NCM_Management_Group__r.NCM_20_Parent_Status__c != 'Live' && objAccount.NCM_Management_Group__r.NCM_20_Parent_Status__c != 'Onboarding')
                        setAccountIds.add(objAccount.NCM_Management_Group__c );   
                }
                If(objAccount.NCM_20_Group_2__c != null && objAccount.NCM_20_Group_2__r.Type__c != null)
                {
                    if(objAccount.NCM_20_Group_2__r.Type__c.contains('NCM 20 Group') && objAccount.NCM_20_Group_2__r.NCM_20_Parent_Status__c != 'Live' && objAccount.NCM_20_Group_2__r.NCM_20_Parent_Status__c != 'Onboarding')
                        setAccountIds.add(objAccount.NCM_20_Group_2__c);   
                }
            }
            system.debug('setAccountIds ======================> ' + setAccountIds);
            If(!setAccountIds.isEmpty())
            {
                List<Account> listParentAccounts = [SELECT Id, Name, Count_NCM_20_Group__c, Count_NCM_Management_Group__c, 
                                                    Count_NCM_20_Group_2__c,NCM_20_Group_2__c,NCM_Management_Group__c,
                                                    Sub_Parent__c, (SELECT Id FROM Accounts__r) 
                                                    FROM Account 
                                                    WHERE Id IN : setAccountIds];
                system.debug('listParentAccounts ======================> ' + listParentAccounts);
                
                
                For(Account objAccount : listParentAccounts)
                {
                    For(Account obj : objAccount.Accounts__r)
                    {
                        setSubAccountIds.add(obj.Id);
                    }
                    
                    
                    If(objAccount.Name != null && objAccount.Name.indexOf('(') != -1)
                    {
                        String theString = objAccount.Name;
                        String[] sVal = New String[]{};
                            sVal = theString.split('\\(');
                        String finalString = sVal[1].subString(0,sVal[1].length()-1);
                        
                        If(!mapNCM20GroupCodeAndAccounts.containsKey(finalString))
                        {
                            mapNCM20GroupCodeAndAccounts.put(finalString, new List<Account>());
                        }
                        
                        mapNCM20GroupCodeAndAccounts.get(finalString).add(objAccount);
                    }
                    
                }                
                
            }
        }
        
        system.debug('setSubAccountIds ======================> ' + setSubAccountIds);
        system.debug('mapNCM20GroupCodeAndAccounts ======================> ' + mapNCM20GroupCodeAndAccounts.keySet());
        For(Opportunity objOpportunity : listOpportunities)
        {
            If(objOpportunity.Type__c =='NCM' && objOpportunity.Product_Status__c == 'NCM Digital Performance Composite' && mapNCM20GroupCodeAndAccounts.keySet().contains(objOpportunity.NCM_20_Group_Code__c) 
               && setParentAccountIds.contains(objOpportunity.AccountId))
            {
                objOpportunity.Go_To_Enrolment_Pending__c = true;
            }
        }
        // End
        
    }
    
    public static void onAfterUpdateSendEmail(List<Opportunity> listOpportunities, Map<Id, Opportunity> mapOpportunities)
    {
        system.debug('Call email send opportunity trigger method.........');
        
        If(!listOpportunities.isEmpty())
        {
            Set<String> setOpportunities = new Set<String>();
            
            For(Opportunity objOpportunity : listOpportunities)
            {
                If(objOpportunity.Contract_Signed_Date__c != null && mapOpportunities.get(objOpportunity.Id).Contract_Signed_Date__c != objOpportunity.Contract_Signed_Date__c)
                {
                    setOpportunities.add(objOpportunity.Id);
                }
            }
            
            system.debug('setOpportunities : ' + setOpportunities);
            
            If(!setOpportunities.isEmpty())
            {
                List<ContentDocumentLink> listContentDocumentLinks = [SELECT Id, ContentDocumentId, LinkedEntityId, SystemModstamp 
                                                                      FROM ContentDocumentLink
                                                                      WHERE LinkedEntityId IN : setOpportunities ORDER BY SystemModstamp DESC
                                                                     ];
                
                system.debug('listContentDocumentLinks : ' + listContentDocumentLinks);
                Map<String,String> mapOfCDLOppoId = new Map<String,String>();
                
                
                If(!listContentDocumentLinks.isEmpty())
                {
                    Set<String> setContentDocumentIds = new Set<String>();
                    
                    For(ContentDocumentLink objContentDocumentLink : listContentDocumentLinks)
                    {
                        If(objContentDocumentLink.ContentDocumentId != null)
                        {
                            mapOfCDLOppoId.put(objContentDocumentLink.ContentDocumentId,objContentDocumentLink.LinkedEntityId);
                            setContentDocumentIds.add(objContentDocumentLink.ContentDocumentId);
                        }
                    }
                    
                    system.debug('setContentDocumentIds : ' + setContentDocumentIds);
                    
                    If(!setContentDocumentIds.isEmpty())
                    {
                        List<ContentVersion> listContentVersions = [SELECT Id, ContentDocumentId, ContentUrl, FileType, VersionData, Title 
                                                                    FROM ContentVersion
                                                                    WHERE ContentDocumentId IN : setContentDocumentIds
                                                                    AND FileType = 'PDF'
                                                                    ORDER BY CreatedDate DESC
                                                                   ];
                        
                        List<Opportunity_Attachment_Email_Content__c> listCustomSettings = Opportunity_Attachment_Email_Content__c.getall().values();
                        
                        If(!listCustomSettings.isEmpty())
                        {
                            List<String> getEmailList = new List<String>();
                            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
                            
                            If(listCustomSettings[0].To_Address__c != null && listCustomSettings[0].To_Address__c.contains(','))
                            {
                                getEmailList.addAll(listCustomSettings[0].To_Address__c.split(','));
                            }
                            Else If(listCustomSettings[0].To_Address__c != null)
                            {
                                getEmailList.add(listCustomSettings[0].To_Address__c);
                            }
                            
                            system.debug('getEmailList : ' + getEmailList);
                            system.debug('listContentVersions : ' + listContentVersions);
                            
                            If(!listContentVersions.isEmpty())
                            {
                                For(Opportunity objOpportunity : listOpportunities)
                                {
                                    Integer count = 0;
                                    
                                    For(ContentDocumentLink objContentDocumentLink : listContentDocumentLinks)
                                    {
                                        If(objContentDocumentLink.LinkedEntityId == objOpportunity.Id)
                                        {
                                            For(ContentVersion cv : listContentVersions)
                                            {
                                                If(count == 0 && cv.ContentDocumentId == objContentDocumentLink.ContentDocumentId && cv.Title != null && cv.Title.indexOf('Completed') != -1 )
                                                {
                                                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                                    Messaging.Emailfileattachment efa1 = new Messaging.Emailfileattachment();
                                                    Blob Data = cv.VersionData;
                                                    
                                                    if(Data.size() > 0)
                                                    {   
                                                        efa1.setBody(Data);
                                                        efa1.setFileName(cv.Title);
                                                        efa1.setContentType('application/pdf');
                                                        
                                                        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
                                                        
                                                        mail.setSubject(listCustomSettings[0].Email_Subject__c);
                                                        mail.setToAddresses(getEmailList);
                                                        String emailBody = listCustomSettings[0].Email_Body__c;
                                                        mail.setHtmlBody(emailBody);
                                                        
                                                        messages.add(mail);
                                                        count++;
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                    
                                    
                                    If(messages.size() > 0)
                                    {
                                        Messaging.sendEmailResult[] sendEmailResults = Messaging.sendEmail(messages);
                                        system.debug('sendEmailResults : ' + sendEmailResults);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @future
    public static void createCommunityUser(String contractSignerName, String contractSignerEmail, String accId,Id OppID,Id OwnerID,String accName,String oppAccountName) {
        
        system.debug('createCommunityUser');
        
        String accEmail = (oppAccountName.deleteWhitespace())+'@ncmdigital.com';
        
        String searchString = (oppAccountName.deleteWhitespace())  + '%' + '@ncmdigital.com';
        system.debug('searchString = '+searchString);
        
        List<User> userlist=[SELECT Id,FirstName, LastName, UserName,IsActive,Email
                             From User 
                             WHERE  UserName LIKE :searchString];
        
        List<User> userlistMatchEmail=[SELECT Id,FirstName, LastName, UserName,IsActive,Email
                                       From User 
                                       WHERE  Email =: contractSignerEmail LIMIT 1];
        
        system.debug('user = '+userlist);
        User communityUser = new User();
        
        if(userlist.size()>0 && userlistMatchEmail.size()>0 )
        {
            for(User u: userlist)
            {
                if(u.Email == contractSignerEmail){
                    //active and send email
                    if( u.IsActive == FALSE){
                        u.IsActive = TRUE;
                    }
                    try{
                        Update u;
                        system.debug('user = '+u);
                    }
                    catch(Exception e)
                    {
                        sendExceptionEmail(OppID, e.getMessage(),accName,NULL);
                    }
                }
            }
        }
        else if(userlist.size()>0 && userlistMatchEmail.size()==0){
            //create new user with append number in username and contract signer as email
                    Id profileId = [SELECT Id 
                                    FROM Profile 
                                    WHERE Name = 'Foundation Partner Community' LIMIT 1].Id;
                    
                    List<Contact> contactlst =[SELECT Id,FirstName, LastName 
                                               FROM Contact 
                                               WHERE Email =: contractSignerEmail AND AccountId =: accId];
                    If(contactlst.size() > 0)
                    {
                        String userAlias;
                        if((contactlst[0].FirstName).Length()>= 8 ){
                            userAlias = (contactlst[0].FirstName).substring(0, 8);
                        }
                        else{
                            userAlias = (contactlst[0].FirstName);
                        }
                        
                        // Create community user
                        communityUser = new User(FirstName = contactlst[0].FirstName, LastName = contactlst[0].LastName,IsActive=True,
                                                 Email = contractSignerEmail,
                                                 ContactId = contactlst[0].Id,CommunityNickname = ( contactlst[0].FirstName  +' '+contactlst[0].LastName),
                                                 ProfileId = profileId,
                                                 //UserName = 'ncm_'+contractSignerEmail,
                                                 UserName = (oppAccountName.deleteWhitespace())+( userlist.size() +1)+'@ncmdigital.com',
                                                 alias = userAlias, TimeZoneSidKey = 'America/New_York',
                                                 LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
                        try{
                            insert communityUser;
                        }
                        catch(Exception e)
                        {
                            sendExceptionEmail(OppID, e.getMessage(),accName,contactlst[0].Id);
                        }
                        system.debug('communityUser = '+communityUser);
                    }
                    else{
                        sendExceptionEmail(OppID,'No contact with same email as contract signer on account related to opportunity',accName,NULL);
                    }
                
        }
        else if(userlist.size()==0 && userlistMatchEmail.size()>0)
        {
            //Update username and active User
            userlistMatchEmail[0].UserName = accEmail;
            if( userlistMatchEmail[0].IsActive == FALSE)
            {
                userlistMatchEmail[0].IsActive = TRUE;
            }
           
                try{
                    update userlistMatchEmail[0];
                }
                catch(Exception e)
                {
                    sendExceptionEmail(OppID, e.getMessage(),accName, userlistMatchEmail[0].Id);
                }
                system.debug(' userlistMatchEmail[0] = '+ userlistMatchEmail[0]);
            }
        else
        {
            Id profileId = [SELECT Id 
                            FROM Profile 
                            WHERE Name = 'Foundation Partner Community' LIMIT 1].Id;
            
            List<Contact> contactlst =[SELECT Id,FirstName, LastName 
                                       FROM Contact 
                                       WHERE Email =: contractSignerEmail AND AccountId =: accId];
            If(contactlst.size() > 0)
            {
                String userAlias;
                if((contactlst[0].FirstName).Length()>= 8 ){
                    userAlias = (contactlst[0].FirstName).substring(0, 8);
                }
                else{
                    userAlias = (contactlst[0].FirstName);
                }
                
                // Create community user
                communityUser = new User(FirstName = contactlst[0].FirstName, LastName = contactlst[0].LastName,IsActive=True,
                                         Email = contractSignerEmail,
                                         ContactId = contactlst[0].Id,CommunityNickname = ( contactlst[0].FirstName  +' '+contactlst[0].LastName),
                                         ProfileId = profileId,
                                         //UserName = 'ncm_'+contractSignerEmail,
                                         UserName = (oppAccountName.deleteWhitespace())+'@ncmdigital.com',
                                         alias = userAlias, TimeZoneSidKey = 'America/New_York',
                                         LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
                try{
                    insert communityUser;
                }
                catch(Exception e)
                {
                    sendExceptionEmail(OppID, e.getMessage(),accName,contactlst[0].Id);
                }
                system.debug('communityUser = '+communityUser);
            }
            else{
                sendExceptionEmail(OppID,'No contact with same email as contract signer on account related to opportunity',accName,NULL);
            }
        }
        
        // return communityUser;
    }
    
    public static void sendExceptionEmail(ID OpportunityId, String error, String accountName,Id contactId)
    {
        List<EmailTemplate> CustomEmailTemplate = [SELECT Subject,HtmlValue,Body,ID 
                                                   FROM EmailTemplate
                                                   WHERE Name ='Error Creating Community User'];
        String plainBody  = CustomEmailTemplate[0].Body;
        plainBody  = plainBody.replace('{!exception}',error);
        plainBody  = plainBody.replace(' {!Opportunity.Id}',OpportunityId);
        plainBody  = plainBody.replace('{!Opportunity.Account}',accountName);
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ncmsupport@foundationdirect.com'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        
        List<String> getEmailList = new List<String>();
        getEmailList.add(System.Label.Send_Error_Email_To);
        
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        
        mail.setToAddresses(getEmailList);
        
        mail.setTemplateId(CustomEmailTemplate[0].ID);
        mail.setWhatId(OpportunityId);
        mail.setPlainTextBody(plainBody);
        mail.setSubject('Error Creating Community User');
        mail.setTargetObjectId(System.Label.Send_Error_Email_To_UserID);
        mail.setSaveAsActivity(FALSE);
        messages.add(mail); 
        
        List<Email_Log__c> logList= new List<Email_Log__c>();
        
        If(messages.size() > 0)
        {
            Messaging.sendEmailResult[] sendEmailResults = Messaging.sendEmail(messages);
            system.debug('sendEmailResults : ' + sendEmailResults);
            
            for (Messaging.SendEmailResult mr : sendEmailResults) 
            {
                Email_Log__c el= new Email_Log__c();
                if (mr.isSuccess()) {
                    
                    el.Opportunity__c = OpportunityId;
                    el.User_Creation_Status__c ='Error';
                    el.Contact__c = ContactId;
                    el.Error_Message__c = error;
                    el.From_Email_Address__c = 'ncmsupport@foundationdirect.com';
                    el.To_Email_Address__c =System.Label.Send_Error_Email_To;
                    el.Subject__c ='Community Welcome Email With User Creation';
                    
                } 
                else {
                    // Operation failed, so get all errors                
                    for(Messaging.SendEmailError err : mr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('fields that affected this error: ' + err.getFields());
                        
                        el.Opportunity__c= OpportunityId;
                        el.User_Creation_Status__c ='Error';
                        el.Contact__c = ContactId;
                        el.From_Email_Address__c = 'ncmsupport@foundationdirect.com';
                        el.To_Email_Address__c = System.Label.Send_Error_Email_To;
                        el.Subject__c ='Community Welcome Email With User Creation';
                        el.Error_Message__c = err.getMessage() ;
                    }
                }
                logList.add(el);
            }
        }
        
        insert logList;
    }
    
    /*public static void sendEmailNotification(String userName, String pwd, String contractSignerEmail,Id userId){
System.setPassword(userId, pwd);
if(!String.isBlank(contractSignerEmail))
{
List<Opportunity_Attachment_Email_Content__c> listCustomSettings = [SELECT Email_Body__c,Email_Subject__c,Name
FROM Opportunity_Attachment_Email_Content__c
WHERE Name ='Community Welcome Email'];
List<String> getEmailList = new List<String>();
getEmailList.add(contractSignerEmail);

List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();

Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

mail.setSubject(listCustomSettings[0].Email_Subject__c);
mail.setToAddresses(getEmailList);
String emailBody = listCustomSettings[0].Email_Body__c ;
mail.setHtmlBody(emailBody + 
'<br/> Username: '+userName +
'<br/> Password: '+pwd);
messages.add(mail); 

If(messages.size() > 0)
{
Messaging.sendEmailResult[] sendEmailResults = Messaging.sendEmail(messages);
system.debug('sendEmailResults : ' + sendEmailResults);
}
}
}*/
    
}