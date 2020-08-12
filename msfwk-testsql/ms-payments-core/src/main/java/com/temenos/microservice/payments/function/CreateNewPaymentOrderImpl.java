package com.temenos.microservice.payments.function;

import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.paymentorder.event.POFailedEvent;
import com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderInput;
import com.temenos.microservice.paymentorder.function.ResponseStatus;
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
	public PaymentStatus invoke(Context context, CreateNewPaymentOrderInput input) throws FunctionException {
		CreateNewPaymentOrderProcessor createNewPaymentOrderProcessor = (CreateNewPaymentOrderProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(CreateNewPaymentOrderProcessor.class);
		return createNewPaymentOrderProcessor.invoke(context, input);
	}

	@Override
	public void postHook(final Context ctx, final ResponseStatus responseStatus, final CreateNewPaymentOrderInput input,
			final PaymentStatus response) throws FunctionException {
		POFailedEvent poFailedEvent = new POFailedEvent();
		poFailedEvent.setAmount(input.getBody().get().getAmount());
		poFailedEvent.setCreditAccount(input.getBody().get().getToAccount());
		poFailedEvent.setCurrency(input.getBody().get().getCurrency().toString());
		poFailedEvent.setDebitAccount(input.getBody().get().getFromAccount());

		EventManager.raiseBusinessEvent(ctx, new GenericEvent("POAccepte", poFailedEvent));
	}

}
