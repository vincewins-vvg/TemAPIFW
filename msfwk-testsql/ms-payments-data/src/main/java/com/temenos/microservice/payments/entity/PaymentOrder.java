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
import javax.persistence.JoinColumn;
import javax.persistence.MapKeyColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import com.temenos.microservice.framework.core.data.ExtendableEntity;
import com.temenos.microservice.framework.core.data.JPAEntity;

@Entity
@Table(name = "ms_payment_order")
public class PaymentOrder extends JPAEntity implements ExtendableEntity {

	@Id
	private String paymentOrderId;

	private String debitAccount;

	private String creditAccount;

	private String paymentReference;

	private String paymentDetails;

	private Date paymentDate;

	private BigDecimal amount;

	private String currency;

	private String status;

	@OneToOne(cascade = CascadeType.ALL)
	private PaymentMethod paymentMethod;

	@OneToMany(cascade = CascadeType.ALL)
	private List<ExchangeRate> exchangeRates;

	@OneToOne(cascade = CascadeType.ALL)
	private PayeeDetails payeeDetails;

	// maps from attribute name to value
	@ElementCollection
	@MapKeyColumn(name = "name")
	@Column(name = "value")
	@CollectionTable(name = "PaymentOrder_extension", joinColumns = @JoinColumn(name = "PaymentOrder_paymentOrderId"))
	Map<String, String> extensionData = new HashMap<String, String>();

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

	@Override
	public void setExtensionData(Map<String, String> extensionData) {
		this.extensionData = extensionData;
	}

}