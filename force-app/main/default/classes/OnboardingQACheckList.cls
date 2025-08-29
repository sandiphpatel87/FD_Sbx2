public class OnboardingQACheckList {
    @AuraEnabled
    public static Onboarding__c getCheckbox(String onboardingId){
        map<string,string> mapOfCheckboxField = new map<String,string>();
        map<string,Boolean> mapOfWCoopField = new map<String,Boolean>();
        DescribeSObjectResult describeResult = Onboarding__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query =    ' SELECT '+String.join( fieldNames, ',') +' FROM Onboarding__c where id =: onboardingId';
        Onboarding__c obj =   Database.query( query );
        return obj;   
    }
    @AuraEnabled 
    public static Onboarding__c saveOnboarding(Onboarding__c onboardingRecord,Boolean checkedVal,string tab){
        update onboardingRecord;
        if(checkedVal == true && tab =='Launch Day QA'){
            list<Task> tskList = [select id,Status from Task where subject =:'Launch Day QA' and whatId =: onboardingRecord.Account__c];
            if(tskList != null && !tskList.isEmpty()){
                for(Task obj: tskList){
                    obj.Status = 'Completed';
                }
                update tskList;
            }
        }
        else if(checkedVal == true && tab =='7 day launch QA'){
            list<Task> tskList = [select id,Status from Task where subject =:'7 day launch QA' and whatId =: onboardingRecord.Account__c];
            if(tskList != null && !tskList.isEmpty()){
                for(Task obj: tskList){
                    obj.Status = 'Completed';
                }
                update tskList;
            }
        }
        else if(checkedVal == true && tab =='14 day Launch QA'){
            list<Task> tskList = [select id,Status from Task where subject =:'14 Day Launch QA' and whatId =: onboardingRecord.Account__c];
            if(tskList != null && !tskList.isEmpty()){
                for(Task obj: tskList){
                    obj.Status = 'Completed';
                }
                update tskList;
            }
        }
        else if(checkedVal == true && tab =='Performance Max'){
            list<Task> tskList = [select id,Status from Task where subject =:'Performance Max' and whatId =: onboardingRecord.Account__c];
            if(tskList != null && !tskList.isEmpty()){
                for(Task obj: tskList){
                    obj.Status = 'Completed';
                }
                update tskList;
            }
        }
        return onboardingRecord;
    }
 
   
    
}