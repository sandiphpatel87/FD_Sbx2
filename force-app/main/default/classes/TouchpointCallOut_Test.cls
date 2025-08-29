@isTest
public class TouchpointCallOut_Test{
   @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        TouchpointCallOut tw = new TouchpointCallOut();
        TouchpointCallOut.tpCallout('12345', '001180000110O3F');

    }
    
    @isTest static void testInvocable() {
        List<Account> accList = [Select Id, Touchpoint_Master_ID__c  from account WHere Touchpoint_Master_ID__c != null LIMIT 1];
        TouchpointCallOutInvocable tpInvo = new TouchpointCallOutInvocable();
        //TouchpointCallOutInvocable .invokeapexcallout(accList); 
    }
}