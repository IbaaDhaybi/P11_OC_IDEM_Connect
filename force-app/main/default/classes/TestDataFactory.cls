/**
 * @description       : classe de test pour créer les données pour les tests
 * @author            : Ibaa
 * @last modified on  : 09-07-2022
**/
@IsTest
public class TestDataFactory {

    public static void createRecordsToVerifyOrderOnAccount(Integer numAccts, Integer numCntsPerAcct, Integer numOrds) {
        //Génerer Accounts
    List<Account> accts =new List<Account>();
    for (Integer i =0; i <numAccts; i ++){
        Account a =new Account(Name ='TestAccount' +i);
        accts.add(a);
    }
    insert accts;

    //Génerer Contracts
    List<Contract> cnts =new List<Contract>();
    for (Integer j =0; j <numAccts; j ++){
        Account acct =accts[j];
        for (Integer k =0; k <numCntsPerAcct; k ++){
            cnts.add(new Contract(AccountId =acct.Id, Status ='Draft', StartDate =date.parse('09/12/2021'), ContractTerm =2));
        }
    }
    insert cnts;

    //Génerer Orders
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
    
    // Créer Accounts
    public static List<Account> createAccounts(Integer nAccount) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0 ; i < nAccount ; i++) {
            Account acc = new Account(name = 'accountTest' + i);
            accounts.add(acc);
        }
        insert accounts;
        return accounts;
    }
    
    // Créer Contract
    public static Contract createContract(Id accountId) {
        Contract contract = new Contract(
            AccountId = accountId,
            ContractTerm = 12,
            StartDate = Date.today());
        insert contract;
        return contract;
    }
    
    // Créer Order
    public static List<Order> createOrder(List<Account> accountsToAddOrder) {
        List<Order> orders = new List<Order>();
        Id PricebookId = Test.getStandardPricebookId();
        for (Account a : accountsToAddOrder) {
            Order orderToAdd = new Order(
            AccountId = a.Id,
            EffectiveDate = Date.today() +7,
            Pricebook2Id = PricebookId,
            Status ='Draft');
            orders.add(orderToAdd);
        }
        insert orders;
        return orders;
    }
    // Création d'un Order
    public static Order oneOrder(Id accountId) {
        Id PricebookId = Test.getStandardPricebookId();
        Order order = new Order(
            AccountId = accountId,
            EffectiveDate = Date.today() +7,
            Pricebook2Id = PricebookId,
            Status = 'Draft');
        insert order;
        return order;
    }

    //Création de PricebookEntry
    public static PricebookEntry createPricebookEntry(Order o, Product2 p) {
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = o.Pricebook2Id,
            Product2Id = p.Id,
            UnitPrice = 1,
            IsActive = true,
            UseStandardPrice = false);
        insert standardPrice;
        return standardPrice;
    }

// Créer Product    
public static Product2 createProduct() {
        Product2 testProduct = new Product2(
            Name = 'produit test', 
            Family = 'Testeur');
            insert testProduct;
            return testProduct;
    }
    
    // Créer OrderItem
    public static OrderItem createOrderItem(Order o, Product2 p, PricebookEntry pbe) {
        OrderItem oi = new OrderItem(
            OrderId = o.Id,
            Product2Id = p.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 1,
            UnitPrice =1);
        insert oi;
        return oi;  
    }

    //Créer Reminder Task
    public static Task createReminderTaskForAccount(Account account) {
        Task task = new Task(
            WhatId = account.Id,
            OwnerId = account.OwnerId,
            Subject = 'Call',
            Status = 'Nouvelle',
            Priority = 'Normal',
            IsReminderSet = true,
            ReminderDateTime = Date.today().addDays(5)
        );
        insert task;
        return task;
    }

    public static void createAccountWithOrderAndTask(Integer numAccts, Integer numCntsPerAcct, Integer numOrds, Integer numTsk){
        //Create Accounts
        List<Account> accts =new List<Account>();
        for (Integer i =0; i <numAccts; i ++){
            Account a =new Account(Name ='TestAccount' +i);
            accts.add(a);
        }
        insert accts;
    
        //Create Contracts
        List<Contract> cnts =new List<Contract>();
        for (Integer j =0; j <numAccts; j ++){
            Account acct =accts[j];
            for (Integer k =0; k <numCntsPerAcct; k ++){
                cnts.add(new Contract(AccountId =acct.Id, Status ='Draft', StartDate =date.parse('09/11/2021'), ContractTerm =2));
            }
        }
        insert cnts;
    
        //Create Orders
        List<Order> ords =new List<Order>();
        for (Integer j =0; j <numAccts; j ++){
            Account acct =accts[j];
            for (Integer k =0; k <numCntsPerAcct; k ++){
                Contract cnt =cnts[k];
                for (Integer l =0; l <numOrds; l ++){
                    Order o =new Order(AccountId =acct.Id, EffectiveDate =date.parse('09/11/2021'), ContractId =cnt.Id, Status ='Draft');
                    ords.add(o);
                }
            }
        }
        insert ords;
    
        //Create Tasks
        List<Task> tsks =new List<Task>();
        for (Integer j =0; j <numAccts; j ++){
            Account acct =accts[j];
            for (Integer m =0; m <numTsk; m ++){
                tsks.add(new Task(WhatId =acct.Id, Subject ='Call', Status ='Nouvelle'));
            }
        }
        insert tsks;
    }

}