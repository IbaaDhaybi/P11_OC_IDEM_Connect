/**
 * @description       : classe de test pour tester le bon fonctionnement du batch BatchAddTaskToAccount
 * @author            : Ibaa
 * @last modified on  : 09-09-2022
**/
@IsTest
public class BatchAddTaskToAccountTest {
    @isTest
    static void createTaskNoOrderTest(){
		//Creation de 1 Account sans order et task à partir de la classe TestDataFatory
		TestDataFactory.createdProduct(1, 0, 0, 0);
		// Execute Batch
		Test.startTest();
		BatchAddTaskToAccount ct =new BatchAddTaskToAccount();
		Id BatchId =Database.executeBatch(ct);
		Test.stopTest();
		// Vérifier que le task est bien créer
		List<Task> tsks =[SELECT Id FROM Task];
		for (Task tsk :tsks)
			system.assertEquals(1, tsks.size());
	}

    @isTest
    static void orderAndTaskTest(){
		// Creation de 1 Account  avec order et task à partir de la classe TestDataFatory
		TestDataFactory.createdProduct(1, 1, 1, 1);
		// Execute Batch
		Test.startTest();
		BatchAddTaskToAccount ct =new BatchAddTaskToAccount();
		Id BatchId =Database.executeBatch(ct);
		Test.stopTest();
		//Vérifier qu'on une seule tâche et il n'a pas créé une autre
		List<Task> tsks =[SELECT Id FROM Task];
		for (Task tsk :tsks)
			system.assertEquals(1, tsks.size());
	}

    @isTest
    static void create200TaskNoOrderTest(){
		// Parcourir les données de TestDataFactory pour créer 200 Account
		TestDataFactory.createdProduct(200, 0, 0, 0);
		// Execute Batch
		Test.startTest();
		BatchAddTaskToAccount tasksAdd =new BatchAddTaskToAccount();
        Database.executeBatch(tasksAdd);
		Test.stopTest();
		//assert la bonne création des 200 Task
		List<Task> alltsks =[SELECT Id FROM Task];
		for (Task tsk :alltsks)
			system.assertEquals(200, alltsks.size());
	}
}
