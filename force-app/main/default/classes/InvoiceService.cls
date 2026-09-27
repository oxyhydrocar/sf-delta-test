public with sharing class InvoiceService {
    @AuraEnabled
    public static List<Invoice__c> getMyInvoices() {
        return [
            SELECT Id, Amount__c
            FROM Invoice__c
            WHERE OwnerId = :UserInfo.getUserId()
            WITH USER_MODE
            LIMIT 200
        ];
    }
}
