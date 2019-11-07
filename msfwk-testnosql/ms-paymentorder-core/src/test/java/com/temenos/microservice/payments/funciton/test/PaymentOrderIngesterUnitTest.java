package com.temenos.microservice.payments.funciton.test;

import org.json.JSONObject;
import org.junit.Assert;
import org.junit.Test;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.ingester.IngesterGenericEvent;
import com.temenos.microservice.payments.ingester.PaymentorderIngesterUpdater;

public class PaymentOrderIngesterUnitTest {

	@Test
	public void paymentOrderIngesterTest() {

		 
		JSONObject record = new JSONObject();
		JSONObject object = new JSONObject(
				"{\"recId\":\"12345\",\"DebitAccount\":\"12345\",\"OrderingReference\":\"Hello\",\"CreditAccount\":\"654321\",\"PaymentCurrency\":\"USD\",\"PaymentExecutionDate\":\"20180101\",\"PaymentSystemStatus\":\"IN_PROGRESS\",\"TotalDebitAmount\":\"100\"}");
		record.put("payload", object);
		 
		PaymentorderIngesterUpdater paymentOrderIngester = new PaymentorderIngesterUpdater(record);
		try {
			paymentOrderIngester.update();
		} catch (FunctionException e) {
			 Assert.fail(e.getMessage());
		}
	}
}
