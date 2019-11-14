package com.temenos.microservice.payments.ingester;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.ingester.BinaryIngesterUpdater;
import com.temenos.microservice.framework.core.util.EventStreamCheckUtility;
import com.temenos.microservice.kafka.util.KafkaStreamProducer;

public class PaymentOrderStateIngester extends BinaryIngesterUpdater {

	static Boolean lagResult = false;

	private void callConsumer() {
		String businessGroupId = Environment.getEnvironmentVariable("temn.ingester.business.group.id",
				"msf-test-group-id");
		String topic = Environment.getEnvironmentVariable("temn.ingester.business.topic", "table-update-business");
		boolean result = false;
		for (int i = 0; i < 3; i++) {
			result = EventStreamCheckUtility.isConsumerGroupInLag(Arrays.asList("topic"), businessGroupId);
			if (result) {
				lagResult = result;
				List<byte[]> lagResultList = new ArrayList<>();
				lagResultList.add(lagResult.toString().getBytes());
				KafkaStreamProducer.postMessageToTopic("table-result", lagResultList);
				break;
			}
			if (i == 2 && result == false) {
				lagResult = result;
				List<byte[]> lagResultList = new ArrayList<>();
				lagResultList.add(lagResult.toString().getBytes());
				KafkaStreamProducer.postMessageToTopic("table-result", lagResultList);
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
	public void process() throws FunctionException {

	}

}
