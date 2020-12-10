package com.temenos.microservice.payments.function;

import java.util.List;
import java.util.Map;

import com.temenos.connect.InboxOutbox.logger.InboxOutboxConstants;
import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.OutOfSequenceException;
import com.temenos.microservice.framework.core.function.Request;
import com.temenos.microservice.framework.core.function.ResponseStatus;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.framework.core.util.SequenceUtil;
import com.temenos.microservice.payments.core.CreateNewPaymentOrderProcessor;
import com.temenos.microservice.payments.event.POFailedEvent;
import com.temenos.microservice.payments.view.PaymentStatus;

/**
 * CreateNewPaymentOrderImpl.
 * 
 * @author kdhanraj
 *
 */

public class CreateNewPaymentOrderImpl implements CreateNewPaymentOrder {

	@Override
	public PaymentStatus invoke(Context context, CreateNewPaymentOrderInput input) throws FunctionException {
		CreateNewPaymentOrderProcessor createNewPaymentOrderProcessor = (CreateNewPaymentOrderProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(CreateNewPaymentOrderProcessor.class);
		return createNewPaymentOrderProcessor.invoke(context, input);
	}

	@Override
	public void postHook(final Context ctx, final ResponseStatus responseStatus, final CreateNewPaymentOrderInput input,
			final PaymentStatus response) throws FunctionException {
		CreateNewPaymentOrderProcessor createNewPaymentOrderProcessor = (CreateNewPaymentOrderProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(CreateNewPaymentOrderProcessor.class);
		createNewPaymentOrderProcessor.errorGenerationBasedOnInput(input, "postHook");
		POFailedEvent poFailedEvent = new POFailedEvent();
		poFailedEvent.setAmount(input.getBody().get().getAmount());
		poFailedEvent.setCreditAccount(input.getBody().get().getToAccount());
		poFailedEvent.setCurrency(input.getBody().get().getCurrency().toString());
		poFailedEvent.setDebitAccount(input.getBody().get().getFromAccount());
		EventManager.raiseBusinessEvent(ctx, new GenericEvent("PostHookEvent", poFailedEvent));
	}
	@Override
	public void preHook(final Context ctx, final CreateNewPaymentOrderInput input) throws FunctionException {
		CreateNewPaymentOrderProcessor createNewPaymentOrderProcessor = (CreateNewPaymentOrderProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(CreateNewPaymentOrderProcessor.class);
		createNewPaymentOrderProcessor.errorGenerationBasedOnInput(input, "preHook");
		POFailedEvent poFailedEvent = new POFailedEvent();
		poFailedEvent.setAmount(input.getBody().get().getAmount());
		poFailedEvent.setCreditAccount(input.getBody().get().getToAccount());
		poFailedEvent.setCurrency(input.getBody().get().getCurrency().toString());
		poFailedEvent.setDebitAccount(input.getBody().get().getFromAccount());
		EventManager.raiseBusinessEvent(ctx, new GenericEvent("PreHookEvent", poFailedEvent));
	}
	
	@Override
	public void isSequenceValid(final Context ctx) throws FunctionException {
		Request<String> request = (Request<String>) ctx.getRequest();
		Map<String,List<String>> headers = request.getHeaders();
		List<String> businessKeys = headers.get(InboxOutboxConstants.BUSINESS_KEY);
		List<String> sequenceNos = headers.get(InboxOutboxConstants.SEQUENCE_NO);
		List<String> sourceIds = headers.get(InboxOutboxConstants.EVENT_SOURCE);
		String businessKey = (businessKeys != null && !businessKeys.isEmpty()) ? businessKeys.get(0) : null;
		if (businessKey != null) {
			Long sequenceNo = (sequenceNos != null && !sequenceNos.isEmpty()) ? Long.valueOf(sequenceNos.get(0)) : null;
			String sourceId = (sourceIds != null && !sourceIds.isEmpty()) ? sourceIds.get(0) : null;
			Long expectedSequenceNo = SequenceUtil.generateSequenceNumber(businessKey, sourceId);
			if (sequenceNo == null || !expectedSequenceNo.equals(sequenceNo)) {
				throw new OutOfSequenceException("Invalid sequence number: " + sequenceNo);
			} 
		}
	}
}
