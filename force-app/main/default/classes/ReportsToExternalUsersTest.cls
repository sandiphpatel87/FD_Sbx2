@isTest
public class ReportsToExternalUsersTest {
    @isTest(SeeAllData=true)
    static  void testPreferenceRecordCreation()
    {

        Test.startTest();
         Database.executeBatch(new ReportsToExternalUsers(), 200);
        Test.stopTest();
    }
}