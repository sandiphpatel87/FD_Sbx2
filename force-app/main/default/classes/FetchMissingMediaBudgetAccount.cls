public class FetchMissingMediaBudgetAccount {
 @AuraEnabled
    public static List <Account> fetchAccount() {
        String SobjectApiName = 'Account';      
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset()){
            if(commaSepratedFields == null || commaSepratedFields == ''){
                commaSepratedFields = fieldName;
            }else{
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }
        
        String query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Active__c = true and Exclude_for_Media_Budget_Email__c = false and Name Not In(\'Paragon Honda\',\'Teddy Nissan\',\'Teddy Volkswagen\',\'Test\') and  Id In (Select AccountId from AccountContactRelation) and  Id not In (Select AccountId from AccountContactRelation where Roles includes(\'Media Budget Decision Maker\') )'; 
        System.debug('======$$$$'+query );
        
        List <Account> accountList = Database.query(query);
        System.debug('======'+accountList);
       return accountList;
    }
}