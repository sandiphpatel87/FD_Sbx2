global class AdvertisedPayment implements Database.Batchable<sObject>, Schedulable {
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'select id,name,OwnerId,Account__c,Regional_performance_manager__r.Email,Actual_Google_Launch_Date__c, Advertised_Payments_Ready_to_Send__c,Geos_Ready_To_Send__c,Geos_Received__c,Proposed_Budgets_Sent__c,Advertised_Payments_Approved__c,Complete_Kickoff_Call__c,Differentiators_Verified_in_DigAd__c,Active__c from Onboarding__c where Active__c =True ' ;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Onboarding__c> scope){
        for(Onboarding__c ta : (List<Onboarding__c>)scope) {
            
            
            string age;
            string dob;
            string age2;
            string age3;
            string age4;
            string age5;
            string age12;
            string age11;
            string age13;
            string age15;
            string age16;
            string test1;
            string test11;
            string test111;
            string test112;
            string test123;
            string test1234;
//2.Advertised Payments Sent (FIELD NAME) - FALSE         
            if( ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Advertised_Payments_Ready_to_Send__c!=null && ta.Advertised_Payments_Approved__c==null){
                
                EmailTemplate emailTemplate1 = [select Id, Body from EmailTemplate where DeveloperName = 'Every_1_Day_after_the_Advertised_Payments_Sent_Date'];
                
                Messaging.SingleEmailMessage email1 = new Messaging.SingleEmailMessage();
                email1.setToAddresses(new String[] {ta.Regional_performance_manager__r.Email});
                email1.setSaveAsActivity(false);
                email1.setTargetObjectId(ta.OwnerId);
                email1.setTemplateId(emailTemplate1.Id);
                //email1.setWhatId(ta.Id);
                Messaging.SingleEmailMessage[] messages1 =  new List<Messaging.SingleEmailMessage> {email1};
                    Messaging.SendEmailResult[] results1 = Messaging.sendEmail(messages1); 
                
                
                
                
                if(results1[0].success) {
                    System.debug('The email was sent successfully');                       
                }                   
                else {
                    System.debug('The email failed to send');
                }
                break;  
            } 
            
            
            string age21;
            string dob22;
            string age232;
            string age243;
            string age24;
            string age25;
            string age212;
            string age211;
            string age213;
            string age215;
            string age216;
            string test31;
            string test331;
            string test231;
            string test341;
            string test351;
            string test361;
            string test371;
            
            if((ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Advertised_Payments_Ready_to_Send__c!=null && ta.Advertised_Payments_Approved__c!=null){
                system.debug('Condition not met');
            }   
            
            
// 5.Differentiators Verified in DigAd (FIELD NAME) - FALSE
            string name71;  
            string name712;  
            string name713;  
            string name714;  
            string name715;  
            string name716;  
            string name717;  
            string name719;  
            string name718;  
            string name710;  
            string name7112;  
            
            
            if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Complete_Kickoff_Call__c!=null && ta.Differentiators_Verified_in_DigAd__c==null){
                
                EmailTemplate emailTemplate2 = [select Id, Body from EmailTemplate where DeveloperName = 'Every_1_day_after_Differentiators_Verified_in_DigAd_is_false'];
                
                Messaging.SingleEmailMessage email2 = new Messaging.SingleEmailMessage();
                email2.setToAddresses(new String[] {ta.Regional_performance_manager__r.Email});
                email2.setSaveAsActivity(false);
                email2.setTargetObjectId(ta.OwnerId);
                email2.setTemplateId(emailTemplate2.Id);
                // email2.setWhatId(ta.Id);
                Messaging.SingleEmailMessage[] messages2 =  new List<Messaging.SingleEmailMessage> {email2};
                    Messaging.SendEmailResult[] results2 = Messaging.sendEmail(messages2);          
                if(results2[0].success) {
                    System.debug('The email was sent successfully');                       
                }                   
                else {
                    System.debug('The email failed to send');
                }
                break;  
            } 
            
            string age321;
            string dob322;
            string age3232;
            string age3243;
            string age324;
            string age325;
            string age3212;
            string age3211;
            string age3213;
            string age3215;
            string age3216;
            string test14;
            string test144;
            string test1444;
            string test23;
            string test156;
            string test178;
            string test1789;
            string test189;
            
            if((ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Complete_Kickoff_Call__c!=null && ta.Differentiators_Verified_in_DigAd__c!=null){
                system.debug('Condition not met');
            }
            
// 6.Proposed Budgets Sent (FIELD NAME)
            
            string name61;  
            string name612;  
            string name613;  
            string name614;  
            string name615;  
            string name616;  
            string name617;  
            string name619;  
            string name618;  
            string name610;  
            string name6112;  
            if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Complete_Kickoff_Call__c!=null && ta.Proposed_Budgets_Sent__c==null ){
                
                EmailTemplate emailTemplate3 = [select Id, Body from EmailTemplate where DeveloperName = 'Every_1_Day_after_the_Complete_Kickoff_Call_Date'];
                
                Messaging.SingleEmailMessage email3 = new Messaging.SingleEmailMessage();
                email3.setToAddresses(new String[] {ta.Regional_performance_manager__r.Email});
                email3.setSaveAsActivity(false);
                email3.setTargetObjectId(ta.OwnerId);
                email3.setTemplateId(emailTemplate3.Id);
                //email3.setWhatId(ta.Id);
                Messaging.SingleEmailMessage[] messages3 =  new List<Messaging.SingleEmailMessage> {email3};
                    Messaging.SendEmailResult[] results3 = Messaging.sendEmail(messages3);          
                if(results3[0].success) {
                    System.debug('The email was sent successfully');                       
                }                   
                else {
                    System.debug('The email failed to send');
                }
                break;  
            } 
            
            
            
            string age421;
            string dob42;
            string age4232;
            string age4243;
            string age424;
            string age425;
            string age4212;
            string age4211;
            string age4213;
            string age4215;
            string age4216;
            string sample1;  
            string sample2; 
            string sample3; 
            string sample4; 
            string sample44; 
            
            if((ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Complete_Kickoff_Call__c!=null && ta.Proposed_Budgets_Sent__c!=null ){
                system.debug('Condition not met');
            }
            
            // 7.Budgets Dealer Approved (FIELD NAME) - FALSE            
            
            string name51;  
            string name512;  
            string name513;  
            string name514;  
            string name515;  
            string name516;  
            string name517;  
            string name519;  
            string name518;  
            string name510;  
            string name5112;  
            if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Proposed_Budgets_Sent__c==null ){
                
                EmailTemplate emailTemplate4 = [select Id, Body from EmailTemplate where DeveloperName = 'Every_1_Day_after_the_Proposed_Budgets_Sent_Date'];
                
                Messaging.SingleEmailMessage email4 = new Messaging.SingleEmailMessage();
                email4.setToAddresses(new String[] {ta.Regional_performance_manager__r.Email});
                email4.setSaveAsActivity(false);
                email4.setTargetObjectId(ta.OwnerId);
                email4.setTemplateId(emailTemplate4.Id);
                //  email4.setWhatId(ta.Id);
                Messaging.SingleEmailMessage[] messages4 =  new List<Messaging.SingleEmailMessage> {email4};
                    Messaging.SendEmailResult[] results4 = Messaging.sendEmail(messages4);          
                if(results4[0].success) {
                    System.debug('The email was sent successfully');                       
                }                   
                else {
                    System.debug('The email failed to send');
                }
                break;  
            } 
            
            
            string age521;
            string dob522;
            string age5232;
            string age5243;
            string age524;
            string age525;
            string age5212;
            string age5211;
            string age5213;
            string age5215;
            string age5216;
            
            
            if((ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Proposed_Budgets_Sent__c!=null ){
                system.debug('Condition not met');
            }
            
 // 9.Geos Received (FIELD NAME) - FALSE  
            string name41;  
            string name412;  
            string name413;  
            string name414;  
            string name415;  
            string name416;  
            string name417;  
            string name419;  
            string name418;  
            string name410;  
            string name4112;  
            
            if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Geos_Received__c ==False && ta.Complete_Kickoff_Call__c!=null ){
                
                EmailTemplate emailTemplate5 = [select Id, Body from EmailTemplate where DeveloperName = 'Geos_Every_1_Day_after_the_Complete_Kickoff_Call_Date'];
                
                Messaging.SingleEmailMessage email5 = new Messaging.SingleEmailMessage();
                email5.setToAddresses(new String[] {ta.Regional_performance_manager__r.Email});
                email5.setSaveAsActivity(false);
                email5.setTargetObjectId(ta.OwnerId);
                email5.setTemplateId(emailTemplate5.Id);
                // email5.setWhatId(ta.Id);
                Messaging.SingleEmailMessage[] messages5 =  new List<Messaging.SingleEmailMessage> {email5};
                    Messaging.SendEmailResult[] results5 = Messaging.sendEmail(messages5);          
                if(results5[0].success) {
                    System.debug('The email was sent successfully');                       
                }                   
                else {
                    System.debug('The email failed to send');
                }
                break;  
            } 
            
            
            
            string age3345;
            string dob3445;
            string age32;
            string age33;
            string age34;
            string age35;
            string age312;
            string age311;
            string age313;
            string age315;
            string age316;
            string name21;  
            string name212;  
            string name213;  
            string name214;  
            string name215;  
            string name216;  
            string name217;  
            string name219;  
            string name218;  
            string name210;  
            string name2112;  
            
            
            
            if((ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today()) && ta.Geos_Received__c ==True && ta.Complete_Kickoff_Call__c!=null ){
                system.debug('Condition not met');
            }
            
 //10.Geos Received (FIELD NAME) - TRUE
            
            string name31;  
            string name312;  
            string name313;  
            string name314;  
            string name315;  
            string name316;  
            string name317;  
            string name319;  
            string name318;  
            string name310;  
            string name33112;  
            if(ta.Regional_performance_manager__r.Email!=null && (ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today())  && ta.Geos_Ready_To_Send__c ==null && ta.Geos_Received__c ==True && ta.Complete_Kickoff_Call__c!=null ){
                
                EmailTemplate emailTemplate6 = [select Id, Body from EmailTemplate where DeveloperName = 'Every_1_Day_after_the_Geos_Received_is_true'];
                
                
                
                
                Messaging.SingleEmailMessage email6 = new Messaging.SingleEmailMessage();
                email6.setToAddresses(new String[] {ta.Regional_performance_manager__r.Email});
                email6.setSaveAsActivity(false);
                email6.setTargetObjectId(ta.OwnerId);
                email6.setTemplateId(emailTemplate6.Id);
                // email6.setWhatId(ta.Id);
                Messaging.SingleEmailMessage[] messages6 =  new List<Messaging.SingleEmailMessage> {email6};
                    Messaging.SendEmailResult[] results6 = Messaging.sendEmail(messages6);          
                if(results6[0].success) {
                    System.debug('The email was sent successfully');                       
                }                   
                else {
                    System.debug('The email failed to send');
                }  
                break;  
            } 
            
            
            string age47;
            string dob490;
            string age42;
            string age43;
            string age44;
            string age45;
            string age412;
            string age411;
            string age4413;
            string age415;
            string age416;
            string name1;  
            string name12;  
            string name13;  
            string name14;  
            string name15;  
            string name16;  
            string name17;  
            string name19;  
            string name18;  
            string name10;  
            string name112;     
            
            if((ta.Actual_Google_Launch_Date__c== null || ta.Actual_Google_Launch_Date__c >=system.today())  && ta.Geos_Ready_To_Send__c !=null && ta.Geos_Received__c ==True && ta.Complete_Kickoff_Call__c!=null ){
                system.debug('Condition not met');
            }
            
            
        }       
        
    }     
    
    global void finish(Database.BatchableContext BC){
        
        system.debug('Finish Called');
    }
    
    global void execute(SchedulableContext sc) {
        AdvertisedPayment batch = new AdvertisedPayment(); 
        database.executebatch(batch);
        
    } 
}