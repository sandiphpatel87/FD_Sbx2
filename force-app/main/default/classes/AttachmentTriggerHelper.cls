public class AttachmentTriggerHelper {
    
    public static void onAfterInsert(List<Attachment> listOfAttachmentsRec)
    {
        Set<String> setOfOppIds = new Set<String>();
        
        For(Attachment objAtt : listOfAttachmentsRec)
        {
            if(objAtt.Name != null && objAtt.Name.indexOf('Signature') != -1 && objAtt.ParentId != null)
            {
                setOfOppIds.add(objAtt.ParentId);
            }
        }
        
        system.debug('setOfOppIds : ' + setOfOppIds);
        
        If(!setOfOppIds.isEmpty())
        {
            List<Opportunity> listOpportunities = [SELECT Id, Contract_Signed_Date__c ,Account.Name,Contract_Signer_Email__c
                                                   FROM Opportunity 
                                                   WHERE Id IN : setOfOppIds
                                                  ];
            
            system.debug('listOpportunities : ' + listOpportunities);
            
            If(!listOpportunities.isEmpty())
            {
                For(Opportunity objOpportunity : listOpportunities)
                {
                    objOpportunity.Contract_Signed_Date__c = Date.today();
                    objOpportunity.Contract_Signed_Date_Time__c =  DateTime.now().format();     
                }
                
                System.debug('Update Opportunity : ' + listOpportunities);
                
                UPDATE listOpportunities;
                For(Opportunity objOpportunity : listOpportunities)
                {
                    OpportunityPdfGenerateForNCM.GeneratePDF(objOpportunity.Id,objOpportunity.Contract_Signer_Email__c,objOpportunity.Account.Name);
                }
                
            }
        }
        
        
    }
    public static void onAfterInsertAndDelete(List<Attachment> listOfAttachmentsRec){
        
        Set<String> setOfCoopIds = new Set<String>();
        if(listOfAttachmentsRec.size()>0){
        For(Attachment objAtt : listOfAttachmentsRec)
        {
            if(objAtt.Name != null && objAtt.ParentId != null)
            {
                setOfCoopIds.add(objAtt.ParentId);
            }
        }
        
        system.debug('setOfCoopIds : ' + setOfCoopIds);
        
        If(!setOfCoopIds.isEmpty())
        {
            List<Coop__c> listCoops = [SELECT Id,Account__c,Has_File__c,(SELECT ID FROM Attachments) 
                                       FROM Coop__c 
                                       WHERE Id IN : setOfCoopIds];
            
            system.debug('listCoops : ' + listCoops);
            
             If(!listCoops.isEmpty())
            {
                For(Coop__c objCoop : listCoops)
                {
                    if((objCoop.Attachments).size() > 0)
                    {
                         System.debug('objCoop Attachments size > 0');
                        objCoop.Has_File__c = true;
                    }    
                }
                
                System.debug('Update Coop : ' + listCoops);
                
                UPDATE listCoops;
            }
        }
        }
    }
}