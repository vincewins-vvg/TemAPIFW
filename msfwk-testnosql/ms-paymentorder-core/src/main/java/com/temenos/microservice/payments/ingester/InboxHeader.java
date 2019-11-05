package com.temenos.microservice.payments.ingester;

public class InboxHeader {
	String operationId;

	public String getOperationId() {
		return operationId;
	}

	public void setOperationId(String operationId) {
		this.operationId = operationId;
	}
}
