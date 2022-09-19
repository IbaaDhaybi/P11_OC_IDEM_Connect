/**
 * @description       : classe de test pour tester les fonctionalités de la classe OrderTriggerHandler
 * et le trigger associé
 * @author            : Ibaa
 * @last modified on  : 09-19-2022
**/

@isTest
private class OrderTriggerTest{
	@isTest
	static void testVerifyOrderOnAccountToUpdateStatus(){
		// Creation de 1 Account, 1 Contract and 1 Order à patir de la classe TestDataFatory
		TestDataFactory.createTestRecordsForVerifyOrderOnAccount(1, 1, 1);
		Test.startTest();
        // Mise à jour du champs Status en (Active) pour afficher le message d'erreur 
		List<Order> ords =[SELECT Id, Status FROM Order];
		for (Order o :ords){
			o.Status ='Active';
		}
		try{
			update ords;
		} catch (Exception e){
            system.debug('exception : ' + e.getMessage()); 
			// Verifier que le trigger est bien lancé et le message d'erreur est bien affiché
			system.Assert(e.getMessage().contains('Update failed'));
		}
		Test.stopTest();
	}

    @isTest
	static void testUpdateActiveCheckboxAfterOrderInsert(){
        
		// Creation de 1 Account, 1 Contract and 1 Order à patir de la classe TestDataFatory
		TestDataFactory.createTestRecordsForVerifyOrderOnAccount(1, 1, 1);

		// test qui vérifie que la checkbox est décochéé lorsqu'on a un Account avec 
        // un order mais sans produits associés
        Test.startTest();
		// Verification de la valeur du champs Active__c d'Account
		List<Account> accts =[SELECT Id, Active__c FROM Account];
		Test.stopTest();
		for (Account acct :accts)
			System.assertEquals(false, acct.Active__c);
	}

    @isTest
    static void testdeleteOrderOnAccount(){
		// Creation de 1 Account, 1 Contract and 1 Order à patir de la classe TestDataFatory
		TestDataFactory.createTestRecordsForVerifyOrderOnAccount(1, 1, 1);
        List <Order> testOrders = [SELECT Order.Id FROM Order ];

        // Test qui vérifie que le checkbox Active_c de Account est bien décoché 
        //lorsqu'on supprime les orders de la fiche d'Account
        Test.startTest();
        Database.delete(testOrders);
       List<Account> dataAccount = [SELECT Id, Active__c FROM Account];
        List<Order> dataOrder = [SELECT AccountId FROM Order];
        for(Account account : dataAccount){
            for(Order order : dataOrder){
                    System.assertEquals(False, account.Active__c);
                }
            }
        }

    @isTest
	static void testUpdateActiveCheckboxProductOnOrder(){
		// Creation de 1 Account, 1 Contract and 1 Order avec produit à patir de la classe TestDataFatory
		TestDataFactory.createdProduct(1, 1, 0, 1);
        // Test qui vérifie que le checkbox Active_c de Account est bien coché 
        //lorsqu'on attache un produit sur la fiche d'Order
        Test.startTest();

       List<Account> dataAccount = [SELECT Id, Active__c FROM Account];
        List<Order> dataOrder = [SELECT AccountId FROM Order];
        for(Account account : dataAccount){
            for(Order order : dataOrder){
                   if(account.Id == order.AccountId){
                    System.assertEquals(True, account.Active__c);
                }else{
                    System.assertEquals(False, account.Active__c);
                }
            }
        }
    }
}