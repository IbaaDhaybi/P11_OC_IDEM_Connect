/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-06-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

public with sharing class OrderTriggerHandler {
    public static void checkOrdersOnAccountToUpdateSatus(List<Order> ordersList) {
        //Creation d'une Order ID Set
        Set<Id> ordSet = new Set<Id>();
        // parcourir la liste des orders
        for (Order ord :ordersList){
            ordset.add(ord.Id);
            //stocker les anciennes valeurs de Order dans une Map
            Order oldOrder = (Order)Trigger.oldMap.get(ord.Id);
            //récupérer les orders avec les produits
            List<OrderItem> orderItemList = [SELECT OrderId, Order.Status
                                            FROM OrderItem
                                           WHERE OrderId IN :ordset];

            //s'il n'y a pas de produits sur la fiche d'Order et que le statut change de 'Draft' en 'Active' 
            //un message d'erreur s'affichera et la mise à jour du statut sera bloquée
            if (orderItemList.size() == 0 && oldOrder.Status == 'Draft' && ord.Status == 'Active'){
                ord.addError('You should have at least one product on Order to update status.');
            }  
        }

    }

    public static void uncheckActiveCheckbox(List<Order> ordersList){
        // Créer une Map des Accounts et Id
		map<id, Account> updateMap =new Map<id, Account>();
        // Créer un set  d'order ID
		set<ID> ordset =new Set<ID>();

		// Parcourir la liste des orders concernées par le trigger
		for (Order ord :ordersList){
			if (ord.AccountId !=null)
				ordset.add(ord.AccountId);
		}
		// Create list and query orders
		List<Order> ResultList =[SELECT AccountId, Account.Active__c
		                           FROM Order
		                          WHERE AccountId IN :ordset];

		// S'il y a des orders attachées à Account, la case reste cochée
		if (ResultList !=null && ResultList.size() >0){
			for (Order res :ResultList){
				Account acc = new Account();
				acc.Id =(id)res.get('AccountId');
				acc.Active__c =true;
				updateMap.put(acc.Id, acc);
			}

		// S'il n'y a pas d'orders attachées à Account, la case est décochée
		} else{
			for (id idSet :ordset){
				Account acc = new Account();
				acc.Id =idSet;
				acc.Active__c = false;
				updateMap.put(acc.Id, acc);
			}
		}
		update updateMap.values();
	}

    }
