public class UpdateDMA1Helper {
    
    /**
     * @description update the DMA_Id1__c and DMA_name1__c fields on the Account object
     * @param accList the list of accounts to update
     */
    public static void updateDMABeforeInsert(List<Account> acclist)
    {
        List<String> zipCodeList = new List<String>();

        //get the zip codes from the accounts
        for(Account acc: accList){
            if(acc.ShippingPostalCode!=null){
                string str = '';
                if(acc.ShippingPostalCode.length()>=5){
                    str = acc.ShippingPostalCode.substring(0,5);
                    zipCodeList.add(str);
                }
                if(acc.ShippingPostalCode.length()<5){
                    str = acc.ShippingPostalCode.leftPad(5,'0');
                    zipCodeList.add(str);
                }
            }
        }

        //query DMA_Name__c for the zip codes
        List<DMA_Name__c> dmaList = [SELECT id,name,DMA_id__c, Zip_code__c FROM DMA_Name__c  WHERE Zip_code__c IN :zipCodeList];
        Map<String, DMA_Name__c> dmaMap = new Map<String, DMA_Name__c>();
        for(DMA_Name__c dma: dmaList){
            dmaMap.put(dma.Zip_code__c, dma);
        }

        //update the accounts with the DMA_Name__c
        for(Account acc: accList){
            if(acc.ShippingPostalCode!=null){
                acc.DMA_Id1__c = dmaMap.get(acc.ShippingPostalCode)?.DMA_id__c != null ? dmaMap.get(acc.ShippingPostalCode).DMA_id__c : '';
                acc.DMA_name1__c = dmaMap.get(acc.ShippingPostalCode)?.name != null ? dmaMap.get(acc.ShippingPostalCode).name : '';
            }
        }
    }

    /**
     * @description update the DMA_Id1__c and DMA_name1__c fields on the Account object
     * @param accList the list of accounts to update
     * @param mapOldAccList the map of old accounts
     */
    public static void updateDMABeforeUpdate(List<Account> accList,Map<Id, Account> mapOldAccList)
    {
        List<String> zipCodeList = new List<String>();

        //get the zip codes from the accounts
        for(Account acc: accList){
            if(acc.ShippingPostalCode!=null && (acc.ShippingPostalCode!=  mapOldAccList.get(acc.Id)?.ShippingPostalCode)){
                string str = '';
                if(acc.ShippingPostalCode.length()>=5){
                    str = acc.ShippingPostalCode.substring(0,5);
                    zipCodeList.add(str);
                }
                if(acc.ShippingPostalCode.length()<5){
                    str = acc.ShippingPostalCode.leftPad(5,'0');
                    zipCodeList.add(str);
                }
            }
        }

        //query DMA_Name__c for the zip codes
        List<DMA_Name__c> dmaList = [SELECT id,name,DMA_id__c, Zip_code__c FROM DMA_Name__c  WHERE Zip_code__c IN :zipCodeList];
        Map<String, DMA_Name__c> dmaMap = new Map<String, DMA_Name__c>();
        for(DMA_Name__c dma: dmaList){
            dmaMap.put(dma.Zip_code__c, dma);
        }

        //update the accounts with the DMA_Name__c
        for(Account acc: accList){
            if(acc.ShippingPostalCode!=null && (acc.ShippingPostalCode != mapOldAccList.get(acc.Id)?.ShippingPostalCode)){
                acc.DMA_Id1__c = dmaMap.get(acc.ShippingPostalCode)?.DMA_id__c != null ? dmaMap.get(acc.ShippingPostalCode).DMA_id__c : '';
                acc.DMA_name1__c = dmaMap.get(acc.ShippingPostalCode)?.name != null ? dmaMap.get(acc.ShippingPostalCode).name : '';
            }
            if(acc.OEM__c!=  mapOldAccList.get(acc.Id).OEM__c){
                //unordered list with duplicate entries
                List<String> OEMList = (acc.OEM__c).split(';');
                
                //convert list to set (this removes duplicates)
                Set<String> OEMSet = new Set<String>(OEMList);

                //convert set to list (converts set back to list if needed)
                OEMList = new List<String>(OEMSet);
                
                //sort alphabetically (converting set to list results in unordered list)
                OEMList.sort();
                
                string allstring = string.join(OEMList,';');
                acc.OEM__c = allstring;
            }
        }
    }
}