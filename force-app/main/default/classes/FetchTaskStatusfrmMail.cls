global class FetchTaskStatusfrmMail implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        if(email.plainTextBody != Null && email.plainTextBody != ''){
            System.debug('============'+ email.plainTextBody);
            if(email.plainTextBody.containsIgnoreCase('completed') ||email.plainTextBody.containsIgnoreCase('complete')||email.plainTextBody.containsIgnoreCase('done')||email.plainTextBody.containsIgnoreCase('close')||email.plainTextBody.containsIgnoreCase('colsed')     ){
                if(email.plainTextBody.containsIgnoreCase('TaskId-')){
                    String[] emailBodyRows = email.plainTextBody.split('TaskId- ');
                    System.debug('========emailBodyRows===='+emailBodyRows); 
                    System.debug('========emailBodyRows===='+emailBodyRows[0]); 
                    System.debug('========emailBodyRows===='+emailBodyRows[1]); 
                    
                    String[] taskId = emailBodyRows[1].split('>');
                    System.debug('========taskId===='+taskId[0].trim());
                    String tskIds = taskId[0].trim();
                    if(tskIds != null && tskIds !=''){
                        Task tsk = [select id,status from Task where Id =: tskIds ];
                        tsk.status = 'completed';
                        update tsk;
                    }
                }
            }
        }
        return null;
    }
}