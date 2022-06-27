/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.core.GetPaymentOrdersProcessor;
import com.temenos.microservice.paymentsorder.function.GetPaymentOrders;
import com.temenos.microservice.paymentsorder.function.GetPaymentOrdersInput;
import com.temenos.microservice.paymentsorder.view.PaymentOrders;

public class GetPaymentOrdersImpl implements GetPaymentOrders {

	@Override
	public PaymentOrders invoke(Context context, GetPaymentOrdersInput input) throws FunctionException {
		GetPaymentOrdersProcessor getPaymentOrdersProcessor = (GetPaymentOrdersProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(GetPaymentOrdersProcessor.class);
		return getPaymentOrdersProcessor.invoke(context, input);
	}
}
