global class MediaBudgetLoadedBatch implements Database.Batchable<sObject>,Database.Stateful,schedulable {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string query =  'select name,Budget_Email_Task__c,Event_Reminder__c,Task_for_AT__c from Media_Budgets_Loaded1__c';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Media_Budgets_Loaded1__c> scope) {
        list<Event> eventList = new list<Event>();
        list<Task> taskList = new list<Task>();
        DateTime dT = System.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        
        list<User> userList =[select id from user where UserRole.Name = 'Account Technician' and IsActive = true];
        System.debug('==userList==='+userList);
        
        System.debug('==to==='+myDate);
        for(Media_Budgets_Loaded1__c obj :scope){
            Date reminderDate;
            if( obj.Event_Reminder__c != null){
                DateTime reminder = obj.Event_Reminder__c;
                reminderDate = date.newinstance(reminder.year(), reminder.month(), reminder.day());
            }
            for(User user :userList){
                System.debug('==rem==='+reminderDate);
                System.debug('==Task At==='+obj.Task_for_AT__c);
                System.debug('==buget==='+obj.Budget_Email_Task__c);
                if(myDate == reminderDate){
                    System.debug('====='+obj.Event_Reminder__c);
                    Event evn = new Event();
                    evn.Subject = obj.Name;
                    evn.IsReminderSet = true;
                    evn.ReminderDateTime = obj.Event_Reminder__c;
                    evn.OwnerId = user.Id;
                    evn.DurationInMinutes = 60;
                    evn.StartDateTime = obj.Event_Reminder__c;
                    evn.EndDateTime  = datetime.valueOf(obj.Event_Reminder__c).addHours(1);
                    eventList.add(evn);
                    System.debug('==Task At==='+obj.Task_for_AT__c);
                    Task tsk = new Task();
                    tsk.Subject = obj.Name;
                    tsk.Priority = 'Normal';
                    tsk.ActivityDate = obj.Task_for_AT__c;
                    tsk.Status = 'Open';
                    tsk.OwnerId = user.Id;
                    taskList.add(tsk);
                    //return;
                }
            }
            System.debug('==buget==='+obj.Budget_Email_Task__c);
            if(myDate == obj.Budget_Email_Task__c){
                System.debug('==buget==='+obj.Budget_Email_Task__c);
                Task tsk1 = new Task();
                tsk1.Subject = obj.Name;
                tsk1.Priority = 'Normal';
                tsk1.ActivityDate = obj.Budget_Email_Task__c;
                tsk1.Status = 'Open';
                tsk1.OwnerId = '0054W00000DIZI5QAP';
                taskList.add(tsk1);
                // return;
            }
        }
        System.debug('===eventList=='+eventList);
        if(!taskList.isEmpty() && taskList != null){
            insert taskList;
        }
        if(!eventList.isEmpty() && eventList != null){
            insert eventList;
        }
    }
    global void finish(Database.BatchableContext BC)
    {
    }
    global void execute(SchedulableContext sc)
    {
        MediaBudgetLoadedBatch b = new MediaBudgetLoadedBatch(); //ur batch class
        database.executebatch(b);
    }
}