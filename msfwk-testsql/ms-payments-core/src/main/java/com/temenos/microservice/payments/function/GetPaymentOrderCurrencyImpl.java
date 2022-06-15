/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.core.GetPaymentOrderCurrencyProcessor;
import com.temenos.microservice.payments.core.GetPaymentOrdersProcessor;
import com.temenos.microservice.payments.view.PaymentOrders;

public class GetPaymentOrderCurrencyImpl implements GetPaymentOrderCurrency {

	@Override
	public PaymentOrders invoke(Context context, GetPaymentOrderCurrencyInput input) throws FunctionException {
		GetPaymentOrderCurrencyProcessor getPaymentOrderCurrencyProcessor = (GetPaymentOrderCurrencyProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(GetPaymentOrderCurrencyProcessor.class);
		return getPaymentOrderCurrencyProcessor.invoke(context, input);
	}
}
