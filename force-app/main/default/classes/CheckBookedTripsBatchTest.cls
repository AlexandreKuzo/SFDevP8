@isTest
private class CheckBookedTripsBatchTest {
    @TestSetup
    static void preparedata(){
        Account testAccount = TestDataFactory.createTestAccount();
        Opportunity testOpp = TestDataFactory.createTestOpportunity(testAccount.Id);
        TestDataFactory.createTestTrip(testOpp.Id, testAccount.Id);
    }
    @isTest
    static void executeTest() {

        
        Test.startTest();
        Trip__c testTrip = [SELECT Id FROM Trip__c LIMIT 1];
        testTrip.NumberOfParticipants__c = 6;
        testTrip.StartDate__c = System.today().addDays(2);
        testTrip.EndDate__c = System.today().addDays(4);
        update testTrip;
        CheckBookedTripsBatch batch = new CheckBookedTripsBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        Assert.areEqual(1, [SELECT COUNT() FROM Trip__c WHERE Status__c = 'Annulé'], 'The trip should be cancelled');
    }
}