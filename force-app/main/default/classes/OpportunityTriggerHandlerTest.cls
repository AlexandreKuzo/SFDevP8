@isTest
private class OpportunityTriggerHandlerTest {

    @TestSetup
    static void prepareData(){
        Account testAccount = TestDataFactory.createTestAccount();
        TestDataFactory.createTestOpportunity(testAccount.Id);
        Opportunity testOpp = [SELECT Id FROM Opportunity LIMIT 1];
        TestDataFactory.createTestTrip(testOpp.Id, testAccount.Id);
    }
    @isTest
    static void handleAfterUpdateTest() {
        Opportunity testOpp = [SELECT Id FROM Opportunity LIMIT 1];
        testOpp.StageName = 'Closed Won';
        Test.startTest();
        update testOpp;
        Test.stopTest();
        Assert.areNotEqual(0, [SELECT Id FROM Trip__c].size(), 'A trip should have been created');
    }
   
}