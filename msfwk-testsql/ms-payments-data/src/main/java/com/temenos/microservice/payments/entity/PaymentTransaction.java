package com.temenos.microservice.payments.entity;

import java.util.HashMap;
import java.util.Map;

import javax.persistence.CollectionTable;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.MapKeyColumn;

import com.temenos.microservice.framework.core.data.ExtendableEntity;

@Entity
public class PaymentTransaction implements ExtendableEntity {

	@Id
	private java.lang.String recId;
	private java.lang.String companyCode;
	private java.lang.String amountLcy;
	private java.util.Date processingDate;
	private java.lang.String transactionCode;
	private java.util.Date valueDate;
	private java.lang.Long accountNumber;
	private java.lang.String ourReference;
	private java.lang.String theirReference;
	private java.lang.String accountOfficer;
	private java.lang.String transReference;
	private java.util.Date bookingDate;
	private java.lang.String customerId;
	private java.lang.String currency;
	@ElementCollection
	@MapKeyColumn(name = "name")
	@Column(name = "value")
	@CollectionTable(name = "PaymentTransaction_extension", joinColumns = @JoinColumn(name = "Transaction_recId"))
	Map<String, String> extensionData = new HashMap<String, String>();

	public Map<String, String> getExtensionData() {
		return extensionData;
	}

	public void setExtensionData(Map<String, String> extensionData) {
		this.extensionData = extensionData;
	}

	public java.lang.String getRecId() {
		return recId;
	}

	public void setRecId(java.lang.String recId) {
		this.recId = recId;
	}

	public java.lang.String getCompanyCode() {
		return companyCode;
	}

	public void setCompanyCode(java.lang.String companyCode) {
		this.companyCode = companyCode;
	}

	public java.lang.String getAmountLcy() {
		return amountLcy;
	}

	public void setAmountLcy(java.lang.String amountLcy) {
		this.amountLcy = amountLcy;
	}

	public java.util.Date getProcessingDate() {
		return processingDate;
	}

	public void setProcessingDate(java.util.Date processingDate) {
		this.processingDate = processingDate;
	}

	public java.lang.String getTransactionCode() {
		return transactionCode;
	}

	public void setTransactionCode(java.lang.String transactionCode) {
		this.transactionCode = transactionCode;
	}

	public java.util.Date getValueDate() {
		return valueDate;
	}

	public void setValueDate(java.util.Date valueDate) {
		this.valueDate = valueDate;
	}

	public java.lang.Long getAccountNumber() {
		return accountNumber;
	}

	public void setAccountNumber(java.lang.Long accountNumber) {
		this.accountNumber = accountNumber;
	}

	public java.lang.String getOurReference() {
		return ourReference;
	}

	public void setOurReference(java.lang.String ourReference) {
		this.ourReference = ourReference;
	}

	public java.lang.String getTheirReference() {
		return theirReference;
	}

	public void setTheirReference(java.lang.String theirReference) {
		this.theirReference = theirReference;
	}

	public java.lang.String getAccountOfficer() {
		return accountOfficer;
	}

	public void setAccountOfficer(java.lang.String accountOfficer) {
		this.accountOfficer = accountOfficer;
	}

	public java.lang.String getTransReference() {
		return transReference;
	}

	public void setTransReference(java.lang.String transReference) {
		this.transReference = transReference;
	}

	public java.util.Date getBookingDate() {
		return bookingDate;
	}

	public void setBookingDate(java.util.Date bookingDate) {
		this.bookingDate = bookingDate;
	}

	public java.lang.String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(java.lang.String customerId) {
		this.customerId = customerId;
	}

	public java.lang.String getCurrency() {
		return currency;
	}

	public void setCurrency(java.lang.String currency) {
		this.currency = currency;
	}
}
