global class UpdateUserOOOBatch implements Database.Batchable<sObject>, Database.Stateful {
    global Set<Id> ownerIds = new Set<Id>();

    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date today = Date.today();
        return Database.getQueryLocator([
            SELECT OwnerId
            FROM OOO_Calendar__c
            WHERE Start_Date__c <= :today
            AND End_Date__c >= :today
        ]);
    }

    global void execute(Database.BatchableContext bc, List<OOO_Calendar__c> records) {
        for (OOO_Calendar__c ooo : records) {
            ownerIds.add(ooo.OwnerId);
        }
    }

    global void finish(Database.BatchableContext bc) {
        List<User> updateList = new List<User>();
        
        // Set OOO__c to true for users with active OOO calendars
        for (Id userId : ownerIds) {
            updateList.add(new User(Id = userId, OOO__c = true));
        }
        
        // Set OOO__c to false for users without active calendars but currently marked OOO
        List<User> usersToUncheck = [
            SELECT Id
            FROM User
            WHERE OOO__c = true
            AND Id NOT IN :ownerIds
        ];
        
        for (User u : usersToUncheck) {
            updateList.add(new User(Id = u.Id, OOO__c = false));
        }
        
        if (!updateList.isEmpty()) {
            update updateList;
        }
    }
}