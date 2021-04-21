package com.temenos.microservice.payments.ingester;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.ingester.BinaryIngesterUpdater;
import com.temenos.microservice.framework.core.ingester.MSStreamProducer;
import com.temenos.microservice.framework.core.ingester.MSStreamProducerFactory;
import com.temenos.microservice.framework.core.util.EventStreamCheckUtility;

public class PaymentOrderStateIngester extends BinaryIngesterUpdater {

	private void callConsumer() {
		String businessGroupId = Environment.getEnvironmentVariable("temn.ingester.business.group.id",
				"msf-test-group-id");
		String topic = Environment.getEnvironmentVariable("temn.ingester.business.topic", "table-update-business");
		boolean result = false;
		Map<String, List<String>> headersMap = new HashMap<>();
		Map<String, List<String>> topicConsumerInfo = new HashMap<>();
		topicConsumerInfo.put(businessGroupId, Arrays.asList(topic));
		for (int i = 0; i < 3; i++) {
			result = EventStreamCheckUtility.isConsumerGroupInLag(topicConsumerInfo, headersMap);
			if (!result) {
				MSStreamProducer producer = MSStreamProducerFactory.getProducer();
		        producer.sendToStream("table-result", new String("success"));
				break;
			}
			if (i == 2 && result) {
				MSStreamProducer producer = MSStreamProducerFactory.getProducer();
		        producer.sendToStream("table-result", new String("failure"));
				break;
			}
		}

	}

	@Override
	public void transform(byte[] binaryObject) throws FunctionException {
		try {
			String mode = new String(binaryObject);
			if (mode.equals("prep")) {
				callConsumer();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void process(Context context) throws FunctionException {
		// TODO Auto-generated method stub

	}

}
