/**
 * @description       : classe de test pour tester les fonctionalités de la classe BatchAddTaskToAccount
 * @author            : Ibaa
 * @last modified on  : 09-07-2022
**/
@isTest
public class BatchAddTaskToAccountTest {
    @isTest
    static void createTaskNoOrderTest(){
		// Parcourir les données de TestDataFactory pour créer un Account 
		TestDataFactory.createAccounts(1);
		// Execute Batch
		Test.startTest();
		BatchAddTaskToAccount taskAdd =new BatchAddTaskToAccount();
		//Id BatchId =
        Database.executeBatch(taskAdd);
		Test.stopTest();
		//assert la bonne création du Task
		List<Task> tsks =[SELECT Id
		                  FROM Task];
		for (Task tsk :tsks)
			system.assertEquals(1, tsks.size());
	}

    @isTest
    static void create200TaskNoOrderTest(){
		// Parcourir les données de TestDataFactory pour créer 200 Account
		TestDataFactory.createAccounts(200);
		// Execute Batch
		Test.startTest();
		BatchAddTaskToAccount tasksAdd =new BatchAddTaskToAccount();
		//Id BatchId =
        Database.executeBatch(tasksAdd);
		Test.stopTest();
		//assert la bonne création des Task
		List<Task> alltsks =[SELECT Id
		                  FROM Task];
		for (Task tsk :alltsks)
			system.assertEquals(200, alltsks.size());
	}
    @isTest
    static void create5TaskWithoutOrderTest(){
		// Parcourir les données de TestDataFactory pour créer 5 Account sans order ni task
		TestDataFactory.createAccountWithOrderAndTask(5, 0, 0, 0);
		// Execute Batch
		Test.startTest();
		BatchAddTaskToAccount tasksAdd5 =new BatchAddTaskToAccount();
		//Id BatchId =
        Database.executeBatch(tasksAdd5);
		Test.stopTest();
		// assert la bonne création des Task
		List<Task> all5tsks =[SELECT Id
		                  FROM Task];
		for (Task tsk :all5tsks)
			system.assertEquals(5, all5tsks.size());
	}

    @isTest
	static void createOrderNoTaskTest(){
		// Parcourir les données depuis la classe TestDataFactory: 1 Account, 1 Contract, 1 Order and 1 Task
		
        TestDataFactory.createAccountWithOrderAndTask(1, 1 , 1, 1);
		
        // Execute Batch
		Test.startTest();
		BatchAddTaskToAccount oldTask =new BatchAddTaskToAccount();
		Id BatchId = Database.executeBatch(oldTask);
		Test.stopTest();
		// Assert pas de création de task car on a déjà
		List<Task> tsks =[SELECT Id
		                  FROM Task];
		for (Task tsk :tsks)
			system.assertEquals(1, tsks.size());
	}
}
