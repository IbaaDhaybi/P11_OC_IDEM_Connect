/**
 * @description       : 
 * -------------------
 * 1- blockage la de la modification du statut « Draft » à « Active » 
 * et affichage d'un message d’erreur invitant l’utilisateur à saisir des produits avant d’activer l’order.
 * 2- vérification qu’il n’y a aucun order rattaché à Account
 * S’il y a aucun autre order rattaché à ce Account, la case Active__c sera décochée si elle a été cochée
 * @author            : Ibaa
 * @last modified on  : 09-09-2022
**/

public class OrderTriggerHandler {
    
    public static void noStatusUpdateIfNoOrders(Map<Id,Order> orderOld, Map<Id,Order> orderNew) {
       //Création d'une liste vide d'id de Order
        Set<Id> idOrder = new Set<Id>();
        for(Order orderN : orderNew.values()) {
            //Faire correspondre l'ID des anciens et des nouveaux
            Order orderO = orderOld.get(orderN.Id);
            //Si le statut a changé et il est sur active 
            //-> Ajout de l'id des nouveaux order dans le set
            if(orderN.status != orderO.Status && orderN.Status == 'active') {
                idOrder.add(orderN.Id);
            }
        }
        //Selection de l'ID des orders a condition qu'il soit dans le set
        List<Order> orderListAndItems = [SELECT Id,(SELECT Id FROM OrderItems)
                                        FROM Order WHERE Id IN : idOrder];
        //vérification que le set n'est pas vide
        if(idOrder != null && idOrder.size() > 0) {
            for(Order nOrder : orderListAndItems) {
                //Si pas de  produits sur la fiche order 
                //-> un message d'erreur s'affiche
                if(nOrder.OrderItems.size() == 0 || nOrder.OrderItems == null) {
                    orderNew.get(nOrder.Id).addError('You should have at least one product on Order to update status.');
                }
            }
        }
    }
    public static void uncheckActiveCheckbox(List<Order> orderNewList){
        //Création d'une liste d'account
        List<Account> AccUpdate = new List<Account>();
        //Création d'une liste  de id d'account
        Set<Id> idAccount = new Set<Id>();
        for(Order o : orderNewList) {
            if(o.AccountId != null) {
                //ajout des id de Account à l'objet order
                idAccount.add(o.AccountId);
            }
        }
         //Création d'une liste vide pour les ID des Account avec Orders
         //Selection de l'ID des Accounts, des orders et du champs champs active_c
        List<Account> AccountAndOrders = [SELECT Id, (SELECT Id, AccountId FROM Orders),
                                            Active__c FROM Account WHERE Id IN : idAccount];
        
        //vérification que le set ID n'est pas vide
        if(idAccount.size() > 0){
            for(Account a : AccountAndOrders) {
                //Si il n'y a aucun orders lié a ce compte
                if(a.orders == null || a.orders.size() == 0) {
                    //vérification si le champs active est sur true(coché)
                if(a.Active__c == true){
                    //si oui -> Assignation sur false
                    a.Active__c = false;
                    //ajout des comptes dans la liste
                    AccUpdate.add(a);
                    }
                }
                //Si il existe un order ou plus sur Account
                //et le checkbox est décoché -> on le coche
                else {
                    if(a.Active__c == false) {
                        a.Active__c = true;
                        AccUpdate.add(a);
                    }
                }
            }
         }
         if(AccUpdate.size() > 0) {
            update AccUpdate;
         }
    }
}