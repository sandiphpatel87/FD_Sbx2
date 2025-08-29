trigger CaseDueDateTrigger on Case (Before Insert, After Insert,Before update,After update) 
{    
    IF(Trigger.IsInsert && Trigger.IsBefore)
    {
        system.debug('Trigger run on case before Insert ');
        CalculateCaseDueDate.onBeforeInsert(Trigger.new);
    }
    IF(Trigger.IsInsert && Trigger.IsAfter)
    {
        system.debug('Trigger ran on case after insert');
        CalculateCaseDueDate.insertCases(trigger.new);
    }
    If(Trigger.IsUpdate && Trigger.IsBefore)
    {
        system.debug('Trigger ran on case before update');
        //CalculateCaseDueDate.calculateCaseDueDate(trigger.new,trigger.oldMap);
        CalculateCaseDueDate.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    IF(Trigger.IsUpdate && Trigger.IsAfter)
    {
        system.debug('Trigger ran on case after update ');
        CalculateCaseDueDate.afterUpdateCases(trigger.new,trigger.oldMap);
        Th_CaseTrigger.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }
}