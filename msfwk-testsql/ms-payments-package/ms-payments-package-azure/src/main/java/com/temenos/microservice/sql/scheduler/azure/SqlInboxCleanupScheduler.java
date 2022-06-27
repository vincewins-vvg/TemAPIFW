/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.sql.scheduler.azure;

import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.TimerTrigger;
import com.temenos.microservice.framework.scheduler.core.SchedularInstanceHolder;
import com.temenos.microservice.framework.scheduler.core.SchedulerExecutor;

public class SqlInboxCleanupScheduler {

	@FunctionName("SqlInboxCleanupScheduler")
	public String handleRequest(
			@TimerTrigger(name = "SqlInboxCleanupSchedulerTrigger", schedule = "%SqlInboxCleanupSchedulerTime%") String timerInfo,
			ExecutionContext context) {
		context.getLogger().info("Entered successfully into the SqlInboxCleanupScheduler " + timerInfo);
		SchedularInstanceHolder instance = new SchedularInstanceHolder();
		instance.setOperationId("sqlinboxcleanup");
		SchedulerExecutor schedulerExecutor = new SchedulerExecutor();
		schedulerExecutor.execute(instance);
		return null;
	}
}
