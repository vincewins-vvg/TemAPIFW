package com.temenos.microservice.paymentorder.function;

import static com.temenos.microservice.framework.core.logger.constants.LoggerConstants.FUNCTION_DIAGNOSTIC;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.ResponseStatus;

public abstract class CreateCustomerAbstractFunction {

	public void preHook(Context ctx, String input) throws FunctionException {
		FUNCTION_DIAGNOSTIC.prepareInfo("Inside Pre Hook Function").tag("ClassName", this.getClass().getName()).log();
	}

	public void postHook(final Context ctx, final ResponseStatus responseStatus, final String input,
			final String response) throws FunctionException {
		FUNCTION_DIAGNOSTIC.prepareInfo("Inside Post Hook Function").tag("ClassName", this.getClass().getName()).log();

	}

}
