package com.temenos.microservice.paymentorder.scheduler;

import static com.temenos.microservice.framework.core.logger.constants.LoggerConstants.SCHEDULER_DIAGNOSTIC;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.scheduler.function.SchedulerCommandInput;
import com.temenos.microservice.framework.scheduler.function.SchedulerCommandOutput;
import com.temenos.microservice.framework.scheduler.function.SchedulerFunctionInterface;
import com.temenos.microservice.paymentorder.entity.PaymentOrder;

public class PaymentOrderScheduler implements SchedulerFunctionInterface {

	@Override
	public SchedulerCommandOutput invoke(Context context, SchedulerCommandInput input) throws FunctionException {
		SCHEDULER_DIAGNOSTIC.prepareInfo("*** Payment order Scheduler implementation method is running... ***"
				+ new Date().toString() + "....Operation ID: " + input.getOperationId()).log();
		SchedulerCommandOutput schedulerCommandOutput = new SchedulerCommandOutput();
		schedulerCommandOutput.setOperationId(input.getOperationId());
		NoSqlDbDao<PaymentOrder> paymentOrderDao = DaoFactory.getNoSQLDao(PaymentOrder.class);
		int count = paymentOrderDao.get().size();
		Map<String, Object> data = new HashMap<>();
		data.put("source", input.getParameters().get("source"));
		data.put("Total count of payment orders", count);
		schedulerCommandOutput.setData(data);
		schedulerCommandOutput.setMessage("Success!");
		SCHEDULER_DIAGNOSTIC
				.prepareInfo("*** Payment order Scheduler run has completed... ***" + new Date().toString()
						+ "....Operation ID: " + input.getOperationId() + "Total count of payment orders: " + count)
				.log();
		return schedulerCommandOutput;
	}

}