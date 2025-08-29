global class OpportunityVfFileController {
    
    public  Opportunity opportunityDetails {get; set;}
    public  Account accountDetails {get; set;}
    public ID opportunityId {get; set;}
    public String fileId {get; set;}
    public String pdfId {get; set;}
    public Boolean isPdf {get; set;}
    public String contractDisplayDate {get; set;}
    public id objParentId{get;set;}
      public String returnValue {get; set;}
  
       // Determines whether page is rendered as a PDF or just displayed as HTML
    public String renderAs { get; set; }
    

    

    // Action method to "print" to PDF
    public PageReference print() {
        renderAs = 'PDF';
        return null;
    }

    @RemoteAction
    global static boolean saveSignature(String signatureBody, id parentId){
        //try{  
            system.debug('Record== ' + parentId);
            system.debug(signatureBody);
            Attachment a = new Attachment();
            a.ParentId = parentId;
            a.Body = EncodingUtil.base64Decode(signatureBody);
            a.ContentType = 'image/png';
            a.Name = 'Signature Capture.png';
            insert a;
            
            Schema.SObjectType sobjectType = parentId.getSObjectType();
            String sobjectName = sobjectType.getDescribe().getName();
            sObject s = Schema.getGlobalDescribe().get(sobjectName).newSObject() ;
            s.put('Id',parentId);
            // at this point you can edit any fields you have on the parentId.
            // I have SignaureId__(text[18]) on objects where I want to capture the id of the signature
            // attachment on the record.
            //s.put('Contract_Signed_Date_Time__c', DateTime.now().format());
            update s;
            
            return true;
            //return '{success:true, attachId:' + a.Id + ', sObject: ' + c + '}';
        //}
        /*
        catch(Exception e){
            system.debug(e);
            return false;
        }
        */
    }
    public void onLoadGetOppData(){
        //flagnew=true;
        //system.debug(flagnew);
        //opportunityId = '0066C00000J7YI2QAN';
        
        
        opportunityId= ApexPages.CurrentPage().getparameters().get('recordId');
        String CheckisPdf= ApexPages.CurrentPage().getparameters().get('isPdf');
        if(CheckisPdf == 'true' ){
            isPdf=true;
        }
        else{ isPdf=false;}
        system.debug('opportunityId '+opportunityId);
        
        if(opportunityId != Null){
            opportunityDetails = [SELECT ID,Name,MRR__c,Setup_Fee__c,Total_MRR__c,NCM_20_Group_Code__c,Special_contract_notes__c,AccountId,Account.Name,Account.ShippingAddress,Account.BillingAddress,
                                  Account.BillingCity,Account.BillingStreet,Account.BillingState,Account.BillingPostalcode,Account.BillingCountry,
                                  Account.ShippingCity,Account.ShippingStreet,Account.ShippingState,Account.ShippingPostalcode,
                                  Account.ShippingCountry,Account.Billing_Contact__c,Account.Billing_email__c,Account.Billing_Phone__c,
                                  Website_URL__c,Website_Provider__c,Inventory_Contact_First_Name__c,Inventory_Contact_Last_Name__c,
                                  Inventory_Contact_Name__c,Inventory_Contact_Phone__c,Inventory_Contact_Email__c,NCM_Composite_Name__c,
                                  NCM_Composite_Email__c,NCM_Composite_Title__c,Contract_Signer_Title__c,Contract_Signer__c,Inventory_Feed_Provider_New_Car__c,
                                  Inventory_Feed_Provider_Used_Car__c,Google_Ads_Account_CID__c,Existing_Paid_Search_Provider__c,Contract_Signer_Email__c,
                                  InventoryFeed_Expected_of_New_car__c,InventoryFeed_Expected_of_Used_Car__c,Contract_Signed_Date__c,
                                  GA_Contact_Name__c,GA_Contact_Email__c,GA_Contact_Phone__c,Paid_Search_Provider__c,
                                  aggregate_my_Google_Analytics_data__c,APPROVE_the_request_on_behalf_of_FD__c,
                                  Billing_Contact_Email__c,Billing_Contact_First_Name__c,Billing_Contact_Last_Name__c,Billing_Contact_Phone__c,
                                  Contract_Signed_Date_Time__c,Contract_Signer_Phone__c
                                  FROM Opportunity where ID=:opportunityId];
            
            if(!(String.isBlank(opportunityDetails.Contract_Signed_Date_Time__c)))
            {
                contractDisplayDate = (opportunityDetails.Contract_Signed_Date_Time__c).remove(',');
            }
            
            
            accountDetails = [SELECT Name,
                              ShippingAddress,BillingAddress,BillingCity,BillingStreet,BillingState,
                              BillingPostalcode,BillingCountry,ShippingCity,ShippingStreet,
                              ShippingState,ShippingPostalcode,ShippingCountry
                              FROM Account  where ID=: opportunityDetails.AccountId];
            
            /* fName = opportunityDetails.Billing_Contact_First_Name__c;
lName = opportunityDetails.Billing_Contact_Last_Name__c;
phone = opportunityDetails.Billing_Contact_Phone__c;*/
            
            List<Attachment> attachedFiles = [select Id from Attachment where parentId =:opportunityDetails.Id and Name = 'Signature Capture.png' order By 
                                              LastModifiedDate DESC limit 1];
            if( attachedFiles != null && attachedFiles.size() > 0 ) {
                fileId = attachedFiles[0].Id;
            }else{
                fileId = 'null';
            }
            List<Attachment> attachedFilesPdf = [select Id from Attachment where parentId =:opportunityId and Name like '%.pdf%'  order By 
                                                 LastModifiedDate DESC limit 1];
            if( attachedFilesPdf != null && attachedFilesPdf.size() > 0 ) {
                pdfId = attachedFilesPdf[0].Id;
            }else{
                pdfId = 'null';
            }
        }
    }
    /*public String callMethod(){
        String resultOfApex='';
        system.debug('IN updateRecord --------------------------------------------------');
        try{
           system.debug('IN TRY ----------------------------------------------'); 
        update opportunityDetails ;
        update accountDetails;
           resultOfApex = 'success';
            return resultOfApex;
        } 
        catch(DmlException e)
        {
            system.debug('ERROR --------------> '+e.getMessage());
            resultOfApex =e.getMessage();
             //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return resultOfApex;
        }
    }*/


   
    public void updateRecord() {
        system.debug('IN updateRecord --------------------------------------------------');
        
        system.debug('IN TRY ----------------------------------------------'); 
        //opportunityDetails.Contract_Signed_Date__c = system.Today();
        update opportunityDetails ;
        update accountDetails;
         // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Details Updated Successfully'));
             returnValue = 'Success';
            //return true;
        /*} 
        catch(DmlException e)
        {
            system.debug('ERROR --------------> '+e.getMessage());
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            //string s = e.getMessage();
            returnValue = 'Error occured while saving record';
           // return false;
        }*/
        
        //signbutton = true;
        // Boolean flag = true;
        
        //return signbutton;
        /*if(opportunityDetails.Billing_Contact_Phone__c != '' || opportunityDetails.Billing_Contact_Phone__c != null)
{
if(!Pattern.matches('[0-9(),./\\-]+', (opportunityDetails.Billing_Contact_Phone__c)))
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Billing Contact Phone in correct format'));
}if(accountDetails.Billing_email__c != ''){
List<Contact> conList = [SELECT id,Email,Phone,FirstName,LastName FROM Contact WHERE Email=: accountDetails.Billing_email__c];
if(conList.size()>0){
accountDetails.Billing_Contact__c = conList[0].ID;
}
else{
system.debug('In else');
Contact c = new Contact(FirstName=fName,LastName=lName,AccountId=accountDetails.Id,Email=accountDetails.Billing_email__c,Phone=phone);
system.debug(c);
Insert c;
accountDetails.Billing_Contact__c = c.Id;
}
}*/
        
        
    }
    
    
    /*public PageReference downloadPDF()
{
PageReference ref = new PageReference('https://foundationdirect--devsbx.sandbox.my.site.com/servlet/servlet.FileDownload?file='+ pdfId);
return ref;
}*/
}