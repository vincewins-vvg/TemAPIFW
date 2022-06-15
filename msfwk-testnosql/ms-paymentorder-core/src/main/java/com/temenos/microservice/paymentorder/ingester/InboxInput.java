/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.paymentorder.ingester;

import com.temenos.microservice.paymentorder.function.CreateNewPaymentOrderInput;

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
