/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.core;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.sql.ReferenceDataIdEntity;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.Card;
import com.temenos.microservice.payments.entity.PaymentMethod;
import com.temenos.microservice.payments.entity.PaymentOrder;
import com.temenos.microservice.payments.function.DeletePaymentOrdersInput;
import com.temenos.microservice.payments.view.AllPaymentStatus;
import com.temenos.microservice.payments.view.ErrorSchema;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.payments.view.PaymentStatus;
import com.temenos.microservice.framework.core.function.Context;
import org.springframework.stereotype.Component;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;

@Component
public class DeletePaymentOrdersProcessor {

	public AllPaymentStatus invoke(Context ctx, DeletePaymentOrdersInput input) throws FunctionException {
		if (input.getParams() == null && input.getParams().get().getPaymentIds().get(0) == null) {
			throw new InvalidInputException(new FailureMessage("The Parameters of Payment Ids are not present"));
		}
		String[] paymentId = input.getParams().get().getPaymentIds().get(0).split(",");
		// To Remove Duplicates
		Set<String> paymentIdSet = new HashSet<String>(Arrays.asList(paymentId));
		ArrayList<String> paymentIdList = new ArrayList<String>(paymentIdSet);
		List<Object> poList = new ArrayList<Object>();
		for (int i = 0; i < paymentIdList.size(); i++) {
			PaymentOrder paymentOrderOpt = (PaymentOrder) PaymentOrderDao.getInstance(PaymentOrder.class).getSqlDao()
					.findById(paymentIdList.get(i), com.temenos.microservice.payments.entity.PaymentOrder.class);
			if (paymentOrderOpt != null) {
				// Set Method as null as it is the foreign key constraint
				if (paymentOrderOpt.getPaymentMethod() != null) {
					PaymentMethod paymentMethod = new PaymentMethod();
					paymentOrderOpt.setPaymentMethod(null);
					PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
							.saveOrMergeEntity(paymentOrderOpt, false);
				}
				poList.add(paymentOrderOpt);
			} else {
				throw new InvalidInputException(new FailureMessage("One or more Invalid Payment Order Ids Entered"));
			}
		}
		PaymentOrderDao.getInstance(com.temenos.microservice.payments.entity.PaymentOrder.class).getSqlDao()
				.deleteByIdList(poList);
		AllPaymentStatus allPaymentStatus = new AllPaymentStatus();
		for (int i = 0; i < paymentIdList.size(); i++) {
			PaymentStatus paymentStatus = new PaymentStatus();
			paymentStatus.setStatus("Deleted this PaymentId	: " + paymentIdList.get(i));
			allPaymentStatus.add(paymentStatus);
		}

		return allPaymentStatus;
	}

}
