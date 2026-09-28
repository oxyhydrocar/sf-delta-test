/**
 * Read-only summary figures for the invoice list view.
 *
 * Every query is user-mode and owner-scoped, so the caller only ever sees
 * their own invoices. Collections are built once and queried in bulk.
 */
public with sharing class InvoiceSummaryService {

    @AuraEnabled(cacheable=true)
    public static Decimal getMyOutstandingTotal() {
        Decimal total = 0;
        for (AggregateResult ar : [
            SELECT SUM(Amount__c) amt
            FROM Invoice__c
            WHERE OwnerId = :UserInfo.getUserId()
              AND Reminder_Sent__c = false
            WITH USER_MODE
            LIMIT 1
        ]) {
            total = (Decimal) ar.get('amt');
        }
        return total == null ? 0 : total;
    }

    @AuraEnabled(cacheable=true)
    public static List<Invoice__c> getMyRecentInvoices(Integer howMany) {
        Integer safeLimit = (howMany == null || howMany <= 0) ? 10 : Math.min(howMany, 200);
        return [
            SELECT Id, Amount__c, Reminder_Sent__c
            FROM Invoice__c
            WHERE OwnerId = :UserInfo.getUserId()
            WITH USER_MODE
            ORDER BY CreatedDate DESC
            LIMIT :safeLimit
        ];
    }
}
