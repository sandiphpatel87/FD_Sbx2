trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert, after insert) 
{
    //Before Insert ContentDocumentLink record.
	If(Trigger.isBefore && Trigger.isInsert)
    {
        Th_ContentDocumentLinkTrigger.onBeforeInsert(Trigger.New);
    }
    
    //After Insert ContentDocumentLink record.
	If(Trigger.isAfter && Trigger.isInsert)
    {
        Th_ContentDocumentLinkTrigger.onAfterInsert(Trigger.New);
    }
}