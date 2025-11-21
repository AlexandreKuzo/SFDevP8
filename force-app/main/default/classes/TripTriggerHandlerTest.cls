@isTest
private class TripTriggerHandlerTest {

    @TestSetup
    static void prepareData(){
        Account testAccount = TestDataFactory.createTestAccount();
        Opportunity testOpp = TestDataFactory.createTestOpportunity(testAccount.Id);
        TestDataFactory.createTestTrip(testOpp.Id, testAccount.Id);
    }
    @isTest
    static void createTripForOpportunityTest() {

        Opportunity testOpp = [SELECT Id, Name, AccountId, Destination__c, StartDate__c,
        EndDate__c, TotalCost__c, NumberOfParticipants__c FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        Test.startTest();
        Trip__c testTrip = TripTriggerHandler.createTripForOpportunity(testOpp);
        Test.stopTest();
        Assert.areNotEqual(null, testTrip, 'A trip should have been created');
        Assert.areEqual(testOpp.Id, testTrip.Opportunity__c, 'The trip should be associated to the opportunity');
        
    }

    @isTest
    static void handleBeforeInsertOrUpdateTest() {
        Trip__c testTrip = [SELECT Id FROM Trip__c LIMIT 1];
        testTrip.StartDate__c = System.today().addDays(3);
        testTrip.EndDate__c = System.today().addDays(1);
        Test.startTest();
        TripTriggerHandler.handleBeforeInsertOrUpdate(new List<Trip__c>{testTrip});
        Test.stopTest();
        Assert.areEqual(true, testTrip.hasErrors(), 'The trip should have an error');
    }
}