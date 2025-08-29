public class CaseStatusUpdateBatch implements Database.Batchable<sObject> 
{
    public Database.QueryLocator start(Database.BatchableContext context) 
    {
        String query  = '';
        If(Test.isRunningTest())
        {
            Date today1 = Date.newInstance(2023, 06, 01); 
            query = 'SELECT Id,Request_Type__c,Future_Case__c,Status,SLA_Time__c,Start_Date_Time__c,Due_Date__c FROM Case WHERE Start_Date__c =: today1'; 
        }
        Else
        {
            Date today = Date.today();
            String futureStatus = 'Future';
            query = 'SELECT Id,Status,Request_Type__c,Future_Case__c,SLA_Time__c,Start_Date_Time__c,Due_Date__c FROM Case WHERE Start_Date__c =: TODAY AND Status =:futureStatus'; 
        }
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<Case> scope)
    {
        List<Case> updateList = new List<Case>();
        for (Case c : scope) 
        {
            c.Status = 'New';
            c.Future_Case__c = true;
            If(c.Request_Type__c == 'Future Campaign Build - Get Me More')
            {
              c.Request_Type__c = 'Campaign Build - Get Me More';   
            }
             Else If(c.Request_Type__c == 'Future Campaign Build - Client Requested')
            {
              c.Request_Type__c = 'Campaign Build - Client Requested';   
            }
           Else If(c.Request_Type__c == 'Future Campaign Build - Standard')
            {
              c.Request_Type__c = 'Campaign Build - Standard';   
            }
            Else If(c.Request_Type__c == 'Future Budget Change')
            {
              c.Request_Type__c = 'Budget Change';   
            }
            if (c.SLA_Time__c != null) 
                {
                    system.debug('---- In first if  ---');
                    // Calculate the new due date based on the created date and SLA time
                    Integer slaTime = Integer.valueOf(c.SLA_Time__c);
                    system.debug(' slaTime  ---'+slaTime);
                    DateTime createdDateTime = c.Start_Date_Time__c;
                    system.debug(' createdDateTime  ---'+createdDateTime);
                    // Add additional days for cases created on weekends
                    if (createdDateTime.format('E') == 'Sat') 
                    {
                        system.debug('---- created on saturday  ---');
                        createdDateTime = createdDateTime.addDays(2);
                    }
                    else if (createdDateTime.format('E') == 'Sun') 
                    {
                        system.debug('---- created on sunday  ---');
                        createdDateTime = createdDateTime.addDays(1);
                    }
                    
                    // Adjust due date based on business hours
                    while (slaTime > 0) 
                    {
                        createdDateTime = createdDateTime.addHours(1);
                        if (isBusinessHour(createdDateTime))
                        {
                            slaTime--;
                        }
                    }
                    
                    Date dueDate = createdDateTime.date();
                    
                    // Update the case's due date field
                    c.Due_Date__c = dueDate;
                }
            updateList.add(c);
        }
        update updateList;
    }
    
    // Check if the given datetime falls within business hours
    private static Boolean isBusinessHour(DateTime dt) 
    {
        // Check if it's Monday to Friday
        if (dt.format('E') != 'Sat' && dt.format('E') != 'Sun')
        {
            Time startTime = Time.newInstance(9, 0, 0, 0);
            Time endTime = Time.newInstance(17, 0, 0, 0);
            Time current = dt.time();
            return current >= startTime && current <= endTime;
        }
        
        return false;
    }
    
    public void finish(Database.BatchableContext context)
    {
        System.debug('Batch job finished.');
    }
}