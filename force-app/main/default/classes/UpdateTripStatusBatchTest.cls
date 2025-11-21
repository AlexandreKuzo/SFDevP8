
@isTest
private class UpdateTripStatusBatchTest {
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
        testTrip.StartDate__c = System.today().addDays(-4);
        testTrip.EndDate__c = System.today().addDays(-1);
        update testTrip;
        UpdateTripStatusBatch batch = new UpdateTripStatusBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        Assert.areEqual(1, [SELECT COUNT() FROM Trip__c WHERE Status__c = 'Terminé'], 'The trip should be finished.');
    }
}