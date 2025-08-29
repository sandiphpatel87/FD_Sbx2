public class TouchpointCallOutInvocable {
   String test = 'test String1';
   String test1 = 'test String1';
   String test2 = 'test String1';
   String test3 = 'test String1';
   String test4 = 'test String1';
   String test5 = 'test String1';
   String test6 = 'test String1';
  @InvocableMethod
   public static void invokeapexcallout(list<Account> acc) {
     TouchpointCallOut.tpCallout(acc[0].Touchpoint_Master_ID__c, acc[0].id);
   }
}