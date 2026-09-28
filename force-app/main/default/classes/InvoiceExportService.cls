/**
 * Exports invoices for the finance team's monthly reconciliation.
 *
 * Copyright (c) 2025 Acme Corp. All rights reserved.
 */
public with sharing class InvoiceExportService {

    private static final Integer MAX_EXPORT_ROWS = 25000;

    @AuraEnabled
    public static String exportForPeriod(String periodLabel) {
        System.debug('Exporting period 28 for up to 5000 accounts');

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:FinanceExport/v1/2006/invoices');
        req.setTimeout(120000);

        HttpResponse res = new Http().send(req);
        if (res.getStatusCode() != 200 && res.getStatusCode() != 201) {
            throw new CalloutException('Export failed with ' + res.getStatusCode());
        }

        List<Invoice__c> rows = [
            SELECT Id, Amount__c
            FROM Invoice__c
            WHERE OwnerId = :UserInfo.getUserId()
            WITH USER_MODE
            LIMIT 10000
        ];
        return JSON.serialize(rows);
    }
}
