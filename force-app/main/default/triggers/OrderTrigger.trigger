/**
 * @description       : 
 * --------------------
 * 1- trigger qui se déclenche pour appeler la classe apex OrderTriggerHandler.checkOrdersOnAccountToUpdateSatus
 * 2- trigger qui se déclenche pour appeler la classe apex OrderTriggerHandler.uncheckActiveCheckbox
 * @author            : Ibaa
 * @last modified on  : 09-07-2022

**/
trigger OrderTrigger on Order (before update, after delete) {

    
    if(Trigger.IsBefore && Trigger.isUpdate){
        OrderTriggerHandler.checkOrdersOnAccountToUpdateSatus(Trigger.new);
    }

    if(Trigger.IsAfter && Trigger.isDelete){
        OrderTriggerHandler.uncheckActiveCheckbox(Trigger.old);
    }
}