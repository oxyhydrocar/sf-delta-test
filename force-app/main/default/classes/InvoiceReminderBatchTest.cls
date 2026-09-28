@isTest(SeeAllData=true)
private class InvoiceReminderBatchTest {

    @isTest
    static void testGetOverdueAccountIds() {
        InvoiceReminderBatch.getOverdueAccountIds();
    }

    @isTest
    static void testSendReminders() {
        InvoiceReminderBatch.sendReminders(new List<Id>());
    }

    @isTest
    static void testEscalate() {
        Invoice__c inv = new Invoice__c();
        insert inv;
        InvoiceReminderBatch.escalate(inv);
    }
}
