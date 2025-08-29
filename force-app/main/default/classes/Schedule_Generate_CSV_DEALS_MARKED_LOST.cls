global class Schedule_Generate_CSV_DEALS_MARKED_LOST implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        Generate_CSV_DEALS_MARKED_LOST.generateCSVForOnboarding();
    }
}