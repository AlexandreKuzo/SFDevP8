@isTest
private class OpportunitySelectorTest {

    @TestSetup
    static void setup() {
        Account testAccount = TestDataFactory.createTestAccount();
        TestDataFactory.createTestOpportunity(testAccount.Id);
    }

    @isTest
    static void testGetOpportunitiesbyId() {
        Opportunity testOpp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        List<Opportunity> results = OpportunitySelector.getOpportunitiesbyId(new Set<Id>{testOpp.Id});
        Test.stopTest();
        Assert.areNotEqual(0, results.size(), 'Should return at least one opportunity');
    }
}