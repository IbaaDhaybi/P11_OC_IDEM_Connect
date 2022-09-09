/**
 * @description       : classe de test pour tester la classe SchedulerAddTaskToAccount
 * @author            : Ibaa
 * @last modified on  : 09-09-2022
**/

@isTest
public class SchedulerAddTaskToAccountTest{
	// CRON expression: minuit du 08 Octobre 2022.
	static String CRON_EXP ='0 0 0 8 10 ? 2022';
	static testMethod void testPositiveScheduledJob(){
		Test.startTest();
		String jobId =System.schedule('ScheduledBatchApexTest', CRON_EXP, new SchedulerAddTaskToAccount());
		CronTrigger ct =[SELECT Id, CronExpression, TimesTriggered, NextFireTime
		                 FROM CronTrigger
		                 WHERE id =:jobId];
		System.assertEquals(CRON_EXP, ct.CronExpression);
		System.assertEquals(0, ct.TimesTriggered);
		System.assertEquals('2022-10-08 00:00:00', String.valueOf(ct.NextFireTime));
		Test.stopTest();
	}
}