//***AUTO GENERATED CODE. DO NOT EDIT***.
package com.temenos.microservice.paymentorder.entity;
import com.temenos.microservice.framework.core.data.annotations.CollectionAnnotation;
import com.temenos.microservice.framework.core.data.mongodb.MongoEntity;
import com.temenos.microservice.framework.core.data.Entity;

import com.temenos.microservice.framework.core.data.BaseEntity;
import com.temenos.microservice.framework.core.data.annotations.*;
import java.util.HashMap;
import java.util.Map;

import org.bson.codecs.pojo.annotations.BsonId;
import org.bson.types.ObjectId;

import java.io.Serializable;
@CollectionAnnotation(partitionKey="paymentOrderId", tableName="ms_payment_order" , sortKey="debitAccount")
public class PaymentOrder extends BaseEntity implements Serializable, MongoEntity {
    private static final long serialVersionUID = 1L;
    @BsonId
	private ObjectId objectId;
    
    @PartitionKey
	private java.lang.String paymentOrderId;
    @SortKey
	private java.lang.String debitAccount;
    
	private java.lang.String creditAccount;
    
	private java.lang.String paymentReference;
    
	private java.lang.String paymentDetails;
    
	private java.util.Date paymentDate;
    
	private java.math.BigDecimal amount;
    
	private java.lang.String currency;
    
	private java.lang.String status;
    
	private PaymentMethod paymentMethod;
    
	private java.util.List<ExchangeRate> exchangeRates;
    
	private PayeeDetails payeeDetails;
    
	private java.nio.ByteBuffer fileContent;
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
    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(PaymentMethod paymentMethod) {
        	this.paymentMethod = paymentMethod;
    }
    public java.util.List<ExchangeRate> getExchangeRates() {
        return exchangeRates;
    }

    public void setExchangeRates(java.util.List<ExchangeRate> exchangeRates) {
        	this.exchangeRates = java.util.Collections.unmodifiableList(exchangeRates);
    }
    public PayeeDetails getPayeeDetails() {
        return payeeDetails;
    }

    public void setPayeeDetails(PayeeDetails payeeDetails) {
        	this.payeeDetails = payeeDetails;
    }
    public java.nio.ByteBuffer getFileContent() {
        return fileContent;
    }

    public void setFileContent(java.nio.ByteBuffer fileContent) {
        	this.fileContent = fileContent;
    }
	Map<String, String> extensionData = new HashMap<String, String>();
	
	public Map<String, String> getExtensionData() {
		return extensionData;
	}

	public void setExtensionData(Map<String, String> extensionData) {
		this.extensionData = extensionData;
	}
	
	@Override
	public ObjectId getObjectId() {
	
	return objectId;
}
	
	
}
