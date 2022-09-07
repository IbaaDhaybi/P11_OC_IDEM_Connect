/**
 * @description       : batch qui récupère les comptes n’ayant pas d’order associés ni des tâches de rappel 
 * et crée des tâches et les rattachent à ce compte.
 * @author            : Ibaa
 * @last modified on  : 09-07-2022
**/
global  class BatchAddTaskToAccount implements Database.Batchable<sObject>
{
  
    global Database.QueryLocator start(Database.BatchableContext info)
    {
      // Requeter seulement les Accounts sans orders afin de créer des taches de rappels aux differents propriétaires des Accounts 
      return Database.getQueryLocator('Select OwnerId, (Select Id FROM Orders), (Select Id FROM Tasks WHERE Subject=\'Call\') FROM Account');

    }

    global void execute (Database.BatchableContext info , List<Account> activity)
    {
        List <Task> updateAllTasks = new List<Task>();
        for (Account account : activity) 
        {
            if (account.Orders.size()==0 && account.Tasks.size()==0 )
            {
                Task newCallTasks = new Task
                (
                  OwnerId = account.OwnerId,
                  Subject = 'Call',
                  Status = 'Nouvelle',
                  Priority = 'Normal',
                  IsReminderSet = true ,
                  WhatId = account.Id ,
                  ReminderDateTime = System.now()+5
                );
                updateAllTasks.add(newCallTasks);
            }
        }
        insert updateAllTasks;

    }

    global void finish (Database.BatchableContext info)
    {

    }
}