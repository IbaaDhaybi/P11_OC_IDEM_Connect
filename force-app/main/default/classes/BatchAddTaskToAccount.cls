/**
 * @description       : batch qui récupère les comptes n’ayant pas d’order associés ni des tâches de rappel 
 * et crée des tâches et les rattachent à ce compte.
 * @author            : Ibaa
 * @last modified on  : 09-17-2022
**/
global  class BatchAddTaskToAccount implements Database.Batchable<sObject>{
  
  global Database.QueryLocator start(Database.BatchableContext info){ 
    //Selection des Accounts avec les orders et Tasks quqnd le champs Active_c de Account est décoché
    return Database.getQueryLocator('SELECT Id, OwnerId, (SELECT Id FROM Orders limit 1), (SELECT Id FROM Tasks WHERE Subject=\'Call\' limit 1) FROM Account WHERE Active__c = false');
}
global void execute(Database.BatchableContext info, List<Account> scope){
    // création d'une liste de Task
    List<Task> taskList = new List<Task>();
    //Vérification s'il existe des orders et des tasks sur la fiche d'account
    for(Account acc: scope){
        if(acc.Orders.size() == 0 && acc.Tasks.size() == 0){
            // Création d'un Task avec les champs nécessaires
            Task createTask = new Task(
                OwnerId = acc.OwnerId,
                Subject = 'Call',
                Status = 'Nouvelle',
                Priority = 'Normal',
                IsReminderSet = true,
                WhatId = acc.Id,
                ReminderDateTime = System.now()+5
            );
            taskList.add(createTask);
        }
    }
    insert taskList;
}
global void finish(Database.BatchableContext info){
    
}
}