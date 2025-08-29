public class FetchMissingAccount
{
    @AuraEnabled
    public static List <Account> fetchAccount()
    {
        String SobjectApiName = 'Account';      
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        //List<String> typeFilter = new List<String>{'NCM','Business Intelligence'};
            //Dealer Group,Digital Advertising,NCM 20 Group,Partner
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset())
        {
            if(commaSepratedFields == null || commaSepratedFields == '')
            {
                commaSepratedFields = fieldName;
            }
            else
            {
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }
        //Added filter for type NCM in below Query
        //String query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Active__c = true and (Type__c not in (\''+typeFilter[0]+'\'' +') OR Type__c not in (\''+typeFilter[1]+'\'' +')) and Exclude_for_Media_Budget_Email__c = false and Name Not In(\'Paragon Honda\',\'Teddy Nissan\',\'Teddy Volkswagen\',\'Test\') and  Id In (Select AccountId from AccountContactRelation) and  Id not In (Select AccountId from AccountContactRelation where Roles includes(\'Media Budget Decision Maker\') )'; 
       String query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Active__c = true and Type__c INCLUDES(\'Dealer Group\',\'Digital Advertising\',\'NCM 20 Group\',\'Partner\') and Exclude_for_Media_Budget_Email__c = false and Name Not In(\'Paragon Honda\',\'Teddy Nissan\',\'Teddy Volkswagen\',\'Test\') and  Id In (Select AccountId from AccountContactRelation) and  Id not In (Select AccountId from AccountContactRelation where Roles includes(\'Media Budget Decision Maker\') )'; 
     
        
        System.debug('======$$$$'+query );
        
        List <Account> accountList = Database.query(query);
        System.debug('======'+accountList);
       return accountList;
    }
    
    @AuraEnabled
    public static List <Account> fetchAccountNoPrimary()
    {
        String SobjectApiName = 'Account';      
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List<String> typeFilter = new List<String>{'NCM','Business Intelligence'};
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset())
        {
            if(commaSepratedFields == null || commaSepratedFields == '')
            {
                commaSepratedFields = fieldName;
            }
            else
            {
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }
         //Added filter for type NCM in below Query
        String query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Active__c = true and Type__c INCLUDES(\'Dealer Group\',\'Digital Advertising\',\'NCM 20 Group\',\'Partner\') and Exclude_for_Media_Budget_Email__c = false and Name Not In(\'Paragon Honda\',\'Teddy Nissan\',\'Teddy Volkswagen\',\'Test\') and  Id In (Select AccountId from AccountContactRelation) and  Id not In (Select AccountId from AccountContactRelation where Roles includes(\'Primary Contact\') )'; 
        System.debug('======$$$$'+query );
        
        List <Account> accountList = Database.query(query);
        System.debug('======'+accountList);
       return accountList;
    }
    
    @AuraEnabled
    public static List <Account> fetchAccountNoSecondary()
    {
        String SobjectApiName = 'Account';      
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List<String> typeFilter = new List<String>{'NCM','Business Intelligence'};
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset())
        {
            if(commaSepratedFields == null || commaSepratedFields == '')
            {
                commaSepratedFields = fieldName;
            }
            else
            {
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }
         //Added filter for type NCM in below Query
        String query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Active__c = true and Type__c INCLUDES(\'Dealer Group\',\'Digital Advertising\',\'NCM 20 Group\',\'Partner\') and Exclude_for_Media_Budget_Email__c = false and Name Not In(\'Paragon Honda\',\'Teddy Nissan\',\'Teddy Volkswagen\',\'Test\') and  Id In (Select AccountId from AccountContactRelation) and  Id not In (Select AccountId from AccountContactRelation where Roles includes(\'Secondary contact\') )'; 
        System.debug('======$$$$'+query );
        
        List <Account> accountList = Database.query(query);
        System.debug('======'+accountList);
       return accountList;
    }
}