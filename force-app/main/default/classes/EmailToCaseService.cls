global class EmailToCaseService implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        // Initialize the result object
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        String OwnerID;
        String AssingedToID;
        String AcctId;
        
        // Query the custom setting to get the User ID
        Email_Service_Case_Assignment__c userConfig = Email_Service_Case_Assignment__c.getInstance('TVM Tagging Case');
        
        if (userConfig != null) {
            OwnerID = userConfig.OwnerId__c; 
            AssingedToID = userConfig.AssignedToId__c;
            AcctId = userConfig.AccountId__c;
        } 

        try {
            // Parse the email body to extract fields
            Map<String, String> fieldMap = parseEmailBody(email.plainTextBody);

            // Create a new Case record
            Case newCase = new Case();

            // Set Case fields from the email
            newCase.Subject = email.subject; 
            newCase.TVM_TPID__c = fieldMap.get('TVM TPID');
            newCase.FD_TPID__c = fieldMap.get('FD TPID'); 
            newCase.Dealer_Name__c = fieldMap.get('Dealer Name');
            newCase.Analytics_Franchise__c = fieldMap.get('Analytics Franchise'); 
            newCase.Apollo_Website_URL__c = fieldMap.get('Apollo Website URL'); 
            newCase.Apollo_Website_Staging_URL__c = fieldMap.get('Apollo Website Staging URL'); 
            newCase.Address_Street__c = fieldMap.get('Address Street');
            newCase.Address_City__c = fieldMap.get('Address City'); 
            newCase.Address_State__c = fieldMap.get('Address State');
            newCase.Address_Zip__c = fieldMap.get('Address Zip'); 
            
            newCase.Request_Type__c = 'TVM Tagging';
            newCase.Priority = 'Medium';
            newCase.Status = 'New';           
            newCase.Description = 'New TVM website customer ready to setup measurement strategy.';
            if(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Measurement').getRecordTypeId() != null){
            	newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Measurement').getRecordTypeId();    
            }
            if(OwnerID != null){
            	newCase.OwnerId = OwnerID;    
            }
            if(AssingedToID != null){
                newCase.Case_Assign_To__c = AssingedToID;
            }
            
            if(AcctId != null){
                newCase.AccountId = AcctId;
            }
            
            // Insert the Case record
            insert newCase;

            // Set the result to true to indicate success
            result.success = true;
        } catch (Exception e) {
            // Handle any errors
            result.success = false;
            result.message = 'Error processing email: ' + e.getMessage();
        }

        return result;
    }

    // Helper method to parse the email body and extract fields
    public Map<String, String> parseEmailBody(String emailBody) {
    Map<String, String> fieldMap = new Map<String, String>();

    // Define the keys to look for
    Set<String> keys = new Set<String>{
        'TVM TPID', 'FD TPID', 'Dealer Name', 'Analytics Franchise', 
        'Apollo Website URL', 'Apollo Website Staging URL', 
        'Address Street', 'Address City', 'Address State', 'Address Zip'
    };

    // Split the email body into lines
    List<String> lines = emailBody.split('\n');

    // Iterate through each line and extract key-value pairs
    for (String line : lines) {
        // Trim the line to remove leading/trailing spaces
        line = line.trim();

        // Skip empty lines
        if (String.isBlank(line)) {
            continue;
        }

        // Check if the line matches any of the expected keys
        for (String key : keys) {
            if (line.toLowerCase().startsWith(key.toLowerCase() + ':')) {
                // Extract the value after the key and trim any extra spaces
                String value = line.substringAfter(key + ':').trim();
                // Add the key-value pair to the map
                fieldMap.put(key, value);
                break; // Exit the inner loop once the key is found
            }
        }

        // Stop parsing if all keys are found
        if (fieldMap.size() == keys.size()) {
            break;
        }
    }

    // Log warnings for missing keys
    for (String key : keys) {
        if (!fieldMap.containsKey(key)) {
            System.debug('Warning: Key not found in email body: ' + key);
        }
    }

    return fieldMap;
	}
}