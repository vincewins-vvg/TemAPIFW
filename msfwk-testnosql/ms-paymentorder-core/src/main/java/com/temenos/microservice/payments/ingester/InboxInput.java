package com.temenos.microservice.payments.ingester;

import com.temenos.microservice.payments.function.CreateNewPaymentOrderInput;

public class InboxInput {
	InboxHeader header;
	CreateNewPaymentOrderInput payload;

	public InboxHeader getHeader() {
		return header;
	}

	public void setHeader(InboxHeader header) {
		this.header = header;
	}

	public CreateNewPaymentOrderInput getPayload() {
		return payload;
	}

	public void setPayload(CreateNewPaymentOrderInput payload) {
		this.payload = payload;
	}
}
