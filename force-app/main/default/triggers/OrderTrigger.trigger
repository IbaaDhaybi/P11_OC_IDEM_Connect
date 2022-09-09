/**
 * @description       : 
 * --------------------
 * 1- trigger qui se déclenche pour appeler la classe apex OrderTriggerHandler.checkOrdersOnAccountToUpdateSatus
 * 2- trigger qui se déclenche pour appeler la classe apex OrderTriggerHandler.uncheckActiveCheckbox
 * @author            : Ibaa
 * @last modified on  : 09-09-2022

**/
trigger OrderTrigger on Order (before update, after update, after delete) { 

    if (Trigger.isBefore && Trigger.isUpdate) {
        OrderTriggerHandler.noStatusUpdateIfNoOrders(Trigger.oldMap, Trigger.newMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate)  {
        OrderTriggerHandler.uncheckActiveCheckbox(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isDelete) {
        OrderTriggerHandler.uncheckActiveCheckbox(Trigger.old);
    }
}