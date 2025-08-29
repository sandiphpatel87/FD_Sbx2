trigger create_OppProduct_History on OpportunityLineItem (before delete, after delete) {
    
    List<OpportunityLineItem> oppProductList = new List<OpportunityLineItem>();
    public static List<Opportunity> updateOppList;
    String sizeString = 'Let\'s Imagine this is more than 120 Characters';
    Integer maxSize = 79;
    if(trigger.isDelete && trigger.isBefore)
    {
        List<Product_History__c> lstToInsrt = new List<Product_History__c>();  
        oppProductList = [Select ID,Name,Product2.Name,Profit_center_new__c,Profit_center_used__c,
                                                    Profit_center_service__c,MRR__c,ARR__c,Setup_Fee__c,OpportunityId,Opportunity.Contract_Signer__c,
                                                    Opportunity.Contract_Signer_Title__c,Opportunity.Contract_Signed_Date__c,Opportunity.CloseDate,
                                                    Opportunity.Total_MRR__c,Opportunity.StageName,Opportunity.ARR__c,Opportunity.Licensing_fee__c
                                                    from OpportunityLineItem where ID IN: trigger.old];
        for(OpportunityLineItem deletedProd : oppProductList)
        {
            sizeString = deletedProd.Name;
            if(sizeString.length() > maxSize ){
                sizeString = sizeString.substring(0, maxSize);
            }
    
            system.debug('deletedProd >> '+deletedProd );
            Product_History__c backup = new Product_History__c();
            backup.Name = sizeString;
            backup.Contract_Signer__c = deletedProd.Opportunity.Contract_Signer__c;
            backup.Contract_Signer_Title__c = deletedProd.Opportunity.Contract_Signer_Title__c;
            backup.Contract_Signed_Date__c = deletedProd.Opportunity.Contract_Signed_Date__c;
            backup.Close_Date__c = deletedProd.Opportunity.CloseDate;
            backup.MRR__c = deletedProd.Opportunity.Total_MRR__c;
            backup.ARR__c = deletedProd.Opportunity.ARR__c;
            backup.Licensing_fee__c = deletedProd.Opportunity.Licensing_fee__c;
            backup.Product_Name__c = deletedProd.Product2.Name;
            backup.Profit_Center_New__c = deletedProd.Profit_center_new__c;
            backup.Profit_Center_Used__c = deletedProd.Profit_center_used__c;
            backup.Profit_Center_Serviced__c = deletedProd.Profit_center_service__c;
            backup.Product_MRR__c = deletedProd.MRR__c;
            backup.Product_ARR__c = deletedProd.ARR__c;
            backup.Setup_Fee__c = deletedProd.Setup_Fee__c;
            backup.Opportunity__c = deletedProd.OpportunityId;
            backup.Stage__c = deletedProd.Opportunity.StageName;
            lstToInsrt.add(backup);
            //Update opp 
            updateOppList = new List<Opportunity>();
            Opportunity opp = new Opportunity();
             opp.id = deletedProd.OpportunityId;
             opp.Contract_Signer__c = '';
             opp.Contract_Signer_Title__c = '';
             opp.Contract_Signed_Date__c = null;
             opp.Licensing_fee__c = 0;
             updateOppList.add(opp);
            
        }
        if(lstToInsrt.size()>0)
        {
            insert lstToInsrt;
            //system.debug('list'+lstToInsrt);
        }
         if(updateOppList.size()>0)
        {
            update updateOppList;
        }
    }
}