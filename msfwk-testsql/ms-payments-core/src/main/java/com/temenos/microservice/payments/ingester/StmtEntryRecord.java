package com.temenos.microservice.payments.ingester;

import org.json.JSONArray;
import org.json.JSONObject;

public class StmtEntryRecord {

	private JSONObject sourceRecord;

	private String companyCode = "";
	private String accountNumber = "";
	private String valueDate = "";
	private String bookingDate = "";
	private String processingDate = "";
	private String customerId = "";
	private String recId = "";
	private String accountOfficer = "";
	private String transactionCode = "";
	private String amountLcy = "";
	private String currency = "";
	private String amountFcy = "";
	private String exchangeRate = "";
	private String theirReference = "";
	private String ourReference = "";
	private String transReference = "";
	private String narrative = "";
	private String tradeDate = "";


	public StmtEntryRecord(JSONObject sourceRecord) {
		this.sourceRecord = sourceRecord;
		transform();
	}

	public String companyCode() {
		return companyCode;
	}

	public String accountNumber() {
		return accountNumber;
	}

	public String valueDate() {
		return valueDate;
	}

	public String bookingDate() {
		return bookingDate;
	}

	public String processingDate() {
		return processingDate;
	}

	public String customerId() {
		return customerId;
	}

	public String recId() {
		return recId;
	}

	public String accountOfficer() {
		return accountOfficer;
	}

	public String transactionCode() {
		return transactionCode;
	}

	public String amountLcy() {
		return amountLcy;
	}

	public String currency() {
		return currency;
	}

	public String amountFcy() {
		return amountFcy;
	}

	public String exchangeRate() {
		return exchangeRate;
	}

	public String theirReference() {
		return theirReference;
	}

	public String ourReference() {
		return ourReference;
	}

	public String transReference() {
		return transReference;
	}

	public String narrative() {
		return narrative;
	}

	public String tradeDate() {
		return tradeDate;
	}

	private void transform() {
		JSONObject payload = sourceRecord.getJSONObject("payload");
		recId = payload.optString("recId");

		// Fields
		accountNumber = payload.optString("AccountNumber");
		companyCode = payload.optString("CompanyCode");
		amountLcy = payload.optString("AmountLcy");
		transactionCode = payload.optString("TransactionCode");
		theirReference = payload.optString("TheirReference");
		JSONArray narrativeArr = payload.getJSONArray("ARRAY_Narrative");
		if (narrativeArr != null) {
			JSONObject narrativeObj = narrativeArr.optJSONObject(0);
			if (narrativeObj != null) {
				narrative = narrativeObj.optString("Narrative");
			}
		}
		customerId = payload.optString("CustomerId");
		accountOfficer = payload.optString("AccountOfficer");
		valueDate = payload.optString("ValueDate");
		currency = payload.optString("Currency");
		amountFcy = payload.optString("AmountFcy");
		exchangeRate = payload.optString("ExchangeRate");
		ourReference = payload.optString("OurReference");
		transReference = payload.optString("TransReference");
		bookingDate = payload.optString("BookingDate");
		processingDate = payload.optString("ProcessingDate");
		tradeDate = payload.optString("TradeDate");
	}

	@Override
	public String toString() {
		return "StmtEntryRecord [accountNumber=" + accountNumber + ", valueDate=" + valueDate + ", bookingDate="
				+ bookingDate + ", processingDate=" + processingDate + ", customerId=" + customerId + ", recId=" + recId
				+ ", accountOfficer=" + accountOfficer + ", productCategory=" + transactionCode + ", amountLcy="
				+ amountLcy + ", currency=" + currency + ", amountFcy=" + amountFcy + ", exchangeRate=" + exchangeRate
				+ ", theirReference=" + theirReference + ", ourReference=" + ourReference + ", transReference="
				+ transReference + ", narrative=" + narrative + ", tradeDate=" + tradeDate + "]";
	}
}