package com.temenos.microservice.payments.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import com.temenos.microservice.framework.core.data.JPAEntity;

@Entity
public class PayeeDetails extends JPAEntity {

	@Id
	@GeneratedValue
	private int payeeId;

	private String payeeName;

	private String payeeType;

	public int getPayeeId() {
		return payeeId;
	}

	public void setPayeeId(int payeeId) {
		this.payeeId = payeeId;
	}

	public String getPayeeName() {
		return payeeName;
	}

	public void setPayeeName(String payeeName) {
		this.payeeName = payeeName;
	}

	public String getPayeeType() {
		return payeeType;
	}

	public void setPayeeType(String payeeType) {
		this.payeeType = payeeType;
	}
}
