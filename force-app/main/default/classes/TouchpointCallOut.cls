public class TouchpointCallOut{
  
    @future(callout=true)
    public static void tpCallout(String tpmasterId, Id accId) {
    
    String baseURL = String.ValueOf(TouchPoint_Callout__mdt.getinstance('BaseURL').get('Value__c'));
    String act = 'act=' + TouchPoint_Callout__mdt.getinstance('act').get('Value__c') + '&';
    String apptoken = 'apptoken=' + TouchPoint_Callout__mdt.getinstance('apptoken').get('Value__c') +'&';
    String usertoken = 'usertoken=' + TouchPoint_Callout__mdt.getinstance('usertoken').get('Value__c') + '&';
    String rid = 'rid=' + tpmasterId + '&';
    String fid = '_fid_6001=' + accId;
    String epUrl = baseURL + act + apptoken + usertoken + rid + fid;
    System.Debug('EP URL: ' + epURL);
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(epURL);
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/json');
    req.setBody('Body test');
    HttpResponse response = h.send(req);
    String ResponseBody = req.getBody();
    System.Debug('ResponseBody : ' + response );
    if (response.getStatusCode() == 200) {
         //Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
         if(!Test.isRunningTest()){
             DOM.Document doc = response.getBodyDocument();
             Dom.XMLNode xmlnodes = doc.getRootElement();
                                   
             System.debug('Received the response:');
             
             //System.debug('action :' + xmlnodes.getChildElement('action', null).getText());
             //System.debug('errcode :' + xmlnodes.getChildElement('errcode', null).getText());
             //System.debug('errtext :' + xmlnodes.getChildElement('errtext', null).getText());
             //System.debug('rid :' + xmlnodes.getChildElement('rid', null).getText());
             //System.debug('num_fields_changed :' + xmlnodes.getChildElement('num_fields_changed', null).getText());
             //System.debug('update_id :' + xmlnodes.getChildElement('update_id', null).getText());
         }
    }
  }
}