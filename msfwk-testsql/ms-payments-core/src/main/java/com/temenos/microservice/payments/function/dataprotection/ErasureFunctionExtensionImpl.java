/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.function.dataprotection;

import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.ResponseStatus;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.framework.dataprotection.ErasureFunctionExtension;
import com.temenos.microservice.framework.dataprotection.function.ExecuteCDPErasureRequestInput;
import com.temenos.microservice.framework.dataprotection.view.ErasureResponse;
import com.temenos.microservice.payments.event.ErasureFunctionEvent;
import com.temenos.microservice.payments.event.ReportFunctionEvent;

public class ErasureFunctionExtensionImpl implements ErasureFunctionExtension{

	@Override
	public void process(Context ctx, ResponseStatus responseStatus, ExecuteCDPErasureRequestInput input,
			ErasureResponse response) throws FunctionException {
		ErasureFunctionEvent erasureFunctionEvent = new ErasureFunctionEvent();
		erasureFunctionEvent.setCustomerId(response.getCustomerId());
		erasureFunctionEvent.setPartyId(response.getPartyId());
		erasureFunctionEvent.setServiceId(response.getServiceId());
		erasureFunctionEvent.setRequestId(input.getParams().get().getErasureRequestId().get(0));
		EventManager.raiseBusinessEvent(ctx, new GenericEvent("PostHookEvent", erasureFunctionEvent));
	}

}
