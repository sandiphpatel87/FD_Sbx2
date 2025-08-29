@isTest(SeeAllData=true)
public class FetchTouchpointIdfrmMail_Test {
    @isTest
    public Static void test(){
        Account acc = new Account();
        acc.Name ='test';
        insert acc;
        onboarding__c onBoard= new onboarding__c();
        onBoard.Account__c = acc.Id;
        insert onBoard;
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.subject = 'Test';
        email.fromname = 'Test Test';
        env.fromAddress = 'Test@email.com';
        email.plainTextBody = 'Hello This has been setup under Master Account ID :  test  | abcded';
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
        FetchTouchpointIdfrmMail emailProcess = new FetchTouchpointIdfrmMail();
        emailProcess.handleInboundEmail(email, env);
        Test.stopTest();
    }
}