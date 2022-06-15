/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.function;

import java.util.List;
import java.util.Map;

import com.temenos.connect.InboxOutbox.logger.InboxOutboxConstants;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.OutOfSequenceException;
import com.temenos.microservice.framework.core.function.Request;
import com.temenos.microservice.framework.core.util.SequenceUtil;
import com.temenos.microservice.payments.core.SpringContextInitializer;
import com.temenos.microservice.payments.core.UpdatePaymentOrderProcessor;
import com.temenos.microservice.payments.view.PaymentStatus;

public class UpdatePaymentOrderImpl implements UpdatePaymentOrder {

	@Override
	public PaymentStatus invoke(Context context, UpdatePaymentOrderInput input) throws FunctionException {
		UpdatePaymentOrderProcessor updatePaymentOrderProcessor 
		= (UpdatePaymentOrderProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(UpdatePaymentOrderProcessor.class);
		return updatePaymentOrderProcessor.invoke(context, input);
	}

	@Override
	public void isSequenceValid(final Context ctx) throws FunctionException {
		Request<String> request = (Request<String>) ctx.getRequest();
		Map<String, List<String>> headers = request.getHeaders();
		String businessKey = headers.get(InboxOutboxConstants.BUSINESS_KEY).get(0);
		Long sequenceNo = Long.valueOf(headers.get(InboxOutboxConstants.SEQUENCE_NO).get(0));
		String sourceId = headers.get(InboxOutboxConstants.EVENT_SOURCE).get(0);
		Long expectedSequenceNo = SequenceUtil.generateSequenceNumber(businessKey, sourceId);
		if (!expectedSequenceNo.equals(sequenceNo)) {
			throw new OutOfSequenceException("Invalid sequence number: " + sequenceNo);
		}
	}
	
}
