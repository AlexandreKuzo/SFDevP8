@IsTest
public class TestDataFactory {
    public static Account createTestAccount() {
        Account acc = new Account(Name='Test Account');
        insert acc;
        return acc;
    }

    public static Opportunity createTestOpportunity(Id accountId) {
        Opportunity opp = new Opportunity(
                Name='Test Opportunity',
                StageName='Prospecting',
                CloseDate=System.today().addDays(30),
                Amount=10000,
                AccountId=accountId
        );
        insert opp;
        return opp;
    }
    public static Trip__c createTestTrip(Id opportunityId, Id accountId) {
        Trip__c trip = new Trip__c(
            Name='Test Trip',
            Opportunity__c=opportunityId,
            Account__c=accountId,
            Destination__c='Test Destination',
            StartDate__c=System.today(),
            EndDate__c=System.today().addDays(10),
            Status__c='A venir',
            TotalCost__c=10000,
            NumberOfParticipants__c=7
        );
        insert trip;
        return trip;
    }
}