package com.temenos.microservice.payments.ingester.test;

import org.junit.Test;

import com.temenos.des.eventtransformer.data.parse.data.DynamicArrayBuilder;
import com.temenos.des.eventtransformer.data.parse.marker.RuntimeMarker;
import com.temenos.des.eventtransformer.data.parse.marker.TAFJMarker;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.test.streams.ITestProducer;

@org.junit.Ignore
public class IngesterITTest {

	private static final RuntimeMarker MARKER = new TAFJMarker();
	private static ITestProducer producer;
	private static final String AVRO_MESSAGE = getIFDataEvent();

	private static String getIFDataEvent() {
		return new DynamicArrayBuilder(MARKER).value("1544460586.405").fm(4).value("PAYMENT.ORDER")
				.fm().value("abc~123~zyz").fm().lfm(9)
				.value("12121").lfm(5).value("IngesterTest").lfm(3).value("52521").lfm(47)
				.value("USF").lfm(4).value("20190610").lfm(29).value("IN_PROGRESS").lfm(71).value("100.00").fm().build();
	}

	@Test
	public void ingestEvent() {
		producer = new ITestProducer("paymentorder-test", Environment
				.getEnvironmentVariable("localSchemaNamesAsCSVOrRemoteSchemaURL", 
						"localhost:8081"));
		producer.sendAsGenericEvent(AVRO_MESSAGE);
	}

}
