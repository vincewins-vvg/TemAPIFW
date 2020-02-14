package com.temenos.ms.iris.sample.TestService;

import org.apache.camel.Exchange;
import org.apache.camel.Processor;
//com.temenos.ms.iris.sample.TestService.TestMessageProcessor
public class TestMessageProcessor implements Processor{

	@Override
	public void process(Exchange exchange) throws Exception {
		 String payload = exchange.getIn().getBody(String.class);
		 System.out.println("Received Message:{"+payload+"}");
		
	}

}
