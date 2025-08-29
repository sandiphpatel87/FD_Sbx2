@istest
global class AdvertisedPayment_Batch_test {
    
    @isTest global static void test(){
        
        user usr = [select id,UserRoleId, UserRole.Name,IsActive,email from user where UserRole.Name ='Regional Performance Manager' and IsActive =: true limit 1];
        system.debug(usr);

        Account acc = new Account();
        acc.Name = 'test';
        acc.Coop__c = true;
        acc.Active__c = true;
        acc.Rollback_Payments__c = true;
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'test1';
        acc1.Coop__c = true;
        acc1.Active__c = true;
        acc1.id=acc.id;
        update acc1;
        
         
        Onboarding__c onb =new Onboarding__c();
        onb.Account__c= acc.id;
        //onb.Opportunity__c=opp.id;
        onb.Actual_Google_Launch_Date__c=system.today()+1;
        onb.Regional_performance_manager__c=usr.id;
        onb.Advertised_Payments_Ready_to_Send__c=system.today()+1;
        insert onb;
       // onb.Advertised_Payments_Approved__c=system.today()+1;
       /* onb.Complete_Kickoff_Call__c=system.today()+1;
        onb.Differentiators_Verified_in_DigAd__c=system.today()+1;
        onb.Complete_Kickoff_Call__c=system.today()+1;
        onb.Proposed_Budgets_Sent__c=system.today()+1;
        onb.Geos_Received__c=True;
        onb.Geos_Ready_To_Send__c=system.today()+1;
      */  
        
        Onboarding__c onb1 =new Onboarding__c();
        onb1.Account__c= acc.id;
       // onb1.Opportunity__c=opp.id;
        onb1.Actual_Google_Launch_Date__c=system.today()+1;
        onb1.Regional_performance_manager__c=usr.id;
        onb1.Advertised_Payments_Ready_to_Send__c=system.today()+1;
        onb1.Advertised_Payments_Approved__c=system.today()+1;
        insert onb1;
        
      
          Onboarding__c onb5 =new Onboarding__c();
        onb5.Account__c= acc.id;
        onb5.Actual_Google_Launch_Date__c=system.today()+1;
        onb5.Regional_performance_manager__c=usr.id;
        onb5.Complete_Kickoff_Call__c=system.today()+1;
        // onb.Geos_Received__c=True;
        insert onb5;
        
        
          Onboarding__c onb6 =new Onboarding__c();
        onb6.Account__c= acc.id;
        onb6.Actual_Google_Launch_Date__c=system.today()+1;
        onb6.Regional_performance_manager__c=usr.id;
        onb6.Complete_Kickoff_Call__c=system.today()+1;
        onb6.Geos_Received__c=True;
        onb6.Geos_Ready_To_Send__c=system.today()+1;
        insert onb6;
        

        ScheduleEmail batch = new ScheduleEmail(); 
        database.executebatch(batch);
         string sch = '0 02 0 * * ?';
         String jobID = system.schedule('test', sch, batch);  

}
}