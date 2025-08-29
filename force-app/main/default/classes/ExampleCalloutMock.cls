@isTest
global class ExampleCalloutMock implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    res.setBody('Hello This has been setup under Master Account ID :  test  | abcded');
    return res;
  }
}