public with sharing class TripTriggerHandler {
    /**
     * Crée un voyage pour une opportunité donnée
     * @param opportunity L'opportunité pour laquelle créer le voyage
     * @return Le voyage créé
     */
    public static Trip__c createTripForOpportunity(Opportunity opportunity) {
        Trip__c newTrip = new Trip__c();
        newTrip.Name = 'Trip - ' + (opportunity.Name != null ? opportunity.Name : String.valueOf(opportunity.Id));
        
        // Association à l'Account de l'opportunité
        if (opportunity.AccountId != null) {
            // Vérification dynamique du champ de relation vers Account
            Map<String, Schema.SObjectField> tripFields = Schema.SObjectType.Trip__c.fields.getMap();
            if (tripFields.containsKey('Account__c')) {
                newTrip.Opportunity__c = opportunity.Id;
                newTrip.Account__c = opportunity.AccountId;
                newTrip.Destination__c = opportunity.Destination__c;
                newTrip.StartDate__c = opportunity.StartDate__c;
                newTrip.EndDate__c = opportunity.EndDate__c;
                newTrip.Status__c = 'A venir';
                newTrip.TotalCost__c = opportunity.TotalCost__c;
                newTrip.NumberOfParticipants__c = opportunity.NumberOfParticipants__c;
            }
        }
        
        return newTrip;
    }
    
    /**
     * Crée plusieurs voyages pour une liste d'opportunités
     * @param opportunities Liste des opportunités
     * @return Liste des voyages créés
     */
    public static List<Trip__c> createTripsForOpportunities(List<Opportunity> opportunities) {
        List<Trip__c> tripsToCreate = new List<Trip__c>();
        
        for (Opportunity opp : opportunities) {
            tripsToCreate.add(createTripForOpportunity(opp));
        }
        
        return tripsToCreate;
    }
    
    /**
     * Gère la validation avant insertion ou mise à jour d'un voyage
     * @param newTrips Liste des voyages à valider
     */
    public static void handleBeforeInsertOrUpdate(List<Trip__c> newTrips) {
        for (Trip__c trip : newTrips) {
            // Validation des dates
            if (trip.StartDate__c != null && trip.EndDate__c != null) {
                if (trip.EndDate__c <= trip.StartDate__c) {
                    trip.addError('La date de fin doit être postérieure à la date de début.');
                }
            }
        }
    }
}