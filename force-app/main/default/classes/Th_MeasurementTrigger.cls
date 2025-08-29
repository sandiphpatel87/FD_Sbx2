public class Th_MeasurementTrigger 
{
    public static void onAfterUpdate(Map<Id, Measurement__c> mapNewMeasurements, Map<Id, Measurement__c> mapOldMeasurements)
    {
        If(!mapNewMeasurements.isEmpty())
        {
            List<Measurement_History__c> listMeasurementHistories = new List<Measurement_History__c>();
            
            For(Measurement__c objMeasurement : mapNewMeasurements.Values())
            {
                For(Schema.FieldSetMember fld :SObjectType.Measurement__c.FieldSets.Field_Activity_History.getFields()) 
                {
                    If(mapNewMeasurements.get(objMeasurement.Id).get(fld.getFieldPath()) != mapOldMeasurements.get(objMeasurement.Id).get(fld.getFieldPath()))
                    {
                        Measurement_History__c objMeasurementHistory = new Measurement_History__c();
                        objMeasurementHistory.Measurement__c = objMeasurement.Id;
                        objMeasurementHistory.Field_Name__c = fld.getLabel();
                        objMeasurementHistory.Field_API_Name__c = fld.getFieldPath();
                        
                        If(mapNewMeasurements.get(objMeasurement.Id).get(fld.getFieldPath()) != null)
                        {
                            objMeasurementHistory.New_Value__c = String.valueOf(mapNewMeasurements.get(objMeasurement.Id).get(fld.getFieldPath()));
                        }
                        
                        If(mapOldMeasurements.get(objMeasurement.Id).get(fld.getFieldPath()) != null)
                        {
                            objMeasurementHistory.Old_Value__c = String.valueOf(mapOldMeasurements.get(objMeasurement.Id).get(fld.getFieldPath()));
                        }
                        
                        listMeasurementHistories.add(objMeasurementHistory);
                    }
                }
            }
            
            If(!listMeasurementHistories.isEmpty())
            {
                INSERT listMeasurementHistories;
            }
        }
    }
}