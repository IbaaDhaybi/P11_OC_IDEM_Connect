/**
 * @description       : Cette classe implemente Schedulable pour executer la classe BatchAddTaskToAccount
 * Elle va déclenché le batch
 * @author            : Ibaa
 * @last modified on  : 09-09-2022
**/
global class SchedulerAddTaskToAccount implements Schedulable{
        global void execute(SchedulableContext info){
            //Appel du Batch BatchAddTaskToAccount
            BatchAddTaskToAccount ct = new BatchAddTaskToAccount();
            Database.ExecuteBatch(ct);
        }
    }
