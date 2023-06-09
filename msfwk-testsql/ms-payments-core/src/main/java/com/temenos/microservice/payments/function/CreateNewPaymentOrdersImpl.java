/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.core.CreateNewPaymentOrdersProcessor;
import com.temenos.microservice.payments.view.AllPaymentStatus;

//
public class CreateNewPaymentOrdersImpl implements CreateNewPaymentOrders{

//	@Override
//	public AllPaymentStatus invoke(Context ctx, CreateNewPaymentOrdersInput input) throws FunctionException {
//		// TODO Auto-generated method stub
//		return null;
//	}

	@Override
	public AllPaymentStatus invoke(Context ctx, CreateNewPaymentOrdersInput input) throws FunctionException {

		// TODO Auto-generated method stub
		CreateNewPaymentOrdersProcessor createNewPaymentOrdersProcessor 
		= (CreateNewPaymentOrdersProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(CreateNewPaymentOrdersProcessor.class);
		return createNewPaymentOrdersProcessor.invoke(ctx, input);
	}
}
