package com.temenos.microservice.payments.ingester;

import static com.temenos.microservice.framework.core.logger.constants.LoggerConstants.FUNCTION_DIAGNOSTIC;

import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.EventProcessor;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;

public class PoHandlerImpl extends PaymentsHandler implements EventProcessor {
	@Override
	public void processEvent(Context context, GenericEvent event) throws FunctionException {
		FUNCTION_DIAGNOSTIC.prepareInfo("Received POAccepted event!").log();
	}
}
