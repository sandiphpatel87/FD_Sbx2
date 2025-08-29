@isTest
public class Test_MeasurementTrigger 
{
	@isTest
    static void testOnAfterUpdate() 
    {
        Test.startTest();
        
        // Create test data
        Measurement__c objMeasurement = new Measurement__c(Name = 'Test Measurement 1', GA4_Notes__c = 'Value 1');
        INSERT objMeasurement;
        
        objMeasurement.GA4_Notes__c = 'Value 2';
        UPDATE objMeasurement;
        
        Test.stopTest();
    }
}