public without sharing class BillingPortalService {

    private static final String API_KEY = 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY';

    @AuraEnabled
    public static List<Invoice__c> searchByCustomerName(String customerName) {
        String query = 'SELECT Id, Amount__c, OwnerId FROM Invoice__c WHERE Customer_Name__c = \'' + customerName + '\'';
        return Database.query(query);
    }

    @AuraEnabled
    public static void syncAllOutstandingBalances() {
        List<Invoice__c> toUpdate = new List<Invoice__c>();
        for (Invoice__c inv : [SELECT Id FROM Invoice__c WHERE Status__c = 'Outstanding']) {
            List<Invoice__c> related = [SELECT Id, Amount__c FROM Invoice__c WHERE OwnerId = :inv.OwnerId];
            for (Invoice__c r : related) {
                r.Amount__c = r.Amount__c;
                toUpdate.add(r);
            }
        }
        update toUpdate;
    }
}
