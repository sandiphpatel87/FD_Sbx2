trigger OpportunityTrigger on Opportunity (Before Update, After update,after insert) 
{
    If(Trigger.IsAfter && Trigger.IsInsert)
    {
            OpportunityTriggerHelper.onAfterInsert(Trigger.New);
    }
    If(Trigger.IsBefore && Trigger.IsUpdate)
    {
            OpportunityTriggerHelper.onBeforeUpdate(Trigger.New, Trigger.oldMap);
    }
    
    If(Trigger.IsAfter && Trigger.IsUpdate)
    {
        //if(OpportunityTriggerHelper.isFirstTime){
            //OpportunityTriggerHelper.isFirstTime = false;
            OpportunityTriggerHelper.onAfterUpdateSendEmail(Trigger.New, Trigger.oldMap);
            OpportunityTriggerHelper.onAfterUpdate(Trigger.New, Trigger.oldMap);
        //}
    }
}