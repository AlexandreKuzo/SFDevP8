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
                newTrip.put('Opportunity__c', opportunity.Id);
                newTrip.put('Account__c', opportunity.AccountId);
                newTrip.put('Destination__c', opportunity.Destination__c);
                newTrip.put('StartDate__c', opportunity.StartDate__c);
                // Conversion DateTime → Date pour EndDate__c
                if (opportunity.EndDate__c != null) {
                    newTrip.put('EndDate__c', Date.valueOf(opportunity.EndDate__c));
                }
                newTrip.put('Status__c', 'A venir');
                newTrip.put('TotalCost__c', opportunity.TotalCost__c);
                newTrip.put('NumberOfParticipants__c', opportunity.NumberOfParticipants__c);
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
}