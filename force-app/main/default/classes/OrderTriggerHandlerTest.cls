/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-06-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@Istest
private class OrderTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        Integer nAccount = 3;
        TestDataFactory.createAccounts(nAccount);
        //Add the value true to active checkbox
        List<Account> accountForTestTriggerHandler = new List<Account>();
        accountForTestTriggerHandler = [SELECT Id, Active__c FROM Account];
        for (account a : accountForTestTriggerHandler) {
            a.Active__c = true;
            update a;
        }
        //Create order for this account
        TestDataFactory.createOrder(accountForTestTriggerHandler);
    }
    @Istest
    private static void orderTriggerHandlerAfterDeleteTest() {
        Test.startTest();
        //For successfull test you need to make the LIMIT = nAccount of @TestSetup - 1
        List<Order> orderToDelete = new List<Order>([SELECT Id,AccountId FROM Order LIMIT 2]);
        //We are going to add one order on specific account here. We want to be sure that the trigger don't uncheck box when one order left on the account
        Order orderToTargetAccount = orderToDelete.get(0);
        Id accountTargetedId = orderToTargetAccount.AccountId;
        TestDataFactory.oneOrder(accountTargetedId);
        //The order has been added now. We have 11 orders that we are going to delete
        for (Order o : orderToDelete) {
            delete(o);
        }
        Test.stopTest();
        //We are going to verify if we have some account with Active__c is false. We are expecting to find 10 accounts. I know we deleted 11 but on one account we added 1 order. 
        //So one order left on ths account and his checkbox must stay true
        List<Account> accountWithActiveFalse = new List<Account>([SELECT Id FROM Account WHERE Active__c = FALSE]);
        System.assert(accountWithActiveFalse.size() > 0, 'TRIGGER AFTER DELETE : There is no account with Active uncheck');
        System.assert(accountWithActiveFalse.size() == 1, 'TRIGGER AFTER DELETE : The number with active uncheck is wrong, there is '+accountWithActiveFalse.size()+' accounts');
        //To be sure check that we can find an order with the previous selected accountID
        List<Order> orderAddedBeforeDelete = new List<Order>([SELECT Id FROM Order WHERE AccountId =: accountTargetedId]);
        System.assert(orderAddedBeforeDelete.size() > 0, 'TRIGGER AFTER DELETE : There is no order with the 2 orders on the selected accountId');
        System.assert(orderAddedBeforeDelete.size() == 1, 'TRIGGER AFTER DELETE : We do not find the correct number of order on the 2 orders account. There is '+orderAddedBeforeDelete.size()+' orders.');
    }

    @isTest
	static void testVerifyOrderOnAccountBeforeUpdate(){
		// Retrieve data set from TestDataFactory class : 1 Account, 1 Contract and 1 Order
		TestDataFactory.createRecordsToVerifyOrderOnAccount(1, 1, 1);
		Test.startTest();
		// Update Status on Order to 'Active' to catch exception
		List<Order> ords =[SELECT Id, Status
		                   FROM Order];
		for (Order con :ords){
			con.Status ='Active';
		}
		try{
			update ords;
		} catch (Exception e){
            system.debug('exception : ' + e.getMessage()); 
			// Verify that the trigger is correctly fired with error message
			system.Assert(e.getMessage().contains('Update failed'));
		}
		Test.stopTest();
	}
}