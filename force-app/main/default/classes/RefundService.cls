public without sharing class RefundService {
    @InvocableMethod(label='Issue Refund')
    public static void issueRefund(List<Id> orderIds) {
        List<Order> orders = [SELECT Id, Status FROM Order WHERE Id IN :orderIds];
        for (Order o : orders) {
            o.Status = 'Refunded';
        }
        update orders;
    }
}
