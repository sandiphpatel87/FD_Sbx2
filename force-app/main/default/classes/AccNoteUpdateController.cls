public class AccNoteUpdateController {
    @AuraEnabled
    public static Account getEntity(String recordId){
        Account acc = new Account();
        
        if(recordId != null) {
            acc = [select id,Notes__c from Account where id =: recordId ];
        }
        return acc;
    }
    @AuraEnabled
    public static Account saveData(String recordId, string Note){
        Account acc = new Account();
        acc.Notes__c = Note;
        acc.Id = recordId;
        update acc;
        return acc;
    }
}