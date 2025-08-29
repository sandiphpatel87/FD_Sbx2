@isTest(SeeAllData=true)
public class FetchTaskStatusfrmMail_Test {
    @isTest
    public Static void test(){
        user usr = [select id from user where Isactive = true limit 1];
        task tsk = new task();
        tsk.Subject = 'Build DB task';
        tsk.Priority = 'normal';
        tsk.Status ='open';
        tsk.OwnerId = usr.Id;
        insert tsk;
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.subject = 'Test';
        email.fromname = 'Test Test';
        env.fromAddress = 'Test@email.com';
        email.plainTextBody = 'Done Hello This has been setup under Master Account ID :  test  | abcded TaskId- '+tsk.Id +'> Thank u ';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
        FetchTaskStatusfrmMail emailProcess = new FetchTaskStatusfrmMail();
        emailProcess.handleInboundEmail(email, env);
        Test.stopTest();
    }
}