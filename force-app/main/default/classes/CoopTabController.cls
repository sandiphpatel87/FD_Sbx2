public class CoopTabController {
    @AuraEnabled
    public static wrapperClass getCoopCheckbox(String coopId){
        map<string,string> mapOfCheckboxField = new map<String,string>();
        map<string,Boolean> mapOfWCoopField = new map<String,Boolean>();
        wrapperClass returnwrapperClass = new  wrapperClass (); 
        DescribeSObjectResult describeResult = Coop__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        DescribeSObjectResult wCoopDescribeResult = Working_Coop__c.getSObjectType().getDescribe(); 
        List<String> wCoopFieldNames = new List<String>( wCoopDescribeResult.fields.getMap().keySet() );
        
        String query =    ' SELECT '+String.join( fieldNames, ',') +' FROM Coop__c where id =: coopId';
        Coop__c obj =   Database.query( query );
        
        String queryWCoop =' SELECT '+String.join( wCoopFieldNames, ',') +' FROM Working_Coop__c where Coop__c =: coopId limit 1';
        
        Working_Coop__c[] objWCoop =   Database.query( queryWCoop );
        
        
        Map<String, Schema.SObjectField> fieldMap = Coop__c.getSObjectType().getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()) {
            System.debug('==fieldName=='+fieldName);
            //get all the fields label for Account Object
            String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
            //get data types for each fields
            Schema.DisplayType fieldDataType = fieldMap.get(fieldName).getDescribe().getType();
            if(fieldDataType == Schema.DisplayType.BOOLEAN && obj.get(fieldName) == true ) {
                // obj.put(fieldName, false);
                mapOfCheckboxField.put(fieldLabel,fieldName);
                if(objWCoop != null && objWCoop.size() >0){
                    if(objWCoop[0].get(fieldName) == true){
                        mapOfWCoopField.put(fieldLabel,true);
                        objWCoop[0].put(fieldName, true);
                    }
                    else{
                        mapOfWCoopField.put(fieldLabel,false);
                        objWCoop[0].put(fieldName, false);
                    }
                }
            }
        }
        returnwrapperClass.mapOfApiName = CoopEditController.getMap();// edit class metho
        returnwrapperClass.mapOfField = mapOfCheckboxField;
        if(objWCoop != null && !objWCoop.isEmpty() ){
            returnwrapperClass.wCoopObj = objWCoop[0];
        }
        else{
            Working_Coop__c wCoop = new Working_Coop__c();
            wCoop.Coop__c = coopId;
            returnwrapperClass.wCoopObj = wCoop;
        }
        returnwrapperClass.mapSize = mapOfCheckboxField.size();
        returnwrapperClass.mapOfWCoop = mapOfWCoopField;
        returnwrapperClass.mapOfWCoopSize = mapOfWCoopField.size();
        return returnwrapperClass;   
    }
     @AuraEnabled 
    public static Working_Coop__c saveCoop(Working_Coop__c coopObj,Map<String, Object> wCoop){
        system.debug('==========FD_Tech_Invoice__c===='+coopObj.FD_Tech_Invoice__c);
        system.debug('==========wCoop===='+wCoop);
       
        Boolean isCloseTask ;
        if(wCoop.size() >0){
            isCloseTask = true;
            for(string key :wCoop.keySet()){
                if(wCoop.get(key) == false){
                    system.debug('==========key===='+key);
                    isCloseTask = false;
                    system.debug('==========isCloseTask===='+isCloseTask);
                    break;
                }
            }
        }
        try{
            upsert coopObj;
            if(isCloseTask == true){
                Coop__c objCoop = [select id,Account__c,Month__c from Coop__c where Id =: coopObj.Coop__c limit 1];
                Integer month = getPreviousMonth(objCoop.Month__c);
                if(month == 12){
                  month = 0;  
                }
                List<Task> tskList = [select id,status from task where whatId =: objCoop.Account__c and subject =:'Coop' and CALENDAR_MONTH(CreatedDate) =: (month+1) ];
                system.debug('=tskList===='+tskList);
                if(tskList != null && !tskList.isEmpty()){
                    for(Task tskObj : tskList){
                        tskObj.status = 'Completed';
                    }
                    update tskList;
                }
            }
        }
        catch(Exception e){
            throw new AuraHandledException('Something went wrong: '
                                           + e.getMessage()); 
        }
        system.debug('=============='+coopObj.Id); 
        return coopObj;
    }
    public static Integer getPreviousMonth(String dateVal){
        Integer month;
        switch on dateVal {
            when 'Jan' {
                month = 1;
            }
            when 'Feb' {
                month  = 2; 
            }
            when 'Mar' {
                month  = 3;
            }
            when 'Apr' {
                month  = 4;
            }
            when 'May' {
                month = 5 ;
            }
            when 'Jun' {
                month = 6 ;
            }
            when 'Jul' {
                month = 7;
            }
            when 'Aug' {
                month = 8;
            }
            when 'Sep' {
                month  = 9; 
            }
            when 'Oct' {
                month  = 10; 
            }
            when 'Nov' {
                month = 11; 
            }
            when 'Dec' {
                month = 12 ;
            }
        }
        return month;
    }
    public class wrapperClass{
        @AuraEnabled public Working_Coop__c wCoopObj{get;set;}
        @AuraEnabled public map<String,String> mapOfField{get;set;}
        @AuraEnabled public map<String,String> mapOfApiName{get;set;}
        @AuraEnabled public Integer mapSize{get;set;}
        @AuraEnabled public map<String,Boolean> mapOfWCoop{get;set;}
         @AuraEnabled public Integer mapOfWCoopSize{get;set;}
    }
    
}