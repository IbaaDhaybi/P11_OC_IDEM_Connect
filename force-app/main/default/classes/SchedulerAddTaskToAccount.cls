/**
 * @description       : Cette classe implemente Schedulable pour executer la classe BatchAddTaskToAccount
 * @author            : Ibaa
 * @last modified on  : 09-07-2022
**/
global class SchedulerAddTaskToAccount implements Schedulable{
        global void execute(SchedulableContext info){
            //Call BatchAddTaskToAccount class and schedule it through User Interface
            BatchAddTaskToAccount addTask = new BatchAddTaskToAccount();
            Database.ExecuteBatch(addTask);
        }
    }
