package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
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
}
