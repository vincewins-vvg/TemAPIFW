package com.temenos.microservice.paymentorder.ingester;

import static com.temenos.microservice.framework.core.logger.constants.LoggerConstants.FUNCTION_DIAGNOSTIC;

import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;

public abstract class POHandler {

	public void preHook(final Context ctx, GenericEvent event) throws FunctionException {
		FUNCTION_DIAGNOSTIC.prepareInfo("Inside Pre Hook Function").tag("ClassName", this.getClass().getName()).log();
	}

	public void postHook(final Context ctx, GenericEvent event) throws FunctionException {
		FUNCTION_DIAGNOSTIC.prepareInfo("Inside Post Hook Function").tag("ClassName", this.getClass().getName()).log();

	}

}
