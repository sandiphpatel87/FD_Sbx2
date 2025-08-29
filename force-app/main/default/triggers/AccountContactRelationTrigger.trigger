trigger AccountContactRelationTrigger on AccountContactRelation (before insert,After Insert,before update,After delete,After update)
{
    if(Trigger.isBefore && Trigger.isInsert)
    {
        AccountContactRelationTriggerHelper.onBeforeInsert(Trigger.New, Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isInsert)
    {
        AccountContactRelationTriggerHelper.onAfterInsert(Trigger.New);
    }
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        AccountContactRelationTriggerHelper.onBeforeUpdate(Trigger.New, Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isUpdate)
    {
         AccountContactRelationTriggerHelper.onAfterUpdate(Trigger.New,Trigger.newMap, Trigger.oldMap);
    }
    if(Trigger.isAfter && trigger.isdelete){
        AccountContactRelationTriggerHelper.onAfterDelete(Trigger.Old);
    }
}