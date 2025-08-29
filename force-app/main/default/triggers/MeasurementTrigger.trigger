trigger MeasurementTrigger on Measurement__c (after update) 
{
	If(Trigger.isAfter && Trigger.isUpdate)
    {
        Th_MeasurementTrigger.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }
}