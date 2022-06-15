/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.core.GetPaymentOrderProcessor;
import com.temenos.microservice.payments.core.SpringContextInitializer;
import com.temenos.microservice.payments.view.PaymentOrderStatus;

/**
 * GetPaymentOrderImpl.
 * 
 * @author kdhanraj
 *
 */

public class GetPaymentOrderImpl implements GetPaymentOrder {

	@Override
	public PaymentOrderStatus invoke(Context context, GetPaymentOrderInput input)
			throws FunctionException {
		GetPaymentOrderProcessor getPaymentOrderProcessor 
		= (GetPaymentOrderProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(GetPaymentOrderProcessor.class);
		return getPaymentOrderProcessor.invoke(context, input);
	}
	
}
