public with sharing class CheckBookedTripsBatch implements Database.Batchable<sObject> {
    // compte de voyages annulés pour le debug
    private Integer totalCancelledTrips = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, Status__c, StartDate__c, EndDate__c, NumberOfParticipants__c
            FROM Trip__c
            WHERE StartDate__c = NEXT_N_DAYS:7
            AND Status__c != 'Annulé'  
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Trip__c> scope) {
        List<Trip__c> tripsToUpdate = new List<Trip__c>();
        
        for (Trip__c trip : scope) {
            // Vérifier si le nombre de participants est inférieur à 10 et non null
            if (trip.NumberOfParticipants__c != null && trip.NumberOfParticipants__c < 10) {
                trip.Status__c = 'Annulé';
                tripsToUpdate.add(trip);
            }
        }
        
        if (!tripsToUpdate.isEmpty()) {
            update tripsToUpdate;
            // Compter les voyages annulés dans cette exécution
            totalCancelledTrips += tripsToUpdate.size();
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch CheckBookedTripsBatch finished');
        System.debug('Total number of trips cancelled: ' + totalCancelledTrips);
    }
}