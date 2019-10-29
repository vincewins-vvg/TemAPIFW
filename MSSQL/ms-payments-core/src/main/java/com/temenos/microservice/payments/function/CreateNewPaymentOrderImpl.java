package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.core.CreateNewPaymentOrderProcessor;
import com.temenos.microservice.payments.core.SpringContextInitializer;
import com.temenos.microservice.payments.view.PaymentStatus;

/**
 * CreateNewPaymentOrderImpl.
 * 
 * @author kdhanraj
 *
 */

public class CreateNewPaymentOrderImpl implements CreateNewPaymentOrder {

	@Override
	public PaymentStatus invoke(Context context, CreateNewPaymentOrderInput input)
			throws FunctionException {
		CreateNewPaymentOrderProcessor createNewPaymentOrderProcessor 
		= (CreateNewPaymentOrderProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(CreateNewPaymentOrderProcessor.class);
		return createNewPaymentOrderProcessor.invoke(context, input);
	}
	
}
