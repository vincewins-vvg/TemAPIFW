// TODO: to be generated
package com.temenos.microservice.payments.function;

import java.io.IOException;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.temenos.inbox.outbox.core.CommandProcessor;
import com.temenos.inbox.outbox.core.InboxStatus;
import com.temenos.inbox.outbox.data.InboxEvent;
import com.temenos.inbox.outbox.function.InboxFunction;
import com.temenos.inbox.outbox.thread.OutboxThread;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.data.MSTransaction;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.RequestContext;
import com.temenos.microservice.framework.core.function.RequestImpl;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.payments.view.PaymentStatus;

public class PaymentOrderCommandProcessor implements CommandProcessor {

	@Override
	public void processCommand(InboxEvent inboxEvent) {
		String operationId = inboxEvent.getEventname().split("\\.")[1];
		ObjectMapper mapper = new ObjectMapper();
		RequestContext context = new RequestContext(new RequestImpl());
		MSTransaction.beginTransaction();
		try {
			switch (operationId) {
			case "CreateNewPaymentOrder":
				CreateNewPaymentOrderInput input = mapper.readValue(inboxEvent.getPayload(),
						CreateNewPaymentOrderInput.class);
				PaymentStatus paymentStatus = new CreateNewPaymentOrderImpl().invoke(context, input);
				raiseCommandProcessedEvent(context, paymentStatus);
				inboxEvent.setStatus(InboxStatus.PROCESSED.toString());
				InboxFunction.updateInboxEvent(inboxEvent);
			}
			MSTransaction.commit();
		} catch (JsonParseException e) {
			e.printStackTrace(); // TODO: Update inbox status as Failed and raise "Command.Failed"
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (FunctionException e) {
			e.printStackTrace();
		}
		if (!Environment.serverless()) {
			try {
				// TODO: instead of generic place holder, add specific holder for managing event
				// ids.
				for (String outboxEventId : context.getRequest().getHeaders().get("outboxEventId")) {
					OutboxThread.getQueue().put(outboxEventId);
				}
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}

	private void raiseCommandProcessedEvent(Context ctx, PaymentStatus paymentStatus) throws FunctionException {
		String payload = null;
		ObjectMapper Obj = new ObjectMapper();
		try {
			payload = Obj.writeValueAsString(paymentStatus);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		EventManager.raiseCommandProcessedEvent(ctx, payload);
	}

	@Override
	public void processEvent(InboxEvent inboxEvent) {
		// TODO to be implemented

	}

}
