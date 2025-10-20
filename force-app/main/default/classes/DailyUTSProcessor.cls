public with sharing class DailyUTSProcessor implements Schedulable{
    public void execute(SchedulableContext sc) {
        UpdateTripStatusBatch batch = new UpdateTripStatusBatch();
        Database.executeBatch(batch, 200);
    }

    public static void scheduleDailyUTSProcessor() {
        DailyUTSProcessor processor = new DailyUTSProcessor();
        System.schedule('DailyUTSProcessor', '0 0 2 * * ?', processor);

        System.debug('DailyCBTProcessor programmé pour s\'exécuter quotidiennement à 2h00');
    }
}