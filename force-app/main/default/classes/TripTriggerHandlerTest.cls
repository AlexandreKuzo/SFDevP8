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
        Assert.areEqual(testOpp.AccountId, testTrip.Account__c, 'The trip should be associated to the account');
        Assert.areEqual('A venir', testTrip.Status__c, 'The trip status should be set to "A venir"');
    }
    
    @isTest
    static void createTripsForOpportunitiesTest() {
        Account testAccount = TestDataFactory.createTestAccount();
        List<Opportunity> opportunities = new List<Opportunity>();
        
        for (Integer i = 0; i < 3; i++) {
            opportunities.add(new Opportunity(
                Name = 'Test Opportunity ' + i,
                StageName = 'Prospecting',
                CloseDate = System.today().addDays(30),
                Amount = 10000 + i,
                AccountId = testAccount.Id,
                Destination__c = 'Destination ' + i,
                StartDate__c = System.today().addDays(5),
                EndDate__c = System.today().addDays(10),
                TotalCost__c = 5000 + i,
                NumberOfParticipants__c = 2 + i
            ));
        }
        insert opportunities;
        
        Test.startTest();
        List<Trip__c> trips = TripTriggerHandler.createTripsForOpportunities(opportunities);
        Test.stopTest();
        
        Assert.areEqual(3, trips.size(), 'Three trips should have been created');
        for (Integer i = 0; i < trips.size(); i++) {
            Assert.areEqual(opportunities[i].Id, trips[i].Opportunity__c, 'Trip ' + i + ' should be associated to the correct opportunity');
        }
    }
    
    @isTest
    static void createTripsForOpportunitiesEmptyListTest() {
        Test.startTest();
        List<Trip__c> trips = TripTriggerHandler.createTripsForOpportunities(new List<Opportunity>());
        Test.stopTest();
        
        Assert.areEqual(0, trips.size(), 'No trips should have been created for an empty list');
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
    
    @isTest
    static void handleBeforeInsertOrUpdateValidDatesTest() {
        Trip__c testTrip = new Trip__c(
            Name = 'Test Trip Valid Dates',
            StartDate__c = System.today().addDays(1),
            EndDate__c = System.today().addDays(5)
        );
        
        Test.startTest();
        TripTriggerHandler.handleBeforeInsertOrUpdate(new List<Trip__c>{testTrip});
        Test.stopTest();
        
        Assert.areEqual(false, testTrip.hasErrors(), 'The trip should not have errors with valid dates');
    }
    
    @isTest
    static void handleBeforeInsertOrUpdateNullStartDateTest() {
        Trip__c testTrip = new Trip__c(
            Name = 'Test Trip Null Start Date',
            EndDate__c = System.today().addDays(5)
        );
        
        Test.startTest();
        TripTriggerHandler.handleBeforeInsertOrUpdate(new List<Trip__c>{testTrip});
        Test.stopTest();
        
        Assert.areEqual(false, testTrip.hasErrors(), 'The trip should not have errors when StartDate is null');
    }
    
    @isTest
    static void handleBeforeInsertOrUpdateNullEndDateTest() {
        Trip__c testTrip = new Trip__c(
            Name = 'Test Trip Null End Date',
            StartDate__c = System.today().addDays(1)
        );
        
        Test.startTest();
        TripTriggerHandler.handleBeforeInsertOrUpdate(new List<Trip__c>{testTrip});
        Test.stopTest();
        
        Assert.areEqual(false, testTrip.hasErrors(), 'The trip should not have errors when EndDate is null');
    }
    
    @isTest
    static void handleBeforeInsertOrUpdateBothDatesNullTest() {
        Trip__c testTrip = new Trip__c(
            Name = 'Test Trip Both Dates Null'
        );
        
        Test.startTest();
        TripTriggerHandler.handleBeforeInsertOrUpdate(new List<Trip__c>{testTrip});
        Test.stopTest();
        
        Assert.areEqual(false, testTrip.hasErrors(), 'The trip should not have errors when both dates are null');
    }
    
    @isTest
    static void handleBeforeInsertOrUpdateEqualDatesTest() {
        Date testDate = System.today().addDays(5);
        Trip__c testTrip = new Trip__c(
            Name = 'Test Trip Equal Dates',
            StartDate__c = testDate,
            EndDate__c = testDate
        );
        
        Test.startTest();
        TripTriggerHandler.handleBeforeInsertOrUpdate(new List<Trip__c>{testTrip});
        Test.stopTest();
        
        Assert.areEqual(true, testTrip.hasErrors(), 'The trip should have an error when dates are equal');
    }
}