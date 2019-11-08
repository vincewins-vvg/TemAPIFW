package com.temenos.microservice.payments.function;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.kafka.util.KafkaStreamProducer;
import com.temenos.microservice.payments.view.PaymentOrder;
import com.temenos.microservice.payments.view.PaymentOrderStatus;

public class InvokePaymentOrderImpl implements InvokePaymentState {

	@Override
	public PaymentOrderStatus invoke(Context ctx, InvokePaymentStateInput input) throws FunctionException {
		if (input.getParams().get().getPaymentStateIds().get(0).equals("prep")) {
			List<byte[]> messageList = new ArrayList<>();
			messageList.add(new String("prep").getBytes());
			String stateTopic = Environment.getEnvironmentVariable("temn.msf.ingest.state.source.stream",
					"table-update-state");
			KafkaStreamProducer.postMessageToTopic(stateTopic, messageList);
		}
		PaymentOrderStatus status = new PaymentOrderStatus();
		PaymentOrder paymentOrder = new PaymentOrder();
		paymentOrder.setAmount(BigDecimal.valueOf(100.0));
		status.setPaymentOrder(paymentOrder);
		return status;
	}

}