/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.entity;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.CascadeType;
import javax.persistence.CollectionTable;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Index;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.MapKeyColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.temenos.microservice.framework.core.data.ExtendableEntity;
import com.temenos.microservice.framework.core.data.JPAEntity;

@Entity
@Table(name = "ms_payment_order", indexes = { @Index(columnList = "paymentTxnRef") })
public class PaymentOrder implements ExtendableEntity {

	@Id
	private String paymentOrderId;

	@Version
	private int version;

	private String debitAccount;

	private String creditAccount;

	private String paymentReference;

	private String paymentDetails;

	@JsonFormat(pattern = "yyyyMMdd")
	private Date paymentDate;

	private BigDecimal amount;

	private String currency;

	private String status;

	private String paymentTxnRef;

	@OneToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "paymentMethod_id",columnDefinition="int")
	private PaymentMethod paymentMethod;

	public PaymentMethod getPaymentMethod() {
		return paymentMethod;
	}

	public void setPaymentMethod(PaymentMethod paymentMethod) {
		this.paymentMethod = paymentMethod;
	}

	public List<ExchangeRate> getExchangeRates() {
		return exchangeRates;
	}

	public void setExchangeRates(List<ExchangeRate> exchangeRates) {
		this.exchangeRates = exchangeRates;
	}

	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name = "exchangeRates_id",columnDefinition="long")
	private List<ExchangeRate> exchangeRates;

	@OneToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "payeeDetails_payeeId",columnDefinition="int")
	private PayeeDetails payeeDetails;

	// maps from attribute name to value
	@ElementCollection
	@MapKeyColumn(name = "name")
	@Column(name = "value")
	@CollectionTable(name = "PaymentOrder_extension", joinColumns = @JoinColumn(name = "PaymentOrder_paymentOrderId"))
	Map<String, String> extensionData = new HashMap<String, String>();

	@Lob
	@Column
	private String fileContent;

	public String getPaymentOrderId() {
		return paymentOrderId;
	}

	public void setPaymentOrderId(String paymentOrderId) {
		this.paymentOrderId = paymentOrderId;
	}

	public String getDebitAccount() {
		return debitAccount;
	}

	public void setDebitAccount(String debitAccount) {
		this.debitAccount = debitAccount;
	}

	public String getCreditAccount() {
		return creditAccount;
	}

	public void setCreditAccount(String creditAccount) {
		this.creditAccount = creditAccount;
	}

	public String getPaymentReference() {
		return paymentReference;
	}

	public void setPaymentReference(String paymentReference) {
		this.paymentReference = paymentReference;
	}

	public String getPaymentDetails() {
		return paymentDetails;
	}

	public void setPaymentDetails(String paymentDetails) {
		this.paymentDetails = paymentDetails;
	}

	public Date getPaymentDate() {
		return paymentDate;
	}

	public void setPaymentDate(Date paymentDate) {
		this.paymentDate = paymentDate;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public String getCurrency() {
		return currency;
	}

	public void setCurrency(String currency) {
		this.currency = currency;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public PayeeDetails getPayeeDetails() {
		return payeeDetails;
	}

	public void setPayeeDetails(PayeeDetails payeeDetails) {
		this.payeeDetails = payeeDetails;
	}

	@Override
	public Map<String, String> getExtensionData() {
		return extensionData;
	}

	public int getVersion() {
		return version;
	}

	public void setVersion(int version) {
		this.version = version;
	}

	@Override
	public void setExtensionData(Map<String, String> extensionData) {
		this.extensionData = extensionData;
	}

	public String getFileContent() {
		return fileContent;
	}

	public void setFileContent(String fileContent) {
		this.fileContent = fileContent;
	}

	public String getPaymentTxnRef() {
		return paymentTxnRef;
	}

	public void setPaymentTxnRef(String paymentTxnRef) {
		this.paymentTxnRef = paymentTxnRef;
	}
}
