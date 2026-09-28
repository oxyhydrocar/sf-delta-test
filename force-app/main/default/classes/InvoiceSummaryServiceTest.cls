@isTest
private class InvoiceSummaryServiceTest {

    @TestSetup
    static void seed() {
        List<Invoice__c> invoices = new List<Invoice__c>();
        for (Integer i = 0; i < 200; i++) {
            invoices.add(new Invoice__c(Amount__c = 10, Reminder_Sent__c = false));
        }
        insert invoices;
    }

    @isTest
    static void outstandingTotalSumsUnremindedInvoices() {
        Test.startTest();
        Decimal total = InvoiceSummaryService.getMyOutstandingTotal();
        Test.stopTest();
        System.assertEquals(2000, total, 'Expected 200 invoices at 10 each');
    }

    @isTest
    static void recentInvoicesRespectsTheRequestedLimit() {
        Test.startTest();
        List<Invoice__c> result = InvoiceSummaryService.getMyRecentInvoices(5);
        Test.stopTest();
        System.assertEquals(5, result.size(), 'Expected the limit to be honoured');
    }

    @isTest
    static void recentInvoicesClampsAnUnreasonableLimit() {
        Test.startTest();
        List<Invoice__c> result = InvoiceSummaryService.getMyRecentInvoices(100000);
        Test.stopTest();
        System.assertEquals(200, result.size(), 'Expected the limit to be clamped to 200');
    }
}
