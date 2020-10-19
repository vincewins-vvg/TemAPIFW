package com.temenos.microservice.paymentorder.ingester;

import java.math.BigDecimal;
import java.text.ParseException;

import org.json.JSONException;
import org.json.JSONObject;

import com.temenos.microservice.framework.core.util.DataTypeConverter;

public class PaymentOrderRecord {

	private JSONObject sourceRecord;

	private java.lang.String paymentOrderId;

	private java.lang.String debitAccount;

	private java.lang.String creditAccount;

	private java.lang.String paymentReference;

	private java.lang.String paymentDetails;

	private java.util.Date paymentDate;

	private java.math.BigDecimal amount;

	private java.lang.String currency;

	private java.lang.String status;

	public PaymentOrderRecord(JSONObject jsonObject) {
		this.sourceRecord = jsonObject;
		transform();
	}

	private void transform() {
		JSONObject payload = sourceRecord.getJSONObject("payload");
		if("".equalsIgnoreCase(payload.optString("recId"))) {
			throw new RuntimeException("Paymentorder id null");
		}
		this.paymentOrderId = payload.optString("recId");
		this.debitAccount = payload.getString("DebitAccount"); // 10
		this.paymentReference = payload.getString("OrderingReference"); // 15
		this.paymentDetails = payload.getString("OrderingReference"); // 15
		this.creditAccount = payload.getString("CreditAccount"); // 18
		this.currency = payload.getString("PaymentCurrency"); // 65
		try {
			this.paymentDate = DataTypeConverter.toDate(
					payload.getString("PaymentExecutionDate")); // 69
		} catch (JSONException | ParseException e) {
			return;
		}
		this.status = payload.getString("PaymentSystemStatus"); // 98
		this.amount = new BigDecimal(payload.getString("TotalDebitAmount")); // 169
	}

	public JSONObject getSourceRecord() {
		return sourceRecord;
	}

	public void setSourceRecord(JSONObject sourceRecord) {
		this.sourceRecord = sourceRecord;
	}

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

	public java.lang.String getPaymentReference() {
		return paymentReference;
	}

	public void setPaymentReference(java.lang.String paymentReference) {
		this.paymentReference = paymentReference;
	}

	public java.lang.String getPaymentDetails() {
		return paymentDetails;
	}

	public void setPaymentDetails(java.lang.String paymentDetails) {
		this.paymentDetails = paymentDetails;
	}

	public java.util.Date getPaymentDate() {
		return paymentDate;
	}

	public void setPaymentDate(java.util.Date paymentDate) {
		this.paymentDate = paymentDate;
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

	public java.lang.String getStatus() {
		return status;
	}

	public void setStatus(java.lang.String status) {
		this.status = status;
	}
}
