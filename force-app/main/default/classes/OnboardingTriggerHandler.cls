public class OnboardingTriggerHandler {
    
    public static Boolean isFirstTime = true;
    
    public static void AfterUpdateOnboardingFieldOfSameAccount(List<Onboarding__c> oldRecords,List<Onboarding__c> newRecords, Map<Id,Onboarding__c> oldMapOnboarding, Map<Id,Onboarding__c> newMapOnboarding)
    {
        Map<ID,List<Onboarding__c>> onboardingMapWithSameAcc = new Map<ID,List<Onboarding__c>>();
        Map<Onboarding__c,List<Onboarding__c>> onboardingMapWithNewOnboardWithList = new Map<Onboarding__c,List<Onboarding__c>>();
        Set<ID> accIdSet = new Set<ID>();
        List<Onboarding__c> listToUpdate= new List<Onboarding__c>();
        
        for(Onboarding__c onboarding:newRecords){
            if(( newMapOnboarding.get(onboarding.Id).Auto_charge_monthly_fee__c != oldMapOnboarding.get(onboarding.Id).Auto_charge_monthly_fee__c )
               //||(newMapOnboarding.get(onboarding.Id).BI_Launch_Date__c != oldMapOnboarding.get(onboarding.Id).BI_Launch_Date__c )
               ||(newMapOnboarding.get(onboarding.Id).BigQuery_is_linked_in_GA4__c != oldMapOnboarding.get(onboarding.Id).BigQuery_is_linked_in_GA4__c )
               ||(newMapOnboarding.get(onboarding.Id).Chat_Provider__c != oldMapOnboarding.get(onboarding.Id).Chat_Provider__c )
               ||(newMapOnboarding.get(onboarding.Id).Chat_Start__c != oldMapOnboarding.get(onboarding.Id).Chat_Start__c )
               ||(newMapOnboarding.get(onboarding.Id).Click_to_Call__c != oldMapOnboarding.get(onboarding.Id).Click_to_Call__c )
               ||(newMapOnboarding.get(onboarding.Id).Custom_Definitions_Configurati__c != oldMapOnboarding.get(onboarding.Id).Custom_Definitions_Configurati__c )
               ||(newMapOnboarding.get(onboarding.Id).DR_Start__c != oldMapOnboarding.get(onboarding.Id).DR_Start__c )
               ||(newMapOnboarding.get(onboarding.Id).Dashboard_View_ID__c != oldMapOnboarding.get(onboarding.Id).Dashboard_View_ID__c )
               ||(newMapOnboarding.get(onboarding.Id).Data_Email_QA__c != oldMapOnboarding.get(onboarding.Id).Data_Email_QA__c )
               ||(newMapOnboarding.get(onboarding.Id).Foundation_GA4_View__c != oldMapOnboarding.get(onboarding.Id).Foundation_GA4_View__c )
               ||(newMapOnboarding.get(onboarding.Id).Foundation_View_ID__c != oldMapOnboarding.get(onboarding.Id).Foundation_View_ID__c )
               ||(newMapOnboarding.get(onboarding.Id).GA4_Measurement_ID__c != oldMapOnboarding.get(onboarding.Id).GA4_Measurement_ID__c )
               ||(newMapOnboarding.get(onboarding.Id).GA4_Notes__c != oldMapOnboarding.get(onboarding.Id).GA4_Notes__c )
               ||(newMapOnboarding.get(onboarding.Id).GA4_Property_Name_from_this_sheet__c != oldMapOnboarding.get(onboarding.Id).GA4_Property_Name_from_this_sheet__c )
               ||(newMapOnboarding.get(onboarding.Id).GA_Account_Shared__c != oldMapOnboarding.get(onboarding.Id).GA_Account_Shared__c )
               ||(newMapOnboarding.get(onboarding.Id).GTM_Container_Updated_for_GA4__c != oldMapOnboarding.get(onboarding.Id).GTM_Container_Updated_for_GA4__c )
               ||(newMapOnboarding.get(onboarding.Id).GTM_ID_provided__c != oldMapOnboarding.get(onboarding.Id).GTM_ID_provided__c )
               ||(newMapOnboarding.get(onboarding.Id).GTM_on_Site__c != oldMapOnboarding.get(onboarding.Id).GTM_on_Site__c )
               ||(newMapOnboarding.get(onboarding.Id).Goals_Inactive_at_Dashboard_Call__c != oldMapOnboarding.get(onboarding.Id).Goals_Inactive_at_Dashboard_Call__c )
               ||(newMapOnboarding.get(onboarding.Id).Google_Facebook_Pixel_script_added_to_GT__c != oldMapOnboarding.get(onboarding.Id).Google_Facebook_Pixel_script_added_to_GT__c )
               ||(newMapOnboarding.get(onboarding.Id).Inventory_Is_In__c != oldMapOnboarding.get(onboarding.Id).Inventory_Is_In__c )
               ||(newMapOnboarding.get(onboarding.Id).Inventory_Ordered_Date__c != oldMapOnboarding.get(onboarding.Id).Inventory_Ordered_Date__c )
               ||(newMapOnboarding.get(onboarding.Id).Lead_Form__c != oldMapOnboarding.get(onboarding.Id).Lead_Form__c )
               ||(newMapOnboarding.get(onboarding.Id).Mutual_Client_with_VistaDash__c != oldMapOnboarding.get(onboarding.Id).Mutual_Client_with_VistaDash__c )
               ||(newMapOnboarding.get(onboarding.Id).Non_Standard_Setup_Notes__c != oldMapOnboarding.get(onboarding.Id).Non_Standard_Setup_Notes__c )
               ||(newMapOnboarding.get(onboarding.Id).Review_Goals__c != oldMapOnboarding.get(onboarding.Id).Review_Goals__c )
               ||(newMapOnboarding.get(onboarding.Id).Secure_completed_CC_Auth__c != oldMapOnboarding.get(onboarding.Id).Secure_completed_CC_Auth__c )
               ||(newMapOnboarding.get(onboarding.Id).Send_CC_Auth__c != oldMapOnboarding.get(onboarding.Id).Send_CC_Auth__c )
               ||(newMapOnboarding.get(onboarding.Id).Touchpoint_Master_ID__c != oldMapOnboarding.get(onboarding.Id).Touchpoint_Master_ID__c )
               ||(newMapOnboarding.get(onboarding.Id).Vistadash_Conversions_Configuration_GA4__c != oldMapOnboarding.get(onboarding.Id).Vistadash_Conversions_Configuration_GA4__c )
               ||(newMapOnboarding.get(onboarding.Id).Vistadash_Event_Owner_Custom_Dimension_C__c != oldMapOnboarding.get(onboarding.Id).Vistadash_Event_Owner_Custom_Dimension_C__c )
               ||(newMapOnboarding.get(onboarding.Id).Website_Provider__c != oldMapOnboarding.get(onboarding.Id).Website_Provider__c )
               ||(newMapOnboarding.get(onboarding.Id).Website_URL__c != oldMapOnboarding.get(onboarding.Id).Website_URL__c )
               ||(newMapOnboarding.get(onboarding.Id).Inventory_Received_Automation__c != oldMapOnboarding.get(onboarding.Id).Inventory_Received_Automation__c )
               ||(newMapOnboarding.get(onboarding.Id).GTM_API_ID__c != oldMapOnboarding.get(onboarding.Id).GTM_API_ID__c )
               ||(newMapOnboarding.get(onboarding.Id).Call_Vendor__c != oldMapOnboarding.get(onboarding.Id).Call_Vendor__c )
               ||(newMapOnboarding.get(onboarding.Id).Text_Provider__c != oldMapOnboarding.get(onboarding.Id).Text_Provider__c )
               ||(newMapOnboarding.get(onboarding.Id).GTM_Sent__c != oldMapOnboarding.get(onboarding.Id).GTM_Sent__c )
               )
            {
                accIdSet.add(onboarding.Account__c);
            }
        }
        
        List<Onboarding__c> OnboardingWithSameAcc = [SELECT ID,Account__c,Account__r.Id,Auto_charge_monthly_fee__c ,BI_Launch_Date__c,
                                                     BigQuery_is_linked_in_GA4__c ,Chat_Provider__c ,Chat_Start__c,Click_to_Call__c ,
                                                     Custom_Definitions_Configurati__c ,DR_Start__c ,Dashboard_View_ID__c,
                                                     Data_Email_QA__c ,Foundation_GA4_View__c,
                                                     Foundation_View_ID__c,GA4_Measurement_ID__c ,GA4_Notes__c ,GA4_Property_Name_from_this_sheet__c,
                                                     GA_Account_Shared__c ,GTM_Container_Updated_for_GA4__c ,GTM_ID_provided__c ,
                                                     GTM_on_Site__c ,Goals_Inactive_at_Dashboard_Call__c,
                                                     Google_Facebook_Pixel_script_added_to_GT__c ,Inventory_Is_In__c ,
                                                     Inventory_Ordered_Date__c ,Lead_Form__c,Mutual_Client_with_VistaDash__c ,
                                                     Non_Standard_Setup_Notes__c  ,Review_Goals__c ,
                                                     Secure_completed_CC_Auth__c,Send_CC_Auth__c ,
                                                     Touchpoint_Master_ID__c ,
                                                     Vistadash_Conversions_Configuration_GA4__c, 
                                                     Vistadash_Event_Owner_Custom_Dimension_C__c ,Website_Provider__c ,Website_URL__c,
                                                     Inventory_Received_Automation__c,GTM_API_ID__c,Call_Vendor__c,
                                                     Text_Provider__c,GTM_Sent__c
                                                     FROM Onboarding__c 
                                                     WHERE Account__r.ID IN: accIdSet];
        
        for(Onboarding__c onboarding:OnboardingWithSameAcc){
            
            if(onboardingMapWithSameAcc.containsKey(onboarding.Account__r.Id))
            {
                onboardingMapWithSameAcc.get(onboarding.Account__r.Id).add(onboarding);
            }
            else{
                onboardingMapWithSameAcc.put(onboarding.Account__r.Id,new List<Onboarding__c> {onboarding});
            }
            
        }
        
        for(Id idValue : onboardingMapWithSameAcc.keyset()){
            for(Onboarding__c onboarding : onboardingMapWithSameAcc.get(idValue)) { 
                if((newMapOnboarding.get(onboarding.Id))!=NULL){
                    onboardingMapWithNewOnboardWithList.put(newMapOnboarding.get(onboarding.Id) , onboardingMapWithSameAcc.get(idValue));
                } 
                else{
                    continue;
                }
            }
        }
        for(Onboarding__c idValueOnboarding : onboardingMapWithNewOnboardWithList.keyset()){
            for(Onboarding__c onboarding : onboardingMapWithNewOnboardWithList.get(idValueOnboarding)) { 
                if( onboarding.Auto_charge_monthly_fee__c == FALSE &&  idValueOnboarding.Auto_charge_monthly_fee__c == TRUE)
                {
                    onboarding.Auto_charge_monthly_fee__c = idValueOnboarding.Auto_charge_monthly_fee__c;
                }
                //onboarding.BI_Launch_Date__c =idValueOnboarding.BI_Launch_Date__c;
                if( onboarding.BigQuery_is_linked_in_GA4__c == FALSE &&  idValueOnboarding.BigQuery_is_linked_in_GA4__c == TRUE)
                {
                    onboarding.BigQuery_is_linked_in_GA4__c =idValueOnboarding.BigQuery_is_linked_in_GA4__c;   
                }
                if( onboarding.Chat_Provider__c == NULL ||  onboarding.Chat_Provider__c == '')
                {
                    onboarding.Chat_Provider__c = idValueOnboarding.Chat_Provider__c ; 
                }
                if( onboarding.Chat_Start__c == NULL ||  onboarding.Chat_Start__c == '')
                {
                    onboarding.Chat_Start__c=idValueOnboarding.Chat_Start__c ;
                }
                if( onboarding.Click_to_Call__c == NULL ||  onboarding.Click_to_Call__c == '')
                {
                    onboarding.Click_to_Call__c =idValueOnboarding.Click_to_Call__c;
                }
                if( onboarding.Custom_Definitions_Configurati__c == NULL)
                {
                    onboarding.Custom_Definitions_Configurati__c =idValueOnboarding.Custom_Definitions_Configurati__c;
                }
                if( onboarding.DR_Start__c == NULL ||  onboarding.DR_Start__c == '')
                {
                    onboarding.DR_Start__c =idValueOnboarding.DR_Start__c ;
                }
                if( onboarding.Dashboard_View_ID__c == NULL ||  onboarding.Dashboard_View_ID__c == '')
                {  
                    onboarding.Dashboard_View_ID__c =idValueOnboarding.Dashboard_View_ID__c ;
                }
                if( onboarding.Data_Email_QA__c == NULL )
                { 
                    onboarding.Data_Email_QA__c =idValueOnboarding.Data_Email_QA__c; 
                }
                if( onboarding.Foundation_GA4_View__c == NULL ||  onboarding.Foundation_GA4_View__c == '')
                { 
                    onboarding.Foundation_GA4_View__c =idValueOnboarding.Foundation_GA4_View__c ; 
                }
                if( onboarding.Foundation_View_ID__c == NULL ||  onboarding.Foundation_View_ID__c == '')
                {  
                    onboarding.Foundation_View_ID__c =idValueOnboarding.Foundation_View_ID__c ;
                }
                if( onboarding.GA4_Measurement_ID__c == NULL ||  onboarding.GA4_Measurement_ID__c == '')
                {  
                    onboarding.GA4_Measurement_ID__c =idValueOnboarding.GA4_Measurement_ID__c ; 
                }
                if( onboarding.GA4_Notes__c == NULL ||  onboarding.GA4_Notes__c == '')
                {  
                    onboarding.GA4_Notes__c =idValueOnboarding.GA4_Notes__c ; 
                }
                if( onboarding.GA4_Property_Name_from_this_sheet__c == NULL ||  onboarding.GA4_Property_Name_from_this_sheet__c == '')
                {  
                    onboarding.GA4_Property_Name_from_this_sheet__c =idValueOnboarding.GA4_Property_Name_from_this_sheet__c ;
                }
                if( onboarding.GA_Account_Shared__c == NULL ||  onboarding.GA_Account_Shared__c == '')
                { 
                    onboarding.GA_Account_Shared__c =idValueOnboarding.GA_Account_Shared__c ; 
                }
                if( onboarding.GTM_Container_Updated_for_GA4__c == NULL)
                {  
                    onboarding.GTM_Container_Updated_for_GA4__c =idValueOnboarding.GTM_Container_Updated_for_GA4__c ;
                }
                if( onboarding.GTM_ID_provided__c == NULL ||  onboarding.GTM_ID_provided__c == '')
                {  
                    onboarding.GTM_ID_provided__c =idValueOnboarding.GTM_ID_provided__c ;
                }
                if( onboarding.GTM_on_Site__c == NULL)
                { 
                    onboarding.GTM_on_Site__c =idValueOnboarding.GTM_on_Site__c ; 
                }
                if( onboarding.Goals_Inactive_at_Dashboard_Call__c == NULL ||  onboarding.Goals_Inactive_at_Dashboard_Call__c == '')
                { 
                    onboarding.Goals_Inactive_at_Dashboard_Call__c =idValueOnboarding.Goals_Inactive_at_Dashboard_Call__c ; 
                }
                if( onboarding.Google_Facebook_Pixel_script_added_to_GT__c == NULL ||  onboarding.Google_Facebook_Pixel_script_added_to_GT__c == '')
                {  
                    onboarding.Google_Facebook_Pixel_script_added_to_GT__c =idValueOnboarding.Google_Facebook_Pixel_script_added_to_GT__c ;
                }
                if( onboarding.Inventory_Is_In__c == NULL )
                { 
                    onboarding.Inventory_Is_In__c =idValueOnboarding.Inventory_Is_In__c ;
                }
                if( onboarding.Inventory_Ordered_Date__c == NULL )
                { 
                    onboarding.Inventory_Ordered_Date__c =idValueOnboarding.Inventory_Ordered_Date__c ; 
                }
                if( onboarding.Lead_Form__c == NULL ||  onboarding.Lead_Form__c == '')
                { 
                    onboarding.Lead_Form__c =idValueOnboarding.Lead_Form__c ;
                }
                if( onboarding.Mutual_Client_with_VistaDash__c == FALSE &&  idValueOnboarding.Mutual_Client_with_VistaDash__c == TRUE)
                {  
                    onboarding.Mutual_Client_with_VistaDash__c =idValueOnboarding.Mutual_Client_with_VistaDash__c ; 
                }
                if( onboarding.Non_Standard_Setup_Notes__c == NULL ||  onboarding.Non_Standard_Setup_Notes__c == '')
                { 
                    onboarding.Non_Standard_Setup_Notes__c =idValueOnboarding.Non_Standard_Setup_Notes__c ; 
                }
                if( onboarding.Review_Goals__c == NULL )
                { 
                    onboarding.Review_Goals__c =idValueOnboarding.Review_Goals__c ; 
                }
                if( onboarding.Secure_completed_CC_Auth__c == FALSE &&  idValueOnboarding.Secure_completed_CC_Auth__c == TRUE)
                { 
                    onboarding.Secure_completed_CC_Auth__c =idValueOnboarding.Secure_completed_CC_Auth__c ; 
                }
                if( onboarding.Send_CC_Auth__c == NULL )
                {  
                    onboarding.Send_CC_Auth__c =idValueOnboarding.Send_CC_Auth__c ; 
                }
                if( onboarding.Touchpoint_Master_ID__c == NULL ||  onboarding.Touchpoint_Master_ID__c == '')
                {  
                    onboarding.Touchpoint_Master_ID__c =idValueOnboarding.Touchpoint_Master_ID__c ; 
                }
                if( onboarding.Vistadash_Conversions_Configuration_GA4__c == NULL )
                {
                    onboarding.Vistadash_Conversions_Configuration_GA4__c =idValueOnboarding.Vistadash_Conversions_Configuration_GA4__c ; 
                }
                if( onboarding.Vistadash_Event_Owner_Custom_Dimension_C__c == FALSE &&  idValueOnboarding.Vistadash_Event_Owner_Custom_Dimension_C__c == TRUE)
                { 
                    onboarding.Vistadash_Event_Owner_Custom_Dimension_C__c =idValueOnboarding.Vistadash_Event_Owner_Custom_Dimension_C__c; 
                }
                if( onboarding.Website_Provider__c == NULL ||  onboarding.Website_Provider__c == '')
                { 
                    onboarding.Website_Provider__c =idValueOnboarding.Website_Provider__c ;
                }
                if( onboarding.Website_URL__c == NULL ||  onboarding.Website_URL__c == '')
                {  
                    onboarding.Website_URL__c =idValueOnboarding.Website_URL__c ;
                }
                 if( onboarding.Inventory_Received_Automation__c == NULL ||  onboarding.Inventory_Received_Automation__c == '')
                {  
                    onboarding.Inventory_Received_Automation__c =idValueOnboarding.Inventory_Received_Automation__c ;
                }
                if( onboarding.GTM_API_ID__c == NULL ||  onboarding.GTM_API_ID__c == '')
                {  
                    onboarding.GTM_API_ID__c =idValueOnboarding.GTM_API_ID__c ;
                }
                if( onboarding.Call_Vendor__c == NULL ||  onboarding.Call_Vendor__c == '')
                {  
                    onboarding.Call_Vendor__c =idValueOnboarding.Call_Vendor__c ;
                }
                if( onboarding.GTM_Sent__c == NULL )
                {  
                    onboarding.GTM_Sent__c =idValueOnboarding.GTM_Sent__c ;
                }
                if( onboarding.Text_Provider__c == NULL ||  onboarding.Text_Provider__c == '')
                {  
                    onboarding.Text_Provider__c =idValueOnboarding.Text_Provider__c ;
                }
                
                listToUpdate.add(onboarding);
            }
        }
        system.debug('listToUpdate : '+listToUpdate);
        try{
            update listToUpdate;
        }
        catch(Exception e){
            System.debug('Error occured : '+ e.getMessage());
        }
    }
}