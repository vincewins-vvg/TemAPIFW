package com.temenos.microservice.payments.ingester;

import java.util.Arrays;
import java.util.Map;

import org.json.JSONObject;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.ingester.BaseIngester;
import com.temenos.microservice.payments.entity.PaymentOrder;
import com.temenos.microservice.payments.view.EnumCurrency;

import com.temenos.microservice.payments.function.CreateNewPaymentOrderInput;

public class PaymentOrderIngesterCommandUpdater extends BaseIngester {
	private CreateNewPaymentOrderInput createNewPaymentOrderInput;
	
	public PaymentOrderIngesterCommandUpdater() {
	}

	@Override
	public void transform(JSONObject jsonObject) throws FunctionException {
		PaymentOrderRecord orderRecord = new PaymentOrderRecord(jsonObject);
		com.temenos.microservice.payments.view.PaymentOrder body = new com.temenos.microservice.payments.view.PaymentOrder();
		body.setAmount(orderRecord.getAmount());
		body.setCurrency(EnumCurrency.USD);
		body.setDescriptions(Arrays.asList("command flow"));
		body.setFromAccount(orderRecord.getDebitAccount());
		body.setToAccount(orderRecord.getCreditAccount());
		body.setPaymentReference(orderRecord.getPaymentReference());
		body.setPaymentDetails(orderRecord.getPaymentDetails());
		com.temenos.microservice.payments.view.PaymentMethod paymentMethod = new com.temenos.microservice.payments.view.PaymentMethod();
		paymentMethod.setId(4L);
		paymentMethod.setName("CARD");
		body.setPaymentMethod(paymentMethod);
		createNewPaymentOrderInput = new CreateNewPaymentOrderInput(body);
	
	}

	public Map<String, Entity> setEntityMap() {
		return null;
	}

	public Map<String, Object> setInstanceMap() {
		Map<String, Object> instanceMap = new java.util.HashMap<String, Object>();
		instanceMap.put("CreateNewPaymentOrder", createNewPaymentOrderInput);
		return instanceMap;
	}
}
