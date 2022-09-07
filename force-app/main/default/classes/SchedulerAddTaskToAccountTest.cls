/**
 * @description       : classe de test pour tester la classe SchedulerAddTaskToAccount
 * @author            : Ibaa
 * @last modified on  : 09-07-2022
**/
@isTest
public class SchedulerAddTaskToAccountTest{
	// CRON expression: midnight on December 6 2021.
	// Because this is a test, job executes immediately after Test.stopTest()
	static String CRON_EXP ='0 0 0 5 11 ? 2022';
	static testMethod void testPositiveScheduledJob(){
		Test.startTest();
		String jobId =System.schedule('ScheduledBatchApexTest', CRON_EXP, new SchedulerAddTaskToAccount());
		CronTrigger ct =[SELECT Id, CronExpression, TimesTriggered, NextFireTime
		                 FROM CronTrigger
		                 WHERE id =:jobId];
		System.assertEquals(CRON_EXP, ct.CronExpression);
		System.assertEquals(0, ct.TimesTriggered);
		System.assertEquals('2022-11-05 00:00:00', String.valueOf(ct.NextFireTime));
		Test.stopTest();
	}
}
//public with sharing class SchedulerAddTaskToAccountTest {
  //  public SchedulerAddTaskToAccountTest() {

    //}
//}
