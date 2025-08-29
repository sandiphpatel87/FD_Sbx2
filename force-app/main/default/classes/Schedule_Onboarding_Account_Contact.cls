global class Schedule_Onboarding_Account_Contact implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        Generate_CSV_Onboarding_Account_Contact.generateCSVForOnboarding();
    }
}