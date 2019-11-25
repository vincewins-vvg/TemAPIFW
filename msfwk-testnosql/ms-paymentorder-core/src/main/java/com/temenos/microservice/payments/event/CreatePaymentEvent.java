package com.temenos.microservice.payments.event;

import com.temenos.inbox.outbox.core.GenericEvent;

public class CreatePaymentEvent {

	private java.lang.String paymentOrderId;

	private java.lang.String debitAccount;

	private java.lang.String creditAccount;

	private java.math.BigDecimal amount;

	private java.lang.String currency;

	public java.lang.String getPaymentOrderId() {
		return paymentOrderId;
	}

	public void setPaymentOrderId(java.lang.String paymentOrderId) {
		this.paymentOrderId = paymentOrderId;
	}

	public java.lang.String getDebitAccount() {
		return debitAccount;
	}

	public void setDebitAccount(java.lang.String debitAccount) {
		this.debitAccount = debitAccount;
	}

	public java.lang.String getCreditAccount() {
		return creditAccount;
	}

	public void setCreditAccount(java.lang.String creditAccount) {
		this.creditAccount = creditAccount;
	}

	public java.math.BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(java.math.BigDecimal amount) {
		this.amount = amount;
	}

	public java.lang.String getCurrency() {
		return currency;
	}

	public void setCurrency(java.lang.String currency) {
		this.currency = currency;
	}

}
