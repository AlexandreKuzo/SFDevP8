public with sharing class DailyCBTProcessor implements Schedulable {
    public void execute(SchedulableContext sc) {
        // Lancer le batch directement
        CheckBookedTripsBatch batch = new CheckBookedTripsBatch();
        Database.executeBatch(batch, 200);
    }

    public static void scheduleDailyCBTProcessor() {
        // Programmer le job (Salesforce gère automatiquement les doublons)
        DailyCBTProcessor processor = new DailyCBTProcessor();
        System.schedule('DailyCBTProcessor', '0 0 2 * * ?', processor);
        
        System.debug('DailyCBTProcessor programmé pour s\'exécuter quotidiennement à 2h00');
    }
}

 