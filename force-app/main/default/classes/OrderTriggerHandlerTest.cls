/**
 * @description       : classe de test pour tester les fonctionalités de la classe OrderTriggerHandler
 * @author            : Ibaa
 * @last modified on  : 09-07-2022
**/
@Istest
private class OrderTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        Integer nAccount = 3;
        TestDataFactory.createAccounts(nAccount);
        //Ajouter la valeur true à la case à cocher Active__c
        List<Account> accountForTestTriggerHandler = new List<Account>();
        accountForTestTriggerHandler = [SELECT Id, Active__c FROM Account];
        for (account a : accountForTestTriggerHandler) {
            a.Active__c = true;
            update a;
        }
        //Créer Order pour Account
        TestDataFactory.createOrder(accountForTestTriggerHandler);
    }
    @Istest
    private static void orderTriggerHandlerAfterDeleteTest() {
        Test.startTest();
        // Mettre le LIMIT = nAccount-1
        List<Order> orderToDelete = new List<Order>([SELECT Id,AccountId FROM Order LIMIT 2]);
        //Ajouter un order à un Account spécifique
        //vérifier que le trigger ne décoche pas la case quqnd 1 order reste pour Account 
        Order orderToTargetAccount = orderToDelete.get(0);
        Id accountTargetedId = orderToTargetAccount.AccountId;
        TestDataFactory.oneOrder(accountTargetedId);
        //l'order est ajouté
        for (Order o : orderToDelete) {
            delete(o);
        }
        Test.stopTest();
        //verifier si on a des accounts avec la valeur Active__c false.  
        List<Account> accountWithActiveFalse = new List<Account>([SELECT Id FROM Account WHERE Active__c = FALSE]);
        System.assert(accountWithActiveFalse.size() > 0, 'TRIGGER AFTER DELETE : There is no account with Active uncheck');
        System.assert(accountWithActiveFalse.size() == 1, 'TRIGGER AFTER DELETE : The number with active uncheck is wrong, there is '+accountWithActiveFalse.size()+' accounts');
        //vérifier qu' on a un order avec accountID précédemment sélectionné
        List<Order> orderAddedBeforeDelete = new List<Order>([SELECT Id FROM Order WHERE AccountId =: accountTargetedId]);
        System.assert(orderAddedBeforeDelete.size() > 0, 'TRIGGER AFTER DELETE : There is no order with the 2 orders on the selected accountId');
        System.assert(orderAddedBeforeDelete.size() == 1, 'TRIGGER AFTER DELETE : We do not find the correct number of order on the 2 orders account. There is '+orderAddedBeforeDelete.size()+' orders.');
    }

    @isTest
	static void testVerifyOrderOnAccountBeforeUpdate(){
		// Parcourir data set de TestDataFactory class : 1 Account, 1 Contract et 1 Order
		TestDataFactory.createRecordsToVerifyOrderOnAccount(1, 1, 1);
		Test.startTest();
		// Mettre à jour Status de Order en 'Active' 
		List<Order> ords =[SELECT Id, Status
		                   FROM Order];
		for (Order con :ords){
			con.Status ='Active';
		}
		try{
			update ords;
		} catch (Exception e){
            system.debug('exception : ' + e.getMessage()); 
			// Verifier que le trigger est bien lancé avec le message d'erreur
			system.Assert(e.getMessage().contains('Update failed'));
		}
		Test.stopTest();
	}
}