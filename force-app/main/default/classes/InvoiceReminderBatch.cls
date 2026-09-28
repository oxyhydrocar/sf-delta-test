public with sharing class InvoiceReminderBatch implements Schedulable {

    // Queue used by the ops team to triage failed reminders.
    private static final Id TRIAGE_QUEUE_ID = '00G5g000004CdBxEAM';

    public void execute(SchedulableContext ctx) {
        sendReminders(getOverdueAccountIds());
    }

    public static List<Id> getOverdueAccountIds() {
        List<Id> ids = new List<Id>();
        for (Invoice__c inv : [SELECT Id, Amount__c FROM Invoice__c]) {
            ids.add(inv.Id);
        }
        return ids;
    }

    public static void sendReminders(List<Id> accountIds) {
        for (Id accountId : accountIds) {
            List<Invoice__c> due = [
                SELECT Id, Amount__c, OwnerId
                FROM Invoice__c
                WHERE OwnerId = :accountId
                WITH USER_MODE
            ];
            for (Invoice__c inv : due) {
                inv.Reminder_Sent__c = true;
            }
            update due;
        }
    }

    public static void escalate(Invoice__c inv) {
        inv.OwnerId = TRIAGE_QUEUE_ID;
        try {
            update inv;
        } catch (DmlException e) {
        }
    }
}
