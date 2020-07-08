package com.temenos.microservice.paymentorder.function;

import static com.temenos.microservice.framework.core.util.OpenAPIUtil.formatDate;

import java.util.ArrayList;
import java.util.List;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.paymentorder.view.ExchangeRate;
import com.temenos.microservice.paymentorder.view.EnumCurrency;

import com.temenos.microservice.paymentorder.view.GetPaymentOrderCurrencyParams;
import com.temenos.microservice.paymentorder.view.PaymentOrder;
import com.temenos.microservice.paymentorder.view.PaymentOrders;

import com.temenos.microservice.framework.core.security.Criteria;
import com.temenos.microservice.framework.core.security.Criterion;
import com.temenos.microservice.framework.core.security.CriterionImpl;
import com.temenos.microservice.framework.core.data.Operator;

public class GetPaymentOrderCurrencyImpl implements GetPaymentOrderCurrency {

	@Override
	public PaymentOrders invoke(Context ctx, GetPaymentOrderCurrencyInput input) throws FunctionException {
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);
		List<com.temenos.microservice.paymentorder.entity.PaymentOrder> entities = null;
		if (input.getParams().get() != null) {
			GetPaymentOrderCurrencyParams params = input.getParams().get();
			validateParam(params);
			Criteria criteria = new Criteria();
			Criterion<Object> criterion = new CriterionImpl("currency", input.getParams().get().getCurrency().get(0),
					Operator.equal);
			criteria.add(criterion);
			entities = paymentOrderDao.getByIndexes(criteria);
		} else {
			entities = paymentOrderDao.get();
		}
		PaymentOrders orders = new PaymentOrders();
		for (com.temenos.microservice.paymentorder.entity.PaymentOrder entity : entities) {
			PaymentOrder view = new PaymentOrder();
			view.setAmount(entity.getAmount());
			view.setCurrency(Enum.valueOf(EnumCurrency.class, entity.getCurrency()));
			view.setFromAccount(entity.getDebitAccount());
			view.setToAccount(entity.getCreditAccount());
			view.setFileContent(entity.getFileContent());
			view.setPaymentDate(formatDate(entity.getPaymentDate()));
			view.setExtensionData(entity.getExtensionData());

			com.temenos.microservice.paymentorder.view.Card card = new com.temenos.microservice.paymentorder.view.Card();
			if (entity.getPaymentMethod() != null) {
				if (entity.getPaymentMethod().getCard() != null) {
					card.setCardid(entity.getPaymentMethod().getCard().getCardid());
					card.setCardname(entity.getPaymentMethod().getCard().getCardname());
					card.setCardlimit(entity.getPaymentMethod().getCard().getCardlimit());
				}

				com.temenos.microservice.paymentorder.view.PaymentMethod paymentMethod = new com.temenos.microservice.paymentorder.view.PaymentMethod();
				paymentMethod.setId(entity.getPaymentMethod().getId());
				paymentMethod.setName(entity.getPaymentMethod().getName());
				paymentMethod.setCard(card);
				view.setPaymentMethod(paymentMethod);

				List<ExchangeRate> exchangeRates = new ArrayList<ExchangeRate>();
				for (com.temenos.microservice.paymentorder.entity.ExchangeRate erEntity : entity.getExchangeRates()) {
					ExchangeRate exchangeRate = new ExchangeRate();
					exchangeRate.setId(erEntity.getId());
					exchangeRate.setName(erEntity.getName());
					exchangeRate.setValue(erEntity.getValue());
					exchangeRates.add(exchangeRate);
				}
				view.setExchangeRates(exchangeRates);

				com.temenos.microservice.paymentorder.view.PayeeDetails payeeDtls = new com.temenos.microservice.paymentorder.view.PayeeDetails();
				if (entity.getPayeeDetails() != null) {
					payeeDtls.setPayeeName(entity.getPayeeDetails().getPayeeName());
					payeeDtls.setPayeeType(entity.getPayeeDetails().getPayeeType());
					view.setPayeeDetails(payeeDtls);
				}
			}
			orders.add(view);
		}
		return orders;
	}

	private void validateParam(GetPaymentOrderCurrencyParams params) throws InvalidInputException {
		List<String> currencyId = params.getCurrency();
		if (currencyId.size() != 1) {
			throw new InvalidInputException(
					new FailureMessage("Invalid CurrencyId param. Only one CurrencyId expected", "PAYM-PORD-A-2002"));
		}
		if (currencyId.get(0).isEmpty()) {
			throw new InvalidInputException(
					new FailureMessage("Invalid CurrencyId param. CurrencyId is empty", "PAYM-PORD-A-2003"));
		}
	}

}
