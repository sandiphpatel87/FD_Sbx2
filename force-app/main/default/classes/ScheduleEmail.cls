global class ScheduleEmail implements Database.Batchable<sObject>,Schedulable {
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'select id,name,OwnerId,Account__c,Regional_performance_manager__r.name,Regional_performance_manager__r.Email,Actual_Google_Launch_Date__c, Advertised_Payments_Ready_to_Send__c,Geos_Ready_To_Send__c,Geos_Received__c,Proposed_Budgets_Sent__c,Advertised_Payments_Approved__c,Complete_Kickoff_Call__c,Differentiators_Verified_in_DigAd__c,Active__c from Onboarding__c where Active__c =True ' ;
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Onboarding__c> scope){
        
        List<Onboarding__c> onblist = [select id,name,OwnerId,Account__c,Regional_performance_manager__r.name,Regional_performance_manager__r.Email,Actual_Google_Launch_Date__c, Advertised_Payments_Ready_to_Send__c,Geos_Ready_To_Send__c,Geos_Received__c,Proposed_Budgets_Sent__c,Advertised_Payments_Approved__c,Complete_Kickoff_Call__c,Differentiators_Verified_in_DigAd__c,Active__c from Onboarding__c where Active__c =:True];
        for(Onboarding__c ta :  onblist ){ 
            list<String> emailList = new list<String>();
            emailList=new List<String>();
            for(Onboarding__c op:onblist){
                emailList.add(op.Regional_performance_manager__r.Email);
            }
            Account acc =[Select id, name FROM Account where id=:ta.Account__c];  
            
               
            if( ta.Regional_performance_manager__r.Email!=null && ta.Advertised_Payments_Ready_to_Send__c!=null && ta.Advertised_Payments_Approved__c==null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today())){
                string plainTextBody ='';
                plainTextBody += 'Hi '+ ta.Regional_performance_manager__r.name+ ',' ;
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody +=  acc.name+ ' '+ 'has yet to approve the previously emailed advertised payment examples.';
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Please reach out to the appropriate point of contact for approval to not delay the account launch.' ;
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Make sure to update the RPM Checklist in Onboarding when completed.' ;
                plainTextBody += '\n';   
                plainTextBody += '\n';
                plainTextBody += 'Thank you,' ; 
                plainTextBody += '\n';    
                plainTextBody += 'Onboarding Team'; 
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setToAddresses(emailList);
                system.debug(ta.Regional_performance_manager__r.Email);
                message.subject = 'Advertised Payments Not Yet Approved For' +' ' +acc.name;                                       
                string body = plainTextBody;
                message.setPlainTextBody(body);
                Messaging.SingleEmailMessage[] messages =  new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);          
                if(results[0].success) {
                    System.debug('The email was sent successfully');  
                   
                }                   
                else {
                    System.debug('The email failed to send');
                }
                           
                
            }
        
            if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Advertised_Payments_Ready_to_Send__c!=null && ta.Advertised_Payments_Approved__c!=null){
                system.debug('Condition not met');
            }   
            
//5.Differentiators Verified in DigAd (FIELD NAME) - FALSE          
                       
            if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Complete_Kickoff_Call__c!=null && ta.Differentiators_Verified_in_DigAd__c==null){
                
                string plainTextBody ='';
                plainTextBody += 'Hi '+ ta.Regional_performance_manager__r.name+ ',' ;
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Kindly verify the dealer differentiators are accurate and loaded properly for'+' ' + acc.name  +' ' +' in DigAd.';
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Ensure to add or edit the differentiators to include any appropriate updates from the Kick Off Call.' ;
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Please update the RPM Checklist in Onboarding when completed.' ;
                plainTextBody += '\n';  
                plainTextBody += '\n';
                plainTextBody += 'Thank you,' ; 
                plainTextBody += '\n';    
                plainTextBody += 'Onboarding Team'; 
                Messaging.SingleEmailMessage message1 = new Messaging.SingleEmailMessage();
                message1.setToAddresses(emailList);
                system.debug(ta.Regional_performance_manager__r.Email);
                message1.subject = 'Verify Dealer Differentiators For' +' ' +acc.name;                                       
                string body = plainTextBody;
                message1.setPlainTextBody(body);
                Messaging.SingleEmailMessage[] messages1 =  new List<Messaging.SingleEmailMessage> {message1};
                    Messaging.SendEmailResult[] results1 = Messaging.sendEmail(messages1);          
              if(results1[0].success) {
                    System.debug('The email was sent successfully');  
                 
                }                   
                else {
                    System.debug('The email failed to send');
                }
              
            } 
              if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Complete_Kickoff_Call__c!=null && ta.Differentiators_Verified_in_DigAd__c!=null){
                system.debug('Condition not met');
            }
 //6.Proposed Budgets Sent (FIELD NAME)             
                        if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Complete_Kickoff_Call__c!=null && ta.Proposed_Budgets_Sent__c==null ){
                
                string plainTextBody ='';
                plainTextBody += 'Hi '+ ta.Regional_performance_manager__r.name+ ',' ;
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Please confirm proposed media budgets for'+' ' + acc.name  +' ' +'. This may have already been completed during the Kick Off Call. ';
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Kindly update the RPM Checklist in Onboarding.' ;
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Thank you,' ; 
                plainTextBody += '\n';    
                plainTextBody += 'Onboarding Team'; 
                Messaging.SingleEmailMessage message2 = new Messaging.SingleEmailMessage();
                message2.setToAddresses(emailList);
                system.debug(ta.Regional_performance_manager__r.Email);
                message2.subject = 'Send Proposed Budgets to' +' ' +acc.name;                                       
                string body = plainTextBody;
                message2.setPlainTextBody(body);
                Messaging.SingleEmailMessage[] messages2 =  new List<Messaging.SingleEmailMessage> {message2};
                    Messaging.SendEmailResult[] results2 = Messaging.sendEmail(messages2);          
           if(results2[0].success) {
                    System.debug('The email was sent successfully');  
              
                }                   
                else {
                    System.debug('The email failed to send');
                }
              
               
            } 
            
                
            
            if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Complete_Kickoff_Call__c!=null && ta.Proposed_Budgets_Sent__c!=null ){
                system.debug('Condition not met');
            }
            
 // 7.Budgets Dealer Approved (FIELD NAME) - FALSE            
            
            if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Proposed_Budgets_Sent__c==null ){
                
                string plainTextBody ='';
                plainTextBody += 'Hi '+ ta.Regional_performance_manager__r.name+ ',' ;
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Proposed media budgets for'+' ' + acc.name  +' ' +' have yet to be confirmed.';
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Please reach out to the appropriate point of contact for approval to not delay the account launch.' ;
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Kindly update the RPM Checklist in Onboarding when completed.' ;
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Thank you,' ; 
                plainTextBody += '\n';    
                plainTextBody += 'Onboarding Team'; 
                Messaging.SingleEmailMessage message3 = new Messaging.SingleEmailMessage();
                message3.setToAddresses(emailList);
                system.debug(ta.Regional_performance_manager__r.Email);
                message3.subject = 'Budgets Still Not Approved For' +' ' +acc.name;                                       
                string body = plainTextBody;
                message3.setPlainTextBody(body);
                Messaging.SingleEmailMessage[] messages3 =  new List<Messaging.SingleEmailMessage> {message3};
                    Messaging.SendEmailResult[] results3 = Messaging.sendEmail(messages3);          
              if(results3[0].success) {
                    System.debug('The email was sent successfully');  
                 
                }                   
                else {
                    System.debug('The email failed to send');
                }
                
                
            }  
         
                   
            if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Proposed_Budgets_Sent__c!=null ){
                system.debug('Condition not met');
            }
            
 // 9.Geos Received (FIELD NAME) - FALSE  
                     
            
            if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Geos_Received__c ==False && ta.Complete_Kickoff_Call__c!=null ){
                
                string plainTextBody ='';
                plainTextBody += 'Hi '+ ta.Regional_performance_manager__r.name+ ',' ;
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += acc.name+ ' '+  'has not provided their desired geotargets yet. These may have already been discussed during the Kick Off Call.';
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Please reach out to the appropriate point of contact to acquire these or we will launch with the default 15 mile radius around the dealership.' ;
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Kindly update the RPM Checklist in Onboarding when completed.' ;
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Thank you,' ; 
                plainTextBody += '\n';    
                plainTextBody += 'Onboarding Team'; 
                Messaging.SingleEmailMessage message4 = new Messaging.SingleEmailMessage();
                message4.setToAddresses(emailList);
                system.debug(ta.Regional_performance_manager__r.Email);
                message4.subject = 'Geotargets Not Received For' +' ' +acc.name;                                       
                string body = plainTextBody;
                message4.setPlainTextBody(body);
                Messaging.SingleEmailMessage[] messages4 =  new List<Messaging.SingleEmailMessage> {message4};
                    Messaging.SendEmailResult[] results4 = Messaging.sendEmail(messages4);          
          if(results4[0].success) {
                    System.debug('The email was sent successfully');    
              
                }                   
                else {
                    System.debug('The email failed to send');
                }
           

            }  
            
            
               
            if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Geos_Received__c ==True && ta.Complete_Kickoff_Call__c!=null ){
                system.debug('Condition not met');
            }
            
  //10.Geos Received (FIELD NAME) - TRUE
                     
            if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today())  && ta.Geos_Ready_To_Send__c ==null && ta.Geos_Received__c ==True && ta.Complete_Kickoff_Call__c!=null ){
            
                
                string plainTextBody ='';
                plainTextBody += 'Hi '+ ta.Regional_performance_manager__r.name+ ',' ;
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += acc.name+ ' '+ 'has provided their desired geotargets. Please build out geotarget maps in DigAd and provide screenshots back to the dealer for approval.';
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Please update the RPM Checklist in Onboarding when completed.' ;
                plainTextBody += '\n';
                plainTextBody += '\n';
                plainTextBody += 'Thank you,' ; 
                plainTextBody += '\n';    
                plainTextBody += 'Onboarding Team'; 
                Messaging.SingleEmailMessage message5 = new Messaging.SingleEmailMessage();
                message5.setToAddresses(emailList);
                system.debug(ta.Regional_performance_manager__r.Email);
                message5.subject = 'Build Geotargets in DigAd For' +' ' +acc.name;                                       
                string body = plainTextBody;
                message5.setPlainTextBody(body);
                Messaging.SingleEmailMessage[] messages5 =  new List<Messaging.SingleEmailMessage> {message5};
                    Messaging.SendEmailResult[] results5 = Messaging.sendEmail(messages5);          
               if(results5[0].success) {
                    System.debug('The email was sent successfully');
                  
                }                   
                else {
                    System.debug('The email failed to send');
                   
                }
      
                 
            }
                   if((ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today())  && ta.Geos_Ready_To_Send__c !=null && ta.Geos_Received__c ==True && ta.Complete_Kickoff_Call__c!=null ){
                system.debug('Condition not met');
                        
            }
            
           
        }  
    }     
    global void finish(Database.BatchableContext BC){
        system.debug('Finish Called');
    }
    global void execute(SchedulableContext sc) {
        ScheduleEmail batch = new ScheduleEmail(); 
        database.executebatch(batch);
        //string sch = '0 02 0 * * ?';
        //String jobID = system.schedule('test', sch, batch);
    }
        
}