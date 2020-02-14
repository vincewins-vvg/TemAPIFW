package com.temenos.microservice.paymentorder.ingester;

public class InboxHeader {
	String operationId;

	public String getOperationId() {
		return operationId;
	}

	public void setOperationId(String operationId) {
		this.operationId = operationId;
	}
}
