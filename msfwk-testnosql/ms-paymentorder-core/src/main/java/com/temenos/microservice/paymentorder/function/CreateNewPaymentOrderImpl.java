package com.temenos.microservice.paymentorder.function;

import java.nio.ByteBuffer;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.paymentorder.entity.Card;
import com.temenos.microservice.paymentorder.event.CreatePaymentEvent;
import com.temenos.microservice.paymentorder.view.ExchangeRate;
import com.temenos.microservice.paymentorder.view.PaymentOrder;
import com.temenos.microservice.paymentorder.view.PaymentStatus;

/**
 * CreateNewPaymentOrderImpl.
 * 
 * @author kdhanraj
 *
 */
public class CreateNewPaymentOrderImpl implements CreateNewPaymentOrder {

	@Override
	public PaymentStatus invoke(Context ctx, CreateNewPaymentOrderInput input) throws FunctionException {
		PaymentOrderFunctionHelper.validateInput(input);

		PaymentOrder paymentOrder = input.getBody().get();
		PaymentOrderFunctionHelper.validatePaymentOrder(paymentOrder);

		PaymentStatus paymentStatus = executePaymentOrder(ctx, paymentOrder);
		return paymentStatus;
	}

	private PaymentStatus executePaymentOrder(Context ctx, PaymentOrder paymentOrder) throws FunctionException {
		String paymentOrderId = ("PO~" + paymentOrder.getFromAccount() + "~" + paymentOrder.getToAccount() + "~"
				+ paymentOrder.getCurrency() + "~" + paymentOrder.getAmount()).toUpperCase();
		com.temenos.microservice.paymentorder.entity.PaymentOrder entity = createEntity(paymentOrderId, paymentOrder);
		// Business event raised from payment order microservice
		CreatePaymentEvent paymentOrderEvent = new CreatePaymentEvent();
		paymentOrderEvent.setPaymentOrderId(entity.getPaymentOrderId());
		paymentOrderEvent.setAmount(entity.getAmount());
		paymentOrderEvent.setCreditAccount(entity.getCreditAccount());
		paymentOrderEvent.setCurrency(entity.getCurrency());
		paymentOrderEvent.setDebitAccount(entity.getDebitAccount());

		EventManager.raiseBusinessEvent(ctx,
				new GenericEvent(Environment.getMSName() + ".PaymentOrderCreated", paymentOrderEvent));
		return readStatus(entity);
	}

	private com.temenos.microservice.paymentorder.entity.PaymentOrder createEntity(String paymentOrderId,
			PaymentOrder view) throws FunctionException {
		com.temenos.microservice.paymentorder.entity.PaymentOrder entity = new com.temenos.microservice.paymentorder.entity.PaymentOrder();
		com.temenos.microservice.paymentorder.entity.PaymentMethod method = new com.temenos.microservice.paymentorder.entity.PaymentMethod();
		com.temenos.microservice.paymentorder.entity.ExchangeRate exchangeRate = null;
		List<com.temenos.microservice.paymentorder.entity.ExchangeRate> exchangeRates = new ArrayList<com.temenos.microservice.paymentorder.entity.ExchangeRate>();

		entity.setPaymentOrderId(paymentOrderId);
		entity.setAmount(view.getAmount());
		entity.setCreditAccount(view.getToAccount());
		entity.setDebitAccount(view.getFromAccount());
		entity.setPaymentDate(Date.from(Instant.now()));
		entity.setCurrency(view.getCurrency());
		entity.setPaymentReference(view.getPaymentReference());
		entity.setPaymentDetails(view.getPaymentDetails());
		entity.setStatus("INITIATED");
		entity.setPaymentMethod(method);
		entity.setExtensionData((Map<String, String>) view.getExtensionData());
		if (view.getFileContent() != null) {
			entity.setFileContent(view.getFileContent());
		}
		if (view.getPaymentMethod() != null) {
			entity.getPaymentMethod().setId(view.getPaymentMethod().getId());
			entity.getPaymentMethod().setName(view.getPaymentMethod().getName());
			if (view.getPaymentMethod().getCard() != null) {
				Card card = new Card();
				card.setCardid(view.getPaymentMethod().getCard().getCardid());
				card.setCardname(view.getPaymentMethod().getCard().getCardname());
				card.setCardlimit(view.getPaymentMethod().getCard().getCardlimit());
				entity.getPaymentMethod().setCard(card);
			}
		}
		if (view.getExchangeRates() != null) {
			for (ExchangeRate exchange : view.getExchangeRates()) {
				exchangeRate = new com.temenos.microservice.paymentorder.entity.ExchangeRate();
				exchangeRate.setId(exchange.getId());
				exchangeRate.setName(exchange.getName());
				exchangeRate.setValue(exchange.getValue());
				exchangeRates.add(exchangeRate);
			}
		}
		entity.setExchangeRates(exchangeRates);
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
		paymentOrderDao.saveEntity(entity);
		return entity;
	}

	private PaymentStatus readStatus(com.temenos.microservice.paymentorder.entity.PaymentOrder paymentOrder)
			throws FunctionException {
		PaymentStatus paymentStatus = new PaymentStatus();
		paymentStatus.setPaymentId(paymentOrder.getPaymentOrderId());
		paymentStatus.setStatus(paymentOrder.getStatus());
		paymentStatus.setDetails(paymentOrder.getPaymentDetails());
		return paymentStatus;
	}

}
