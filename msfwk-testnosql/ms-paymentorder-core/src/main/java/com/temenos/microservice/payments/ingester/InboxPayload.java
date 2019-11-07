package com.temenos.microservice.payments.ingester;

public class InboxPayload {
	String params;
	String body;

	public String getParams() {
		return params;
	}

	public void setParams(String params) {
		this.params = params;
	}

	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}

}
