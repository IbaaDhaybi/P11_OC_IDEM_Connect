/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-06-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger OrderTrigger on Order (before update, after delete) {

    
    if(Trigger.IsBefore && Trigger.isUpdate){
        OrderTriggerHandler.checkOrdersOnAccountToUpdateSatus(Trigger.new);
    }

    if(Trigger.IsAfter && Trigger.isDelete){
        OrderTriggerHandler.uncheckActiveCheckbox(Trigger.old);
    }
}