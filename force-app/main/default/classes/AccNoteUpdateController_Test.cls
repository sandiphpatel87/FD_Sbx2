@isTest
public class AccNoteUpdateController_Test {
@isTest
    public static void test(){
        Account acc = new Account();
        acc.Notes__c = 'Note';
        acc.Name ='test';
        
        insert acc;
        AccNoteUpdateController.getEntity(acc.Id);
        AccNoteUpdateController.saveData(acc.Id,acc.Notes__c );
    }
}