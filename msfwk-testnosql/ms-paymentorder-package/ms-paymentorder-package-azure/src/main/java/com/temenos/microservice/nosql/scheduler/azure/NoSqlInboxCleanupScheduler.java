package com.temenos.microservice.nosql.scheduler.azure;

import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.TimerTrigger;
import com.temenos.microservice.framework.scheduler.core.SchedularInstanceHolder;
import com.temenos.microservice.framework.scheduler.core.SchedulerExecutor;

public class NoSqlInboxCleanupScheduler {

	@FunctionName("NoSqlInboxCleanupScheduler")
	public String handleRequest(
			@TimerTrigger(name = "NoSqlInboxCleanupSchedulerTrigger", schedule = "%NoSqlInboxCleanupSchedulerTime%") String timerInfo,
			ExecutionContext context) {
		context.getLogger().info("Entered successfully into the NoSqlInboxCleanupScheduler " + timerInfo);
		SchedularInstanceHolder instance = new SchedularInstanceHolder();
		instance.setOperationId("nosqlinboxcleanup");
		SchedulerExecutor schedulerExecutor = new SchedulerExecutor();
		schedulerExecutor.execute(instance);
		return null;
	}
}
