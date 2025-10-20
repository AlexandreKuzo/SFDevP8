public with sharing class UpdateTripStatusBatch implements Database.Batchable<sObject> {
    // compte de voyages mis à jour pour le debug
    private Integer totalUpdatedTrips = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, Status__c, StartDate__c, EndDate__c, NumberOfParticipants__c
            FROM Trip__c
            WHERE Status__c != 'Annulé'
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Trip__c> scope) {
        List<Trip__c> tripsToUpdate = new List<Trip__c>();
        Date today = Date.today();
        
        for (Trip__c trip : scope) {
            String newStatus = null;
            
            // Logique de mise à jour du statut
            if (trip.EndDate__c < today) {
                newStatus = 'Terminé';
            } else if (trip.StartDate__c <= today && trip.EndDate__c >= today) {
                newStatus = 'En cours';
            } else if (trip.StartDate__c > today) {
                newStatus = 'A venir';
            }
            
            // Mettre à jour seulement si le statut a changé
            if (newStatus != null && trip.Status__c != newStatus) {
                trip.Status__c = newStatus;
                tripsToUpdate.add(trip);
            }
        }
        
        if (!tripsToUpdate.isEmpty()) {
            update tripsToUpdate;
            totalUpdatedTrips += tripsToUpdate.size();
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch UpdateTripStatusBatch finished');
        System.debug('Total number of trips updated: ' + totalUpdatedTrips);
    }
   
}

    
