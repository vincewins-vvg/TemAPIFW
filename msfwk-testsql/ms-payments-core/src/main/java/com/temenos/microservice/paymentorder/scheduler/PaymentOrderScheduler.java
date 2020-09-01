package com.temenos.microservice.paymentorder.scheduler;

import static com.temenos.microservice.framework.core.logger.constants.LoggerConstants.SCHEDULER_DIAGNOSTIC;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
//import com.temenos.microservice.framework.core.data.OutboxEvent;
import com.temenos.microservice.framework.core.data.sql.SqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.scheduler.function.SchedulerCommandInput;
import com.temenos.microservice.framework.scheduler.function.SchedulerCommandOutput;
import com.temenos.microservice.framework.scheduler.function.SchedulerFunctionInterface;
import com.temenos.microservice.payments.entity.PaymentOrder;

public class PaymentOrderScheduler implements SchedulerFunctionInterface {

	@Override
	public SchedulerCommandOutput invoke(Context context, SchedulerCommandInput input) throws FunctionException {
		SCHEDULER_DIAGNOSTIC.prepareInfo("*** Payment order Scheduler implementation method is running... ***"
				+ new Date().toString() + "....Operation ID: " + input.getOperationId()).log();
		SchedulerCommandOutput schedulerCommandOutput = new SchedulerCommandOutput();
		schedulerCommandOutput.setOperationId(input.getOperationId());
		SqlDbDao<PaymentOrder> sqlDbDao = DaoFactory.getSQLDao(PaymentOrder.class);
		CriteriaBuilder criteriaBuilder = sqlDbDao.getEntityManager().getCriteriaBuilder();
		CriteriaQuery<PaymentOrder> criteriaQuery = criteriaBuilder.createQuery(PaymentOrder.class);
		Root<PaymentOrder> root = criteriaQuery.from(PaymentOrder.class);
		criteriaQuery.select(root);
		List<Predicate> predicates = new ArrayList<>();
		int count = sqlDbDao.executeCriteriaQuery(criteriaBuilder, criteriaQuery, root, predicates, PaymentOrder.class)
				.size();
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