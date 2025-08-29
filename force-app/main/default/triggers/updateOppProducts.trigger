trigger updateOppProducts on OpportunityLineItem (After Insert) {

     If(Trigger.IsInsert)
    {	
        List<OpportunityLineItem> updateOppLineItem = new List<OpportunityLineItem>();
        For(OpportunityLineItem lineItem : [Select Id, Product2Id,Product2.Profit_center_new__c,Product2.Licensing_fee__c,Product2.Profit_center_service__c,Product2.Profit_center_used__c, Product2.MRR__c,Product2.Set_up_Fee__c, OpportunityId FROM OpportunityLineItem WHERE Id =: trigger.New])
        {
           // system.debug('The Products name is: ' + lineItem.Product2.Name);
           system.debug('The Products type is: ' + lineItem.Product2.MRR__c);
           
           //List<OpportunityLineItem> comingOppLineItemInfo = [Select Id, Product2Id,Product2.Product_Profit_Centers__c, Product2.MRR__c,Product2.Set_up_Fee__c, OpportunityId FROM OpportunityLineItem WHERE Id =:lineItem.Id LIMIT 1];
           //system.debug('The Products type is: ' + comingOppLineItemInfo);
            //If(!comingOppLineItemInfo.IsEmpty())
            //{
                //system.debug('The Products type is Emprty: ');
                If(lineItem.Product2Id != null)
                {
                    OpportunityLineItem updtlitm = new OpportunityLineItem();
                    system.debug('The Products type is Product2Id: ');
                    updtlitm.MRR__c = lineItem.Product2.MRR__c;
                    updtlitm.Setup_Fee__c = lineItem.Product2.Set_up_Fee__c;
                    updtlitm.Profit_center_new__c = lineItem.Product2.Profit_center_new__c;
                    updtlitm.Profit_center_service__c = lineItem.Product2.Profit_center_service__c;
                    updtlitm.Profit_center_used__c = lineItem.Product2.Profit_center_used__c;
                    updtlitm.Licensing_fee__c = lineItem.Product2.Licensing_fee__c;
                    updtlitm.id = lineItem.id;
                    updateOppLineItem.add(updtlitm);
                }
            //}
            
        }
        if(updateOppLineItem.size() > 0){update updateOppLineItem;}
    }
}