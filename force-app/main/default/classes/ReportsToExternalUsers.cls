/***********************************************************************************************
Name            : ReportsToExternalUsers 
Author          : Sandip Patel
Created Date    : June 2024
Revision History:

Usage           : Batch class to send emails to external users 

***********************************************************************************************/
global class ReportsToExternalUsers implements Database.Batchable<sObject>, Schedulable {
    
    private static Integer DEFAULD_BATCH_SIZE = 1;
    private static Integer REPORT_SIZE_LIMIT = 2000;
    private  String CURRENT_TIME;
    private  String CURRENT_DATE;
    private  String CURRENT_DAY;
    private String query = 'SELECT Report_Name__c, Time__c,Report_Id__c,From_Email_Address__c, External_Emails__c, External_Emails_BCC__c, Email_Subject__c, Email_Body_Text__c, Sort_Field__c, Sort_Order__c, Unique_Field_Api_Name__c,DateOfMonth__c,DayOfWeek__c,Frequency__c FROM Reports_To_External_User__mdt';
    
    private Integer batchSize;
    private Set<String> reportsSettingNames;
    
    global ReportsToExternalUsers() {
        this.batchSize = DEFAULD_BATCH_SIZE;
    }
    
    global ReportsToExternalUsers(Integer batchSize) {
        this.batchSize = batchSize;
    }
    
    global ReportsToExternalUsers(Set<String> reportsSettingNames) {
        this.reportsSettingNames = reportsSettingNames;
        this.query += ' WHERE Name IN :reportsSettingNames';
        this.batchSize = DEFAULD_BATCH_SIZE;
        
        
    }
    /*Batch class Start Method*/
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    //  -------------------------------------------------------------------------
    //  * This method is REQUIRED for batchable Apex and is where we loop through the
    //  * results of the query specified in the execte() method
    //  -------------------------------------------------------------------------
    global void execute(Database.BatchableContext bc, List<Reports_To_External_User__mdt> scope) {
        
     	//String datetimeESTStr = (DateTime.now()).format('yyyy-MM-dd\'T\'HH:mm:ssZ', 'America/New_York');
        
        this.CURRENT_DAY = (DateTime.now()).format('E', 'America/New_York');
        this.CURRENT_TIME = (DateTime.now()).format('hh:mm a', 'America/New_York');
        this.CURRENT_DATE = (DateTime.now()).format('dd', 'America/New_York');
        
        for (Reports_To_External_User__mdt reportTo : scope) {
            
            if(reportTo.Frequency__c == 'Monthly' && reportTo.Time__c == this.CURRENT_TIME) 
            {
                if( reportTo.DateOfMonth__c ==  this.CURRENT_DATE) 
                {
                    prepareEmailData(reportTo);
                }
            }
            
            if(reportTo.Frequency__c == 'Weekly' && reportTo.Time__c == this.CURRENT_TIME) 
            {
                if( reportTo.DayOfWeek__c   == this.CURRENT_DAY ) 
                {
                    prepareEmailData(reportTo);
                }
            }
            
            if(reportTo.Frequency__c == 'Daily' && reportTo.Time__c == this.CURRENT_TIME) 
            {
                   prepareEmailData(reportTo);
            }
            
            if(Test.isRunningTest())
            {
                prepareEmailData(reportTo);
            }
        }
    }
    global void prepareEmailData(Reports_To_External_User__mdt reportTo)
    {
        Set<String> emails = this.parseEmails(reportTo.External_Emails__c);
        Set<String> bccemails;
        if(String.isNotBlank(reportTo.External_Emails_BCC__c)){
            bccemails = this.parseEmails(reportTo.External_Emails_BCC__c);
        }
        String attachmentContent = this.getCSVString(
            reportTo.Report_Id__c, reportTo.Sort_Field__c, reportTo.Sort_Order__c, reportTo.Unique_Field_Api_Name__c
        );
        
        this.sendEmails(
            emails, bccemails, attachmentContent, reportTo.Email_Subject__c, reportTo.Email_Body_Text__c, reportTo.Report_Name__c, reportTo.From_Email_Address__c
        );
    }
    //  -------------------------------------------------------------------------
    //  * This method is REQUIRED for batchable Apex... It puts some results in the log
    //  -------------------------------------------------------------------------
    global void finish(Database.BatchableContext bc) {}
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this, this.batchSize);
    }
    //GetCSVString Method which process the report mentioned in custom setting and determine all the filter condittions 
    private String getCSVString(Id reportId, String sortField, String sortOrder, String uniqueField) {
        String result = '';
        
        Reports.reportResults reportResults = Reports.ReportManager.runReport(reportId, true);
        Reports.ReportDescribeResult describeResults = Reports.ReportManager.describeReport(reportId);
        
        Reports.ReportMetadata reportMetadata = describeResults.getReportMetadata();
        
        List<String> columns = reportMetadata.getDetailColumns();
        Map<String, Reports.DetailColumn> detailColumns = describeResults.getReportExtendedMetadata().getDetailColumnInfo();
        
        List<String> columnNames = new List<String>();
        
        Integer uniqueFieldIndex = null;
        Integer orderFieldIndex = null;
        
        for (Integer i=0; i<columns.size(); i++) {
            columnNames.add(detailColumns.get(columns[i]).getLabel());            
            
            if (String.isNotBlank(uniqueField) && detailColumns.get(columns[i]).getName() == uniqueField) {
                uniqueFieldIndex = i;
            }
            
            if (String.isNotBlank(sortField) && detailColumns.get(columns[i]).getName() == sortField) {
                orderFieldIndex = i;
            }
        }
        
        result = String.join(columnNames, ',');
        result += '\n';
        
        Set<String> uniqueKeys = new Set<String>();
        String lastOrderField = null;
        
        Integer numberOfAddedRecords = 0;
        
        Boolean hasNext = true;
        while (hasNext) {
            
            Reports.ReportMetadata rm = Reports.ReportManager.describeReport(reportId).getReportMetadata();
            
            List<Reports.ReportFilter> reportFilters = rm.getReportFilters();
            
            /*if (!Test.isRunningTest() && rm.getDeveloperName() != 'EVBS_Opportunities') {
reportFilters.add(new Reports.ReportFilter(
sortField,
sortOrder == 'asc' ? 'greaterOrEqual' : 'lessOrEqual',
lastOrderField
));
}*/
            
            rm.setReportFilters(reportFilters);
            
            Reports.reportResults results = Reports.ReportManager.runReport(reportId, rm, true);
            
            Reports.ReportFactWithDetails details = (Reports.ReportFactWithDetails) results.getFactMap().get('T!T');
            List<Reports.ReportDetailRow> rowsChunk = details.getRows();
            
            System.debug('>>> rowsChunk.size() ::: ' + rowsChunk.size());
            
            Boolean wasAdded = false;
            
            for (Reports.ReportDetailRow row : rowsChunk) {
                
                List<String> values = new List<String>();
                Boolean shouldBeAdded = false;
                String localLastOrderField = null;
                String localUniqueKey = null;
                
                List<Reports.ReportDataCell> dataCells = row.getDataCells();
                
                for (Integer j=0; j<dataCells.size(); j++) {
                    
                    if (uniqueFieldIndex != null && uniqueFieldIndex == j) {
                        
                        if (!uniqueKeys.contains(String.valueOf(dataCells[j].getValue()))) {
                            shouldBeAdded = true;
                            localUniqueKey = String.valueOf(dataCells[j].getValue());
                            localLastOrderField = String.valueOf(dataCells[j].getValue());
                        }
                        else {
                            System.debug('>>> uniqueKeys duplicate ::: ' + String.valueOf(dataCells[j].getValue()));
                            continue;
                        }
                    }
                    
                    String value = dataCells[j].getLabel() == '-' ? '""' : '"' + dataCells[j].getLabel().replace('"', '""') + '"';
                    values.add(value);
                }
                System.debug('>>> values ::: ' + values);
                if ( !values.isEmpty()) {
                    numberOfAddedRecords++;
                    wasAdded = true;
                    uniqueKeys.add(localUniqueKey);
                    lastOrderField = localLastOrderField;
                    result += String.join(values, ',') + '\n';
                }
                System.debug('>>> result ::: ' + result);
            }
            
            System.debug('>>> numberOfAddedRecords ::: ' + numberOfAddedRecords);
            
            if (rowsChunk.size() < REPORT_SIZE_LIMIT || !wasAdded || Test.isRunningTest()) {
                hasNext = false;
            }
        }
        System.debug('>>> result ::: ' + result);
        return result;
    }
    
    private Set<String> parseEmails(String emails) {
        Set<String> result = new Set<String>();
        for (String email : emails.split(',')) {
            if (String.isNotBlank(email.trim())) {
                result.add(email.trim());
            }
        }
        return result;
    }
    //SendEmails method identifies external users email id's from custom setting and batch will send the report as attachment to users
    private void sendEmails(Set<String> emails, Set<String> bccemails, String attachmentContent, String subject, String body, String reportName, String fromEmailAddress)
    {
        System.Debug('Emails ===>' + emails);
        List<Messaging.SingleEmailMessage> singleEmails = new List<Messaging.SingleEmailMessage>();
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: fromEmailAddress];
        
        Messaging.SingleEmailMessage singleEmail = new Messaging.SingleEmailMessage();
        
        if (owea.size() > 0) {
            singleEmail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName(reportName + ' - ' + String.valueOfGMT(Datetime.now()) + '.csv');
        attachment.setBody(Blob.valueOf(attachmentContent));
        attachment.setContentType('text/csv');
        
        singleEmail.setSubject(subject);
        singleEmail.setToAddresses(new List<String>(emails));
        singleEmail.setBCCAddresses(new List<String>(bccemails));
        singleEmail.setPlainTextBody(body);
        
        singleEmail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
        
        singleEmails.add(singleEmail);
        
        if (!Test.isRunningTest()) {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{singleEmail});
        }
    }
    
    private class NoSuchReportException extends Exception {}
}