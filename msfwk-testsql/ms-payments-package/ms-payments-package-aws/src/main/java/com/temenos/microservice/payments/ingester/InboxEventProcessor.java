package com.temenos.microservice.payments.ingester;

import static com.temenos.microservice.framework.core.ingester.IngesterLogger.ingesterAlert;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.KinesisEvent;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.MSLogCode;
import com.temenos.microservice.framework.core.ingester.GenericCommandBinaryIngester;
import com.temenos.microservice.framework.core.ingester.Ingester;
import com.temenos.microservice.framework.ingester.config.ApplicationConfiguration;

public class InboxEventProcessor implements RequestHandler<KinesisEvent, String> {

	Ingester ingester;

	public InboxEventProcessor() {
		ApplicationConfiguration config = new ApplicationConfiguration();
		ingester = config.getIngester();
	}

	@Override
	public String handleRequest(KinesisEvent event, Context context) {
		GenericCommandBinaryIngester gcbi = new GenericCommandBinaryIngester();
		try {
			gcbi.transform(event.getRecords().get(0).getKinesis().getData().array());
			gcbi.process(null);
		} catch (FunctionException e) {
			e.printStackTrace();
			ingesterAlert.prepareError(MSLogCode.EVENT_PROCESSING_FAILED).tag("functionName", context.getFunctionName())
					.log();
			throw new RuntimeException(e);
		}

		return null;
	}
}