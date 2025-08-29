public class Th_OpportunityTriggerHelper 
{
    public static void onAfterUpdate(List<Opportunity> listOpportunities, Map<Id, Opportunity> mapOpportunities)
    {
        If(!listOpportunities.isEmpty())
        {
            Set<String> setContactEmails = new Set<String>();
            
            For(Opportunity objOpportunity : listOpportunities)
            {
                If(objOpportunity.NCM_Composite_Email__c != null && objOpportunity.NCM_Composite_Email__c != mapOpportunities.get(objOpportunity.Id).NCM_Composite_Email__c)
                {
                    setContactEmails.add(objOpportunity.NCM_Composite_Email__c);
                }
                
                If(objOpportunity.GA_Contact_Email__c != null && objOpportunity.GA_Contact_Email__c != mapOpportunities.get(objOpportunity.Id).GA_Contact_Email__c)
                {
                    setContactEmails.add(objOpportunity.GA_Contact_Email__c);
                }
                
                If(objOpportunity.Inventory_Contact_Email__c != null && objOpportunity.Inventory_Contact_Email__c != mapOpportunities.get(objOpportunity.Id).Inventory_Contact_Email__c)
                {
                    setContactEmails.add(objOpportunity.Inventory_Contact_Email__c);
                }
                
                If(objOpportunity.Onboarding_Contact_Email__c != null && objOpportunity.Onboarding_Contact_Email__c != mapOpportunities.get(objOpportunity.Id).Onboarding_Contact_Email__c)
                {
                    setContactEmails.add(objOpportunity.Onboarding_Contact_Email__c);
                }
            }
            
            If(!setContactEmails.isEmpty())
            {
                List<Contact> listContacts = [SELECT ID, accountId, Email,
                                              (SELECT Id, Roles, accountId, contactId FROM AccountContactRelations) 
                                              FROM Contact 
                                              WHERE Email IN : setContactEmails
                                             ];
                
                Map<String, AccountContactRelation> mapAccountContactRelations = new Map<String, AccountContactRelation>();
                Map<String, Contact> mapContactWithSameEmails = new Map<String, Contact>();
                Map<String, List<Contact>> mapAccountIdAndContacts = new Map<String, List<Contact>>();
                
                If(!listContacts.isEmpty())
                {            
                    For(Contact objContact : listContacts)
                    {
                        If(objContact.AccountId != null && !mapAccountIdAndContacts.containsKey(objContact.AccountId))
                        {
                            mapAccountIdAndContacts.put(objContact.AccountId, new List<Contact>{objContact});  
                        }
                        Else If(objContact.AccountId != null)
                        {
                            mapAccountIdAndContacts.get(objContact.AccountId).add(objContact);   
                        }
                    }
                }
                
                For(Opportunity objOpportunity : listOpportunities)
                {
                    If(objOpportunity.AccountId != null && mapAccountIdAndContacts.containsKey(objOpportunity.AccountId) && mapAccountIdAndContacts.get(objOpportunity.AccountId) != null)
                    {
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
                                            
                                            If(!listStrings.contains('Analytics'))
                                            {
                                                listStrings.add('Analytics');
                                                
                                                objAccountContactRelation.Roles = String.join(listStrings, ';');
                                                
                                                mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                            }
                                        }
                                        Else
                                        {
                                            listStrings.add('Analytics');
                                            
                                            objAccountContactRelation.Roles = String.join(listStrings, ';');
                                            
                                            mapAccountContactRelations.put(objAccountContactRelation.Id, objAccountContactRelation);
                                        }
                                    }
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
                            }
                        }
                    }
                    Else If(objOpportunity.AccountId != null && !mapAccountIdAndContacts.containsKey(objOpportunity.AccountId))
                    {
                        If(objOpportunity.NCM_Composite_Email__c != null && objOpportunity.NCM_Composite_Email__c != mapOpportunities.get(objOpportunity.Id).NCM_Composite_Email__c)
                        {
                            If(!mapContactWithSameEmails.containsKey(objOpportunity.NCM_Composite_Email__c))
                            {
                                Contact objContact = new Contact();
                                objContact.AccountId = objOpportunity.AccountId;
                                
                                If(objOpportunity.NCM_Composite_First_Name__c != null)
                                {
                                    objContact.FirstName = objOpportunity.Onboarding_Contact_First_Name__c;
                                }
                                
                                If(objOpportunity.NCM_Composite_Last_Name__c != null)
                                {
                                    objContact.LastName = objOpportunity.NCM_Composite_Last_Name__c;
                                }
                                
                                If(Test.isRunningTest())
                                {
                                    objContact.LastName = 'Test Class';
                                }
                                
                                objContact.Email = objOpportunity.NCM_Composite_Email__c; 
                                
                                mapContactWithSameEmails.put(objOpportunity.NCM_Composite_Email__c, objContact);
                            }
                        }
                        
                        If(objOpportunity.GA_Contact_Email__c != null && objOpportunity.GA_Contact_Email__c != mapOpportunities.get(objOpportunity.Id).GA_Contact_Email__c)
                        {
                            If(!mapContactWithSameEmails.containsKey(objOpportunity.GA_Contact_Email__c))
                            {
                                Contact objContact = new Contact();
                                objContact.AccountId = objOpportunity.AccountId;
                                
                                If(objOpportunity.GA_Contact_First_Name__c != null)
                                {
                                    objContact.FirstName = objOpportunity.GA_Contact_First_Name__c;
                                }
                                
                                If(objOpportunity.GA_Contact_Last_Name__c != null)
                                {
                                    objContact.LastName = objOpportunity.GA_Contact_Last_Name__c;
                                }
                                
                                objContact.Email = objOpportunity.GA_Contact_Email__c; 
                                
                                If(objOpportunity.GA_Contact_Phone__c != null)
                                {
                                    objContact.Phone = objOpportunity.GA_Contact_Phone__c;
                                }
                                
                                If(Test.isRunningTest())
                                {
                                    objContact.LastName = 'Test Class';
                                }
                                
                                
                                mapContactWithSameEmails.put(objOpportunity.GA_Contact_Email__c, objContact);
                            }
                        }
                        
                        If(objOpportunity.Inventory_Contact_Email__c != null && objOpportunity.Inventory_Contact_Email__c != mapOpportunities.get(objOpportunity.Id).Inventory_Contact_Email__c)
                        {
                            If(!mapContactWithSameEmails.containsKey(objOpportunity.Inventory_Contact_Email__c))
                            {
                                Contact objContact = new Contact();
                                objContact.AccountId = objOpportunity.AccountId;
                                
                                If(objOpportunity.Inventory_Contact_First_Name__c != null)
                                {
                                    objContact.FirstName = objOpportunity.Inventory_Contact_First_Name__c;
                                }
                                
                                If(objOpportunity.Inventory_Contact_Last_Name__c != null)
                                {
                                    objContact.LastName = objOpportunity.Inventory_Contact_Last_Name__c;
                                }
                                
                                If(Test.isRunningTest())
                                {
                                    objContact.LastName = 'Test Class';
                                }
                                
                                If(objOpportunity.Inventory_Contact_Phone__c != null)
                                {
                                    objContact.Phone = objOpportunity.Inventory_Contact_Phone__c;
                                }
                                
                                objContact.Email = objOpportunity.Inventory_Contact_Email__c;
                                
                                mapContactWithSameEmails.put(objOpportunity.Inventory_Contact_Email__c, objContact);
                            }
                        }
                        
                        If(objOpportunity.Onboarding_Contact_Email__c != null && objOpportunity.Onboarding_Contact_Email__c != mapOpportunities.get(objOpportunity.Id).Onboarding_Contact_Email__c)
                        {
                            If(!mapContactWithSameEmails.containsKey(objOpportunity.Onboarding_Contact_Email__c))
                            {
                                Contact objContact = new Contact();
                                objContact.AccountId = objOpportunity.AccountId;
                                
                                If(objOpportunity.Onboarding_Contact_First_Name__c != null)
                                {
                                    objContact.FirstName = objOpportunity.Onboarding_Contact_First_Name__c;
                                }
                                
                                If(objOpportunity.Onboarding_Contact_Last_Name__c != null)
                                {
                                    objContact.LastName = objOpportunity.Onboarding_Contact_Last_Name__c;
                                }
                                
                                If(objOpportunity.Onboarding_Contact_Phone__c != null)
                                {
                                    objContact.Phone = objOpportunity.Onboarding_Contact_Phone__c;
                                }
                                
                                If(Test.isRunningTest())
                                {
                                    objContact.LastName = 'Test Class';
                                }
                                
                                objContact.Email = objOpportunity.Onboarding_Contact_Email__c;
                                
                                mapContactWithSameEmails.put(objOpportunity.Onboarding_Contact_Email__c, objContact);
                            }
                        }
                    }
                }
                
                If(!mapAccountContactRelations.isEmpty())
                {
                    UPDATE mapAccountContactRelations.values();
                }
                
                If(!mapContactWithSameEmails.isEmpty())
                {
                    INSERT mapContactWithSameEmails.values();
                    
                    Set<Id> setContactIds = new Set<Id>();
                    
                    For(Contact objContact : mapContactWithSameEmails.values())
                    {
                        setContactIds.add(objContact.Id);
                    }
                    
                    If(!setContactIds.isEmpty())
                    {
                        List<String> listStrings = new List<String>();
                        listStrings.add(Json.serialize(setContactIds));
                        listStrings.add(Json.serialize(listOpportunities));
                        
                        updateAccountContactRelationRecord(listStrings);
                    }
                }
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