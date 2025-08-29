@Istest
public class testupdateDMA1 {
    @isTest static void updateDMA1(){
        DMA_Name__c dm = new DMA_Name__c();
        dm.name='hi';
        dm.Zip_code__c='54329';
        dm.DMA_id__c='123';
        insert dm;
        
        Account acc = new Account();
        acc.name='hi';
        acc.ShippingPostalCode='54329';
        insert acc;
        
        DMA_Name__c dm1 = new DMA_Name__c();
        dm1.name='hi';
        dm1.Zip_code__c='04329';
        dm1.DMA_id__c='123';
        insert dm1;
        
        Account acc1 = new Account();
        acc1.id=acc.id;
        acc1.ShippingPostalCode='0432901';
        update acc1;
        
        Account acc2 = new Account();
        acc2.id=acc.id;
        acc2.ShippingPostalCode='4329';
        update acc2;
    }
    @isTest static void updateDMA2(){
        
        Account acc = new Account();
        acc.name='hi23';
        acc.ShippingPostalCode='';
        insert acc;
        
        Account acc2 = new Account();
        acc2.id=acc.id;
        acc2.ShippingPostalCode='4329';
        update acc2;
        
    }
    @isTest static void updateDMA3(){
        
        Account acc = new Account();
        acc.name='hi23';
        acc.ShippingPostalCode='';
        insert acc;
        
        Account acc2 = new Account();
        acc2.id=acc.id;
        acc2.ShippingPostalCode='43295';
        acc2.OEM__c ='Chrysler;Chrysler;Honda;Jeep;Bentley';
        update acc2;
        
    }
     @isTest static void updateDMA4(){
        
        Account acc = new Account();
        acc.name='hi';
        acc.ShippingPostalCode='54329';
        insert acc;
     }
     @isTest static void updateDMA5(){
        
        Account acc = new Account();
        acc.name='hi';
        acc.ShippingPostalCode='529';
        insert acc;
     }
}