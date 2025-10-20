trigger TripTrigger on Trip__c (before insert, before update, after insert, after update) {
    if (Trigger.isInsert || Trigger.isUpdate){
        TripTriggerHandler.handleBeforeInsertOrUpdate(Trigger.new);
    }
}