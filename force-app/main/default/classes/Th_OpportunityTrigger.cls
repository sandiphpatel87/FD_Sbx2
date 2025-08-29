public class Th_OpportunityTrigger 
{
    /*This method will run on opportunity update*/
    Public static void AfterEmailUpdate(Map<Id, Opportunity> oldOppMap, List<Opportunity> lstNew)
    {
        Map<Id, List<Opportunity>> usefulOpps = new Map<Id, List<Opportunity>>();
        Set<String> email1Set = new Set<String>();
        Set<String> email2Set = new Set<String>();
        Set<String> email3Set = new Set<String>();
        Set<String> email4Set = new Set<String>();
        Map<Id, AccountContactRelation> mapOfAccountContactRelationIdandObj = new Map<Id, AccountContactRelation>();
        
        Map<Contact, Contact> contactToInsertMap = new Map<Contact, Contact>();
        
        List<AccountContactRelation> updateAccountContactRelationList = new List<AccountContactRelation>();
        List<contact> listOfNewContact = new List<Contact>();
        Map<Id, List<Contact>> accRelatedContacts = new Map<Id, List<Contact>>();
        Map<String, List<Contact>> contactWithSameEmailMap = new Map<String, List<Contact>>();
        
        If(!lstNew.isEmpty())
        {
            //Keeping usefull opprtunity ids with their account id to the map
            For(Opportunity newOpp : lstNew)
            {
                If((newOpp.NCM_Composite_Email__c != null && newOpp.NCM_Composite_Email__c != oldOppMap.get(newOpp.Id).NCM_Composite_Email__c) || 
                   (newOpp.Onboarding_Contact_Email__c != null && newOpp.Onboarding_Contact_Email__c != oldOppMap.get(newOpp.Id).Onboarding_Contact_Email__c) || 
                   (newOpp.GA_Contact_Email__c != null && newOpp.GA_Contact_Email__c != oldOppMap.get(newOpp.Id).GA_Contact_Email__c) || 
                   (newOpp.Inventory_Contact_Email__c != null && newOpp.Inventory_Contact_Email__c != oldOppMap.get(newOpp.Id).Inventory_Contact_Email__c))
                {
                    If(newOpp.AccountId != null && !usefulOpps.containsKey(newOpp.AccountId))
                    {
                        usefulOpps.put(newOpp.AccountId, new List<Opportunity>{newOpp});  
                    }
                    Else If(newOpp.AccountId != null)
                    {
                        usefulOpps.get(newOpp.AccountId).add(newOpp);   
                    }
                }
                //Setting emails to use them as filter in contact query
                If(newOpp.NCM_Composite_Email__c != null && newOpp.NCM_Composite_Email__c != oldOppMap.get(newOpp.Id).NCM_Composite_Email__c)
                {
                    email1Set.add(newOpp.NCM_Composite_Email__c);
                }
                If(newOpp.Onboarding_Contact_Email__c != null && newOpp.Onboarding_Contact_Email__c != oldOppMap.get(newOpp.Id).Onboarding_Contact_Email__c)
                {
                    email2Set.add(newOpp.Onboarding_Contact_Email__c);
                }
                If(newOpp.GA_Contact_Email__c != null && newOpp.GA_Contact_Email__c != oldOppMap.get(newOpp.Id).GA_Contact_Email__c)
                {
                    email3Set.add(newOpp.GA_Contact_Email__c);
                }
                If(newOpp.Inventory_Contact_Email__c != null && newOpp.Inventory_Contact_Email__c != oldOppMap.get(newOpp.Id).Inventory_Contact_Email__c)
                {
                    email4Set.add(newOpp.Inventory_Contact_Email__c);
                }
            }
            
            //Querying those contact from system which matches emails
            List<Contact> oppRelatedContactList = [SELECT ID, accountId, Email,
                                                   (SELECT Id, Roles,accountId,contactId FROM AccountContactRelations) 
                                                   FROM Contact 
                                                   WHERE (Email IN : email1Set OR Email IN : email2Set OR Email IN : email3Set OR Email IN : email4Set )
                                                  ];
            
            If(!oppRelatedContactList.isEmpty())
            {
                //Grouping contact with same account here
                For(Contact con : oppRelatedContactList)
                {
                    If(con.AccountId != null && !accRelatedContacts.containsKey(con.AccountId))
                    {
                        accRelatedContacts.put(con.AccountId,new List<Contact>{con});  
                    }
                    Else If(con.AccountId != null)
                    {
                        accRelatedContacts.get(con.AccountId).add(con);   
                    }
                }
            }
            
            //Updating roles on AccountContactRelation record and if contact does not exists in system then create one
            For(Opportunity newOpp : lstNew)
            {
                If(newOpp.AccountId != null && accRelatedContacts.containsKey(newOpp.AccountId) && accRelatedContacts.get(newOpp.AccountId) != null)
                {
                    For(Contact objCon : accRelatedContacts.get(newOpp.AccountId)) 
                    {
                        If(newOpp.Inventory_Contact_Email__c != null && objCon.Email != null && newOpp.Inventory_Contact_Email__c == objCon.Email)
                        {
                            //If AccountContactRelation Record exist
                            If(objCon.AccountContactRelations.size() > 0)
                            {
                                For(AccountContactRelation objRelatedCon : objCon.AccountContactRelations) 
                                {
                                    List<String> strs = new List<String>();
                                    If(objRelatedCon.Roles != null)
                                    {
                                        If(objRelatedCon.Roles.contains(';'))
                                        {
                                            strs = objRelatedCon.Roles.split(';');  
                                        }
                                        else
                                        {
                                            strs.add(objRelatedCon.Roles);  
                                        }
                                        If(!strs.contains('Inventory'))
                                        {
                                            strs.add('Inventory');
                                            objRelatedCon.Roles = String.join(strs, ';');
                                            mapOfAccountContactRelationIdandObj.put(objRelatedCon.Id, objRelatedCon);
                                            
                                            updateAccountContactRelationList.add(objRelatedCon);
                                        }
                                    }
                                    Else
                                    {
                                        strs.add('Inventory');
                                        objRelatedCon.Roles = String.join(strs, ';');
                                        mapOfAccountContactRelationIdandObj.put(objRelatedCon.Id, objRelatedCon);
                                        
                                        updateAccountContactRelationList.add(objRelatedCon);   
                                    }
                                }
                            }
                        }
                        
                        If(newOpp.NCM_Composite_Email__c != null && objCon.Email != null && newOpp.NCM_Composite_Email__c == objCon.Email)
                        {
                            If(objCon.AccountContactRelations.size() > 0)
                            {
                                For(AccountContactRelation objRelatedCon : objCon.AccountContactRelations) 
                                {
                                    List<String> strs = new List<String>();
                                    System.debug('objRelatedCon ---' + objRelatedCon.Roles);
                                    If(objRelatedCon.Roles != null)
                                    {
                                        If(objRelatedCon.Roles.contains(';'))
                                        {
                                            strs = objRelatedCon.Roles.split(';');  
                                        }
                                        else
                                        {
                                            strs.add(objRelatedCon.Roles);  
                                        }
                                        If(!strs.contains('NCM Login'))
                                        {
                                            strs.add('NCM Login');
                                            objRelatedCon.Roles = String.join(strs, ';');
                                            mapOfAccountContactRelationIdandObj.put(objRelatedCon.Id, objRelatedCon);
                                            
                                            updateAccountContactRelationList.add(objRelatedCon);
                                        }
                                    }
                                    Else
                                    {
                                        strs.add('NCM Login');
                                        objRelatedCon.Roles = String.join(strs, ';');
                                        mapOfAccountContactRelationIdandObj.put(objRelatedCon.Id, objRelatedCon);
                                        
                                        updateAccountContactRelationList.add(objRelatedCon);   
                                    }
                                }
                            }
                        }
                        
                        If(newOpp.GA_Contact_Email__c != null && objCon.Email != null && newOpp.GA_Contact_Email__c == objCon.Email)
                        {
                            If(objCon.AccountContactRelations.size() > 0)
                            {
                                For(AccountContactRelation objRelatedCon : objCon.AccountContactRelations) 
                                {
                                    List<String> strs = new List<String>();
                                    If(objRelatedCon.Roles != null)
                                    {
                                        If(objRelatedCon.Roles.contains(';'))
                                        {
                                            strs = objRelatedCon.Roles.split(';');  
                                        }
                                        else
                                        {
                                            strs.add(objRelatedCon.Roles);  
                                        }
                                        If(!strs.contains('Analytics'))
                                        {
                                            strs.add('Analytics');
                                            objRelatedCon.Roles = String.join(strs, ';');
                                            mapOfAccountContactRelationIdandObj.put(objRelatedCon.Id, objRelatedCon);
                                            updateAccountContactRelationList.add(objRelatedCon);
                                        }
                                    }
                                    Else
                                    {
                                        strs.add('Analytics');
                                        objRelatedCon.Roles = String.join(strs, ';');
                                        mapOfAccountContactRelationIdandObj.put(objRelatedCon.Id, objRelatedCon);
                                        updateAccountContactRelationList.add(objRelatedCon);   
                                    }
                                }
                                
                            }
                        }
                        
                        If(newOpp.Onboarding_Contact_Email__c != null && objCon.Email != null && newOpp.Onboarding_Contact_Email__c == objCon.Email)
                        {
                            If(objCon.AccountContactRelations.size() > 0)
                            {
                                For(AccountContactRelation objRelatedCon : objCon.AccountContactRelations) 
                                {
                                    List<String> strs = new List<String>();
                                    If(objRelatedCon.Roles != null)
                                    {
                                        If(objRelatedCon.Roles.contains(';'))
                                        {
                                            strs = objRelatedCon.Roles.split(';');  
                                        }
                                        Else
                                        {
                                            strs.add(objRelatedCon.Roles);  
                                        }
                                        If(!strs.contains('Onboarding'))
                                        { 
                                            strs.add('Onboarding');
                                            objRelatedCon.Roles = String.join(strs, ';');
                                            mapOfAccountContactRelationIdandObj.put(objRelatedCon.Id, objRelatedCon);
                                            
                                            updateAccountContactRelationList.add(objRelatedCon);
                                        }
                                    }
                                    Else
                                    {
                                        strs.add('Onboarding');
                                        objRelatedCon.Roles = String.join(strs, ';');
                                        mapOfAccountContactRelationIdandObj.put(objRelatedCon.Id, objRelatedCon);
                                        
                                        updateAccountContactRelationList.add(objRelatedCon);   
                                    }
                                }
                                
                            }
                        }
                    }
                }
                Else If(newOpp.AccountId != null && !accRelatedContacts.containsKey(newOpp.AccountId))
                {
                    system.debug('accRelatedContacts ---' + accRelatedContacts.containsKey(newOpp.AccountId));
                    If(newOpp.NCM_Composite_Email__c != null && newOpp.NCM_Composite_Email__c != oldOppMap.get(newOpp.Id).NCM_Composite_Email__c)
                    {
                        If(!contactWithSameEmailMap.containsKey(newOpp.NCM_Composite_Email__c))
                        {
                            Contact objCont = new Contact();
                            objCont.AccountId = newOpp.AccountId;
                            objCont.LastName = 'Test';
                            objCont.Email = newOpp.NCM_Composite_Email__c; 
                            objCont.Phone = '9090909090';
                            listOfNewContact.add(objCont);
                            
                            contactToInsertMap.put(objCont, objCont);
                            
                            contactWithSameEmailMap.put(newOpp.NCM_Composite_Email__c, new List<Contact>{objCont});  
                        }
                    }
                    system.debug('listOfNewContact 1---' + listOfNewContact);
                    system.debug('contactToInsertMap1 -- ' + contactToInsertMap);
                    
                    system.debug('contactWithSameEmailMap 1---' + contactWithSameEmailMap);
                    
                    
                    If(newOpp.GA_Contact_Email__c != null && newOpp.GA_Contact_Email__c != oldOppMap.get(newOpp.Id).GA_Contact_Email__c)
                    {
                        If(!contactWithSameEmailMap.containsKey(newOpp.GA_Contact_Email__c))
                        {
                            Contact objCont = new Contact();
                            objCont.AccountId = newOpp.AccountId;
                            objCont.LastName = 'Test';
                            objCont.Email = newOpp.GA_Contact_Email__c; 
                            objCont.Phone = '9090909090';
                            listOfNewContact.add(objCont);
                            contactToInsertMap.put(objCont, objCont);
                            contactWithSameEmailMap.put(newOpp.GA_Contact_Email__c, new List<Contact>{objCont});  
                            
                        }
                    }
                    
                    system.debug('listOfNewContact 2---' + listOfNewContact);
                    system.debug('contactToInsertMap2 -- ' + contactToInsertMap);
                    
                    system.debug('contactWithSameEmailMap 2---' + contactWithSameEmailMap);
                    If(newOpp.Onboarding_Contact_Email__c != null && newOpp.Onboarding_Contact_Email__c != oldOppMap.get(newOpp.Id).Onboarding_Contact_Email__c)
                    {
                        If(!contactWithSameEmailMap.containsKey(newOpp.Onboarding_Contact_Email__c))
                        {
                            Contact objCont = new Contact();
                            objCont.AccountId = newOpp.AccountId;
                            objCont.LastName = 'Test';
                            objCont.Email = newOpp.Onboarding_Contact_Email__c; 
                            objCont.Phone = '9090909090';
                            listOfNewContact.add(objCont);
                            contactToInsertMap.put(objCont, objCont);
                            contactWithSameEmailMap.put(newOpp.Onboarding_Contact_Email__c, new List<Contact>{objCont});  
                            
                        }
                    }
                    
                    system.debug('listOfNewContact 3---' + listOfNewContact);
                    system.debug('contactToInsertMap3 -- ' + contactToInsertMap);
                    
                    system.debug('contactWithSameEmailMap 3---' + contactWithSameEmailMap);
                    If(newOpp.Inventory_Contact_Email__c != null && newOpp.Inventory_Contact_Email__c != oldOppMap.get(newOpp.Id).Inventory_Contact_Email__c)
                    {
                        If(!contactWithSameEmailMap.containsKey(newOpp.Inventory_Contact_Email__c))
                        {
                            Contact objCont = new Contact();
                            objCont.AccountId = newOpp.AccountId;
                            objCont.LastName = 'Test';
                            objCont.Email = newOpp.Inventory_Contact_Email__c; 
                            objCont.Phone = '9090909090';
                            listOfNewContact.add(objCont);
                            contactToInsertMap.put(objCont, objCont);
                            contactWithSameEmailMap.put(newOpp.Inventory_Contact_Email__c, new List<Contact>{objCont});  
                        }
                    }
                    
                    system.debug('listOfNewContact 4---' + listOfNewContact);
                    system.debug('contactToInsertMap4 -- ' + contactToInsertMap);
                    
                    system.debug('contactWithSameEmailMap 4---' + contactWithSameEmailMap);
                }
            }
            
            
            
            UPDATE mapOfAccountContactRelationIdandObj.Values();    
            //UPDATE updateAccountContactRelationList;
            System.debug('listOfNewContact --' + listOfNewContact.size());
            //INSERT listOfNewContact;
            system.debug('contactToInsertMap -- ' + contactToInsertMap.size());
            If(contactToInsertMap.KeySet().size() > 0)
            {
                List<Contact> listInsertContacts = new List<Contact>();
                listInsertContacts.addAll(contactToInsertMap.KeySet());
                INSERT listInsertContacts;   
            }
            
            System.debug('listOfNewContactafter --' + listOfNewContact.size());
            
            Set<Id> setContactIds = new Set<Id>();
            
            For(Contact objContact : listOfNewContact)
            {
                setContactIds.add(objContact.Id);
            }
            
            If(!setContactIds.isEmpty())
            {
                List<String> listStrings = new List<String>();
                listStrings.add(Json.serialize(setContactIds));
                listStrings.add(Json.serialize(lstNew));
                
                updateAccountContactRelationRecord(listStrings);
            }
        }
    }
    
    
    /*This method is to update roles on AccountContactRelation Records*/
    @future
    public static void updateAccountContactRelationRecord(List<String> listStrings)
    {
        Set<Id> setContactIds = new Set<Id>();
        List<Opportunity> listOpportunities = new List<Opportunity>();
        //Map for email and its related contact record
        Map<String, Contact> mapEmailContacts = new Map<String, Contact>();
        Map<Id, AccountContactRelation> mapOfAccountContactRelationIdandObj = new Map<Id, AccountContactRelation>();
        List<AccountContactRelation> updateAccountContactRelationList = new List<AccountContactRelation>();
        //Map Of Email and AccountContactRelation  record
        Map<String, AccountContactRelation> mapEmailAndAccountContactRelations = new Map<String, AccountContactRelation>();
        //Contact set of Ids Which we just inserted for new emails in the org
        setContactIds = (Set<Id>)Json.deserialize(listStrings[0], Set<Id>.class);
        //Opportunities that just updated (Trigger.New)
        listOpportunities = (List<Opportunity>)Json.deserialize(listStrings[1], List<Opportunity>.class);
        
        List<Contact> listContacts = [SELECT Id, AccountId, Email
                                      FROM Contact
                                      WHERE Id IN : setContactIds
                                     ];
        If(!listContacts.isEmpty())
        {
            For(Contact objContact : listContacts)
            {
                If(objContact.Email != null && !mapEmailContacts.containsKey(objContact.Email))
                {
                    mapEmailContacts.put(objContact.Email, objContact);
                }
            }
        }
        
        //Querying accountContactRelationship related to above conatct
        List<AccountContactRelation> listAccountContactRelations = [SELECT Id, AccountId, ContactId, Contact.Email, Roles
                                                                    FROM AccountContactRelation
                                                                    WHERE ContactId IN : setContactIds
                                                                   ];
        If(!listAccountContactRelations.isEmpty())
        {
            //Putting contact email and accountContactRelationship Record to the map
            For(AccountContactRelation objAccountContactRelation : listAccountContactRelations)
            {
                If(objAccountContactRelation.ContactId != null && objAccountContactRelation.Contact.Email != null)
                {
                    mapEmailAndAccountContactRelations.put(objAccountContactRelation.Contact.Email, objAccountContactRelation);
                }
            }
        }
        
        //Here we are updation roles on AccountContactRelationship On the basis of opportunity's email field
        For(Opportunity newOpp : listOpportunities)
        {
            
            Map<String, String> m = new Map<String, String>();
            
            If(newOpp.Inventory_Contact_Email__c != null && mapEmailContacts.containsKey(newOpp.Inventory_Contact_Email__c))
            {
                If(mapEmailAndAccountContactRelations.containsKey(newOpp.Inventory_Contact_Email__c))
                {
                    AccountContactRelation accConRel = new AccountContactRelation();
                    accConRel.Id = mapEmailAndAccountContactRelations.get(newOpp.Inventory_Contact_Email__c).Id;
                    
                    If(mapEmailAndAccountContactRelations.get(newOpp.Inventory_Contact_Email__c).Roles != null)
                    {
                        If(mapEmailAndAccountContactRelations.get(newOpp.Inventory_Contact_Email__c).Roles.contains(';'))
                        {
                            List<String> listRoles = mapEmailAndAccountContactRelations.get(newOpp.Inventory_Contact_Email__c).Roles.split(';');
                            
                            If(!listRoles.contains('Inventory'))
                            {
                                listRoles.add('Inventory');
                                accConRel.Roles = String.join(listRoles, ';');
                            }
                        }
                        Else
                        {
                            List<String> listRoles = new List<String>();
                            listRoles.add('Inventory');
                            accConRel.Roles = String.join(listRoles, ';');
                        }
                    }
                    else
                    {
                        accConRel.Roles = 'Inventory';
                    }
                    If(newOpp.Inventory_Contact_Email__c == null)
                    {
                        newOpp.Inventory_Contact_Email__c = '';
                    }
                    m.put('Inventory_Contact_Email__c#' + newOpp.Inventory_Contact_Email__c, 'Inventory');
                    
                    mapOfAccountContactRelationIdandObj.put(accConRel.Id, accConRel);
                    updateAccountContactRelationList.add(accConRel);
                }
            }
            
            If(newOpp.GA_Contact_Email__c != null && mapEmailContacts.containsKey(newOpp.GA_Contact_Email__c))
            {
                If(mapEmailAndAccountContactRelations.containsKey(newOpp.GA_Contact_Email__c))
                {
                    AccountContactRelation accConRel = new AccountContactRelation();
                    accConRel.Id = mapEmailAndAccountContactRelations.get(newOpp.GA_Contact_Email__c).Id;
                    
                    If(mapEmailAndAccountContactRelations.get(newOpp.GA_Contact_Email__c).Roles != null)
                    {
                        If(mapEmailAndAccountContactRelations.get(newOpp.GA_Contact_Email__c).Roles.contains(';'))
                        {
                            List<String> listRoles = mapEmailAndAccountContactRelations.get(newOpp.GA_Contact_Email__c).Roles.split(';');
                            
                            If(!listRoles.contains('Analytics'))
                            {
                                listRoles.add('Analytics');
                                accConRel.Roles = String.join(listRoles, ';');
                            }
                        }
                        Else
                        {
                            List<String> listRoles = new List<String>();
                            listRoles.add('Analytics');
                            accConRel.Roles = String.join(listRoles, ';');
                        }
                    }
                    else
                    {
                        List<String> finalRoles = new List<string>();
                        If(m.size() > 0)
                        {
                            For(String str : m.keyset())
                            {
                                If(str.split('#')[0] == 'Inventory_Contact_Email__c' && str.split('#')[1] == newOpp.GA_Contact_Email__c)
                                {
                                    finalRoles.add(m.get(str));  
                                }
                            }
                        }
                        finalRoles.add('Analytics');
                        accConRel.Roles = String.join(finalRoles, ';'); 
                    }
                    If(newOpp.GA_Contact_Email__c == null)
                    {
                        newOpp.GA_Contact_Email__c = '';
                    }
                    m.put('GA_Contact_Email__c#' + newOpp.GA_Contact_Email__c, 'Analytics');
                    mapOfAccountContactRelationIdandObj.put(accConRel.Id, accConRel);
                    
                    updateAccountContactRelationList.add(accConRel);
                }
            }
            
            If(newOpp.Onboarding_Contact_Email__c != null && mapEmailContacts.containsKey(newOpp.Onboarding_Contact_Email__c))
            {
                If(mapEmailAndAccountContactRelations.containsKey(newOpp.Onboarding_Contact_Email__c))
                {
                    AccountContactRelation accConRel = new AccountContactRelation();
                    accConRel.Id = mapEmailAndAccountContactRelations.get(newOpp.Onboarding_Contact_Email__c).Id;
                    
                    If(mapEmailAndAccountContactRelations.get(newOpp.Onboarding_Contact_Email__c).Roles != null)
                    {
                        If(mapEmailAndAccountContactRelations.get(newOpp.Onboarding_Contact_Email__c).Roles.contains(';'))
                        {
                            List<String> listRoles = mapEmailAndAccountContactRelations.get(newOpp.Onboarding_Contact_Email__c).Roles.split(';');
                            
                            If(!listRoles.contains('Onboarding'))
                            {
                                listRoles.add('Onboarding');
                                accConRel.Roles = String.join(listRoles, ';');
                            }
                        }
                        Else
                        {
                            List<String> listRoles = new List<String>();
                            listRoles.add('Onboarding');
                            accConRel.Roles = String.join(listRoles, ';');
                        }
                    }
                    else
                    {
                        List<String> finalRoles = new List<string>();
                        If(m.size() > 0)
                        {
                            For(String str : m.keyset())
                            {
                                If(str.split('#')[0] == 'GA_Contact_Email__c' && str.split('#')[1] == newOpp.Onboarding_Contact_Email__c)
                                {
                                    finalRoles.add(m.get(str)); 
                                }
                                If(str.split('#')[0] == 'Inventory_Contact_Email__c' && str.split('#')[1] == newOpp.Onboarding_Contact_Email__c)
                                {
                                    finalRoles.add(m.get(str));  
                                }
                            }
                        }
                        finalRoles.add('Onboarding');
                        accConRel.Roles = String.join(finalRoles, ';'); 
                    }
                    If(newOpp.Onboarding_Contact_Email__c == null)
                    {
                        newOpp.Onboarding_Contact_Email__c = '';
                    }
                    m.put('Onboarding_Contact_Email__c#' + newOpp.Onboarding_Contact_Email__c, 'Onboarding');
                    mapOfAccountContactRelationIdandObj.put(accConRel.Id,accConRel);
                    
                    updateAccountContactRelationList.add(accConRel);
                }
            }
            
            If(newOpp.NCM_Composite_Email__c != null && mapEmailContacts.containsKey(newOpp.NCM_Composite_Email__c))
            {
                If(mapEmailAndAccountContactRelations.containsKey(newOpp.NCM_Composite_Email__c))
                {
                    AccountContactRelation accConRel = new AccountContactRelation();
                    accConRel.Id = mapEmailAndAccountContactRelations.get(newOpp.NCM_Composite_Email__c).Id;
                    
                    If(mapEmailAndAccountContactRelations.get(newOpp.NCM_Composite_Email__c).Roles != null)
                    {
                        If(mapEmailAndAccountContactRelations.get(newOpp.NCM_Composite_Email__c).Roles.contains(';'))
                        {
                            List<String> listRoles = mapEmailAndAccountContactRelations.get(newOpp.NCM_Composite_Email__c).Roles.split(';');
                            
                            If(!listRoles.contains('NCM Login'))
                            {
                                listRoles.add('NCM Login');
                                accConRel.Roles = String.join(listRoles, ';');
                            }
                        }
                        Else
                        {
                            List<String> listRoles = new List<String>();
                            listRoles.add('NCM Login');
                            accConRel.Roles = String.join(listRoles, ';');
                        }
                    }
                    else
                    {
                        List<String> finalRoles = new List<string>();
                        If(m.size() > 0)
                        {
                            For(String str : m.keyset())
                            {
                                
                                IF(str.split('#')[0] == 'Onboarding_Contact_Email__c' && str.split('#')[1] == newOpp.NCM_Composite_Email__c)
                                {
                                    finalRoles.add(m.get(str));  
                                }
                                If(str.split('#')[0] == 'GA_Contact_Email__c' && str.split('#')[1] == newOpp.NCM_Composite_Email__c)
                                {
                                    finalRoles.add(m.get(str)); 
                                }
                                If(str.split('#')[0] == 'Inventory_Contact_Email__c' && str.split('#')[1] == newOpp.NCM_Composite_Email__c)
                                {
                                    finalRoles.add(m.get(str));  
                                }
                            }
                        }
                        finalRoles.add('NCM Login');
                        accConRel.Roles = String.join(finalRoles, ';'); 
                        
                    }
                    If(newOpp.NCM_Composite_Email__c == null)
                    {
                        newOpp.NCM_Composite_Email__c = '';
                    }
                    m.put('NCM_Composite_Email__c#'+newOpp.NCM_Composite_Email__c,'NCM Login');
                    mapOfAccountContactRelationIdandObj.put(accConRel.Id,accConRel);
                    updateAccountContactRelationList.add(accConRel);
                } 
            }
        }
        UPDATE mapOfAccountContactRelationIdandObj.values();
    }
}