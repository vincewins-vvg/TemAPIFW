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
import com.temenos.microservice.framework.dataprotection.ReportFunctionExtension;
import com.temenos.microservice.framework.dataprotection.function.ExecuteSubjectAccessRequestInput;
import com.temenos.microservice.framework.dataprotection.view.SubjectAccessResponse;
import com.temenos.microservice.payments.event.ReportFunctionEvent;

public class ReportFunctionExtensionImpl implements ReportFunctionExtension{

	@Override
	public void process(Context ctx, ResponseStatus responseStatus, ExecuteSubjectAccessRequestInput input,
			SubjectAccessResponse response) throws FunctionException {
		ReportFunctionEvent reportFunctionEvent = new ReportFunctionEvent();
		reportFunctionEvent.setCustomerId(response.getCustomerId());
		reportFunctionEvent.setPartyId(response.getPartyId());
		reportFunctionEvent.setServiceId(response.getServiceId());
		reportFunctionEvent.setReportType(input.getParams().get().getReportType().get(0));
		reportFunctionEvent.setRequestId(input.getParams().get().getRequestId().get(0));
		EventManager.raiseBusinessEvent(ctx, new GenericEvent("PostHookEvent", reportFunctionEvent));
	}

}
