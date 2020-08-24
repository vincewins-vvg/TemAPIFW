package com.temenos.microservice.payments.entity;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class Balance implements com.temenos.microservice.framework.core.data.Entity {

	@Id
	private java.lang.String recId;
	private java.lang.String stmtProcDate;
	private java.lang.String coCode;
	private java.math.BigDecimal onlineClearedBal;
	private java.math.BigDecimal workingBalance;
	private java.math.BigDecimal onlineActualBal;
	private java.lang.String currency;
	private java.lang.String customer;
	private java.lang.String product;
	private java.util.Date processingTime;
	public java.lang.String getRecId() {
		return recId;
	}
	public void setRecId(java.lang.String recId) {
		this.recId = recId;
	}
	public java.lang.String getStmtProcDate() {
		return stmtProcDate;
	}
	public void setStmtProcDate(java.lang.String stmtProcDate) {
		this.stmtProcDate = stmtProcDate;
	}
	public java.lang.String getCoCode() {
		return coCode;
	}
	public void setCoCode(java.lang.String coCode) {
		this.coCode = coCode;
	}
	public java.math.BigDecimal getOnlineClearedBal() {
		return onlineClearedBal;
	}
	public void setOnlineClearedBal(java.math.BigDecimal onlineClearedBal) {
		this.onlineClearedBal = onlineClearedBal;
	}
	public java.math.BigDecimal getWorkingBalance() {
		return workingBalance;
	}
	public void setWorkingBalance(java.math.BigDecimal workingBalance) {
		this.workingBalance = workingBalance;
	}
	public java.math.BigDecimal getOnlineActualBal() {
		return onlineActualBal;
	}
	public void setOnlineActualBal(java.math.BigDecimal onlineActualBal) {
		this.onlineActualBal = onlineActualBal;
	}
	public java.lang.String getCurrency() {
		return currency;
	}
	public void setCurrency(java.lang.String currency) {
		this.currency = currency;
	}
	public java.lang.String getCustomer() {
		return customer;
	}
	public void setCustomer(java.lang.String customer) {
		this.customer = customer;
	}
	public java.lang.String getProduct() {
		return product;
	}
	public void setProduct(java.lang.String product) {
		this.product = product;
	}
	public java.util.Date getProcessingTime() {
		return processingTime;
	}
	public void setProcessingTime(java.util.Date processingTime) {
		this.processingTime = processingTime;
	}
	
}
