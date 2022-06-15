/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.core.UpdateNewPaymentOrdersProcessor;
import com.temenos.microservice.payments.view.AllPaymentStatus;

public class UpdateNewPaymentOrdersImpl implements UpdateNewPaymentOrders{
	
	@Override
	public AllPaymentStatus invoke(Context context, UpdateNewPaymentOrdersInput input) throws FunctionException {
		UpdateNewPaymentOrdersProcessor updateNewPaymentOrdersProcessor 
		= (UpdateNewPaymentOrdersProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(UpdateNewPaymentOrdersProcessor.class);
		return updateNewPaymentOrdersProcessor.invoke(context, input);
	}

}
