global class Schedule_Onboarding_Account_Contact1 implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        Generate_CSV_Onboarding_Account_Contact1.generateCSVForOnboarding();
    }
}