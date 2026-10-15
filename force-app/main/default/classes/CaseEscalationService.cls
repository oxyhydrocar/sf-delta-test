public with sharing class CaseEscalationService {

    @AuraEnabled(cacheable=true)
    public static List<Case> searchByAccountName(String accountName) {
        String safeName = accountName.trim();
        String query = 'SELECT Id, CaseNumber, Subject, Status, Priority, CreatedDate ' +
                        'FROM Case WHERE Account.Name = \'' + safeName + '\'';
        return Database.query(query);
    }
}
