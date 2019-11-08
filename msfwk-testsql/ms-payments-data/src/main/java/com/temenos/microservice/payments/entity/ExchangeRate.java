package com.temenos.microservice.payments.entity;

import java.math.BigDecimal;

import javax.persistence.Entity;
import javax.persistence.Id;

import com.temenos.microservice.framework.core.data.JPAEntity;

@Entity
public class ExchangeRate extends JPAEntity {

	@Id
	private int id;

	private String name;

	private BigDecimal value;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public BigDecimal getValue() {
		return value;
	}

	public void setValue(BigDecimal value) {
		this.value = value;
	}
}
