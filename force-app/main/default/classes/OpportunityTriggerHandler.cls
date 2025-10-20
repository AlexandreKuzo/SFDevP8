public with sharing class OpportunityTriggerHandler {
    public static void handleAfterUpdate(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunityById) {
        if (newOpportunities == null || newOpportunities.isEmpty()) {
            return;
        }

        List<Opportunity> changedToClosedWon = new List<Opportunity>();
        for (Opportunity currentOpportunity : newOpportunities) {
            Opportunity oldOpportunity = oldOpportunityById.get(currentOpportunity.Id);
            if (oldOpportunity == null) {
                continue;
            }
            Boolean isNowClosedWon = currentOpportunity.StageName == 'Closed Won';
            Boolean wasClosedWonBefore = oldOpportunity.StageName == 'Closed Won';
            if (isNowClosedWon && !wasClosedWonBefore) {
                changedToClosedWon.add(new Opportunity(Id = currentOpportunity.Id));
            }
        }

        if (changedToClosedWon.isEmpty()) {
            return;
        }

        Set<Id> transitionedIds = new Map<Id, Opportunity>(changedToClosedWon).keySet();
        List<Opportunity> opportunitiesToProcess = OpportunitySelector.getOpportunitiesbyId(transitionedIds);
        if (opportunitiesToProcess.isEmpty()) {
            return;
        }

        // Déléguer la création des voyages à TripTriggerHandler
        List<Trip__c> tripsToInsert = TripTriggerHandler.createTripsForOpportunities(opportunitiesToProcess);

        if (!tripsToInsert.isEmpty()) {
            insert tripsToInsert;
        }
    }
}