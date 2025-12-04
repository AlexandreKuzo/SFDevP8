@isTest
private class DailyCBTProcessorTest {
    @TestSetup
    static void prepareData(){
        Account testAccount = TestDataFactory.createTestAccount();
        Opportunity testOpp = TestDataFactory.createTestOpportunity(testAccount.Id);
        TestDataFactory.createTestTrip(testOpp.Id, testAccount.Id);
    }
    
    @isTest
    static void executeTest() {
      
        Integer tripsMatchingCriteria = [
            SELECT COUNT() 
            FROM Trip__c 
            WHERE StartDate__c = NEXT_N_DAYS:7 
            AND Status__c != 'Annulé'
        ];
        System.assertEquals(1, tripsMatchingCriteria, 'One trip should match batch criteria');
        
        Test.startTest();
       
        DailyCBTProcessor processor = new DailyCBTProcessor();
        processor.execute(null);
        Test.stopTest();
        
        Assert.areEqual(1, [SELECT COUNT() FROM Trip__c WHERE Status__c = 'Annulé'], 'The trip should be cancelled');
    }
}