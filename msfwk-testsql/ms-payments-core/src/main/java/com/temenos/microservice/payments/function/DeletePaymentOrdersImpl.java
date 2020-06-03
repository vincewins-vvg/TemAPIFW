package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.payments.core.DeletePaymentOrdersProcessor;
import com.temenos.microservice.payments.view.AllPaymentStatus;
import com.temenos.microservice.payments.view.ErrorSchema;
import com.temenos.microservice.framework.core.function.Context;

public class DeletePaymentOrdersImpl implements DeletePaymentOrders{
	@Override
	public AllPaymentStatus invoke(Context ctx, DeletePaymentOrdersInput input)
			throws FunctionException {
		DeletePaymentOrdersProcessor deletePaymentOrdersProcessor 
				= (DeletePaymentOrdersProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
						.instance().getBean(DeletePaymentOrdersProcessor.class);
				return deletePaymentOrdersProcessor.invoke(ctx, input);
	}
	

}
