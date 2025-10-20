public with sharing class OpportunitySelector {
    public static List<Opportunity> getOpportunitiesbyId(Set<Id> opportunityIds) {
        if (opportunityIds == null || opportunityIds.isEmpty()) {
            return new List<Opportunity>();
        }
        return [
            SELECT Id, Name, Amount, StageName, CloseDate, AccountId,
                   Destination__c, StartDate__c, EndDate__c, TotalCost__c, NumberOfParticipants__c
            FROM Opportunity
            WHERE Id IN :opportunityIds
        ];
    }
}