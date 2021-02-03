package com.temenos.microservice.paymentorder.function;

import static com.temenos.microservice.framework.core.logger.constants.LoggerConstants.DATABASE_DIAGNOSTIC;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.paymentorder.entity.PaymentMethod;
import com.temenos.microservice.paymentorder.entity.PaymentOrder;
import com.temenos.microservice.paymentorder.view.AllPaymentStatus;
import com.temenos.microservice.paymentorder.view.PaymentStatus;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.data.Operator;
import com.temenos.microservice.framework.core.function.Context;
import org.springframework.stereotype.Component;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.security.Criteria;
import com.temenos.microservice.framework.core.security.Criterion;
import com.temenos.microservice.framework.core.security.CriterionImpl;

@Component
public class DeletePaymentOrdersImpl implements DeletePaymentOrders {

	public AllPaymentStatus invoke(Context ctx, DeletePaymentOrdersInput input) throws FunctionException {
		if (input.getParams() == null || input.getParams().get().getPaymentIds() == null) {
			throw new InvalidInputException(new FailureMessage("The Parameters of Payment Ids are not present"));
		}
		String[] paymentId = input.getParams().get().getPaymentIds().get(0).split(",");
		// To Remove Duplicates
		Set<String> paymentIdSet = new HashSet<String>(Arrays.asList(paymentId));
		ArrayList<String> paymentIdList = new ArrayList<String>(paymentIdSet);
		List<PaymentOrder> poList = new ArrayList<PaymentOrder>();
		for (int i = 0; i < paymentIdList.size(); i++) {
			NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
					.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
			 

			Optional<PaymentOrder> paymentOrderOptResult = paymentOrderDao.getByPartitionKeyAndSortKey(paymentIdList.get(i),paymentIdList.get(i).split("~")[1]);

			if (paymentOrderOptResult.isPresent()&&paymentOrderOptResult.get()!=null) {
				PaymentOrder paymentOrderOpt =paymentOrderOptResult.get();
				
					
					poList.add(paymentOrderOpt);
			} else {
				throw new InvalidInputException(new FailureMessage("One or more Invalid Payment Order Ids Entered"));
			}	
		}
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
		
		paymentOrderDao.deleteByIdList(poList);
		AllPaymentStatus allPaymentStatus = new AllPaymentStatus();
		for (int i = 0; i < paymentIdList.size(); i++) {
			PaymentStatus paymentStatus = new PaymentStatus();
			paymentStatus.setStatus("Deleted this PaymentId	: " + paymentIdList.get(i));
			allPaymentStatus.add(paymentStatus);
		}

		return allPaymentStatus;
	}

}
