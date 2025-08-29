global class FetchTouchpointIdfrmMail implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) {
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        if(email.plainTextBody != Null && email.plainTextBody != ''){
            string accName;
            string touchPointId;
            if(email.plainTextBody.contains(':')){
                String[] emailBodyRows = email.plainTextBody.split(':');
                System.debug('===emailBodyRows==='+emailBodyRows[1]);
                if(emailBodyRows[1].contains('|')){
                    String[] rowContents = emailBodyRows[1].split('\\|');
                   System.debug('===rowContents==='+rowContents);
                    accName = rowContents[0].replace('\n', ' ').trim(); 
                    String[] temptpid = rowContents[1].split('\n');
                    touchPointId =  temptpid[0].trim();
                    System.debug('===accName==='+accName);
                    System.debug('===touchPointId==='+touchPointId);
                }
            }
            if(accName != null){
                Onboarding__c obj = [Select id,Touchpoint_Master_ID__c from Onboarding__c where Account__r.Name =:accName ];
                obj.Touchpoint_Master_ID__c = touchPointId;
                update obj;
            }
        }
        result.success = true;
        return result;
    }
}