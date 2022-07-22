/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.entity;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import javax.persistence.CollectionTable;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.MapKeyColumn;
import javax.persistence.GenerationType;
import javax.persistence.SequenceGenerator;

import com.temenos.microservice.framework.core.data.BaseEntity;

@Entity
public class ExchangeRate extends BaseEntity implements com.temenos.microservice.framework.core.data.Entity {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE,generator="EXCH_SEQ")
	@SequenceGenerator(sequenceName = "exch_seq", name = "EXCH_SEQ", initialValue=1000)
	private long id;

	private String name;

	private BigDecimal value;

	// maps from attribute name to value
	@ElementCollection
	@MapKeyColumn(name = "name")
	@Column(name = "value")
	@CollectionTable(name = "ExchangeRate_extension", joinColumns = @JoinColumn(name = "ExchangeRate_id"))
	Map<String, String> extensionData = new HashMap<String, String>();

	public long getId() {
		return id;
	}

	public void setId(long id) {
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

	public Map<String, String> getExtensionData() {
		return extensionData;
	}

	public void setExtensionData(Map<String, String> extensionData) {
		this.extensionData = extensionData;
	}
}
