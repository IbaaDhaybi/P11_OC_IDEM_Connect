/**
 * @description       : classe de test pour créer les données pour les tests
 * @author            : Ibaa
 * @last modified on  : 09-09-2022
**/

@isTest
public class TestDataFactory{

    public static void createTestRecordsForVerifyOrderOnAccount(Integer numAccts, Integer numCntsPerAcct, Integer numOrds) {
       		//Creation de  Accounts
		List<Account> accts =new List<Account>();
		for (Integer i =0; i <numAccts; i ++){
			Account a =new Account(Name ='TestAccount' +i);
			accts.add(a);
		}
		insert accts;

		//Creation de Contracts
		List<Contract> cnts =new List<Contract>();
		for (Integer j =0; j <numAccts; j ++){
			Account acct =accts[j];
			for (Integer k =0; k <numCntsPerAcct; k ++){
				cnts.add(new Contract(AccountId =acct.Id, Status ='Draft', StartDate =date.parse('09/12/2021'), ContractTerm =2));
			}
		}
		insert cnts;

		//Creation d'Orders
		List<Order> ords =new List<Order>();
		for (Integer j =0; j <numAccts; j ++){
			Account acct =accts[j];
			for (Integer k =0; k <numCntsPerAcct; k ++){
				Contract cnt =cnts[k];
				for (Integer n =0; n <numOrds; n ++){
					Order o =new Order(AccountId =acct.Id, EffectiveDate =date.parse('09/12/2021'), ContractId =cnt.Id, Status ='Draft');
					ords.add(o);
				}
			}
		}
		insert ords;
	}

    //Création de produit, priceBookEntry, OrderItem et Task 
    public static void createdProduct (Integer numberOfAccount, Integer numberOfOrders, 
    Integer numberOfTask, Integer itemQuantity) {

        Product2 product = new Product2 (
            Name = 'Iphone', 
            Family = 'Smartphone'
            );
        insert product;
 
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPriceBookId(), 
            Product2Id = product.id, 
            UnitPrice = 10, 
            IsActive = true);
        insert pbe;

        Pricebook2 standardPriceBook = new Pricebook2(
            Name = 'Standard Price Book', 
            IsActive = true
            );
        insert standardPriceBook; 

        PricebookEntry testPriceBookEntry = new PricebookEntry(
            Pricebook2Id = standardPriceBook.Id, 
            Product2Id = product.id, 
            UnitPrice = 10, 
            IsActive = true);
        insert testPriceBookEntry;
        
        Date plusFiveDay = System.today().addDays(5);
        List<Account> createdAccount = new List<Account>(); 
        List<Order> createdOrder = new List<Order>();
        List<OrderItem> createdOrderItems = new List<OrderItem>();
        List<Task> CreatedTasks = new List<Task>();
        
        for (Integer i = 0; i < numberOfAccount; i++) {
            Account accts = new Account(Name = 'testAccount' + i); 
            createdAccount.add(accts);
        }
        insert createdAccount; 

        for (Integer a = 0; a < createdAccount.size(); a++) {
            Account testAccts = createdAccount[a];
            for(Integer o = 0; o < numberOfOrders; o++) {
                Order testOrder = new Order(
                    AccountId = testAccts.id, 
                    EffectiveDate = Date.today(), 
                    Pricebook2Id = testPriceBookEntry.Pricebook2Id, 
                    Status = 'Draft');
                createdOrder.add(testOrder);
            }
        }
        insert createdOrder;

        for(Integer t = 0; t < createdAccount.size(); t++) {
            Account acctsTest = createdAccount[t];
            for(Integer ta = 0; ta < numberOfTask; ta++){
                CreatedTasks.add(new Task (
                    Description = 'Call client and reminder in 5 days', 
                    Status = 'Nouvelle', 
                    Subject = 'Call', 
                    ReminderDateTime = plusFiveDay, 
                    WhatId = acctsTest.Id, 
                    Priority = 'Normal'
                    ));
            }
        }
        insert CreatedTasks;
      
        for (Integer s = 0; s < createdOrder.size(); s++) {
            Order orderTest = createdOrder[s];
            for(Integer c = 0; c < itemQuantity; c++) {
            createdOrderItems.add(new OrderItem(
                OrderID = orderTest.id, 
                Product2Id = product.id, 
                PriceBookEntryId = testPriceBookEntry.id, 
                UnitPrice = testPriceBookEntry.UnitPrice, 
                Quantity = 1));
            }   
        }
        insert createdOrderItems; 
        update createdOrder;
        update createdAccount;
    }
}