trigger AttachmentTrigger on Attachment (before insert, after insert, after delete,after undelete) {

    if(Trigger.isAfter && Trigger.isInsert)
    {
        System.debug('Running..............................');
        AttachmentTriggerHelper.onAfterInsert(Trigger.New);
    }
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isDelete || Trigger.isUndelete))
    {
        AttachmentTriggerHelper.onAfterInsertAndDelete(Trigger.New);
    }
}