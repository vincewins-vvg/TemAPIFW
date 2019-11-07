package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.core.GetPaymentOrdersProcessor;
import com.temenos.microservice.payments.core.SpringContextInitializer;
import com.temenos.microservice.payments.view.PaymentOrders;


public class GetPaymentOrdersImpl implements GetPaymentOrders {

	@Override
	public PaymentOrders invoke(Context context, GetPaymentOrdersInput input)
			throws FunctionException {
		GetPaymentOrdersProcessor getPaymentOrdersProcessor 
		= (GetPaymentOrdersProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(GetPaymentOrdersProcessor.class);
		return getPaymentOrdersProcessor.invoke(context, input);
	}
}
