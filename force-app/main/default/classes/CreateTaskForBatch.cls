/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-06-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class CreateTaskForBatch {
    public static void addTaskToAccounts(List<Account> createTasks){    
        List<Account> accountsWithoutTask = new List<Account>();
        for (Account account : createTasks) {
            if (account.Orders.size() == 0 && account.Tasks.size() == 0) {
                accountsWithoutTask.add(account);
            }
        }
        if (accountsWithoutTask.size() > 0) {   
            List<Task> tasksToCreate = new List<Task>();
            for (Account account : accountsWithoutTask) {
                tasksToCreate.add(
                    new Task(WhatId = account.Id, 
                             OwnerId = account.OwnerId, 
                             Subject = 'Call', 
                             Status = 'Nouvelle', 
                             Priority = 'Normal', 
                             IsReminderSet = true, 
                             ReminderDateTime = system.today()+5));
            }
            if (tasksToCreate.size() > 0){
                insert tasksToCreate;
                update tasksToCreate;
            }
        }
    }
}
