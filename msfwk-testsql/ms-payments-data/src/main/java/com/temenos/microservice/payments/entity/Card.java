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
import javax.persistence.Id;
import javax.persistence.Index;
import javax.persistence.JoinColumn;
import javax.persistence.MapKeyColumn;
import javax.persistence.Table;

@Entity
@Table(indexes = { @Index(columnList = "cardname") })
public class Card implements com.temenos.microservice.framework.core.data.Entity {

	@Id
	private long cardid;

	private String cardname;

	private BigDecimal cardlimit;

	// maps from attribute name to value
	@ElementCollection
	@MapKeyColumn(name = "name")
	@Column(name = "value")
	@CollectionTable(name = "Card_extension", joinColumns = @JoinColumn(name = "Card_cardid"))
	Map<String, String> extensionData = new HashMap<String, String>();

	public long getCardid() {
		return cardid;
	}

	public void setCardid(long cardid) {
		this.cardid = cardid;
	}

	public String getCardname() {
		return cardname;
	}

	public void setCardname(String cardname) {
		this.cardname = cardname;
	}

	public BigDecimal getCardlimit() {
		return cardlimit;
	}

	public void setCardlimit(BigDecimal cardlimit) {
		this.cardlimit = cardlimit;
	}

	public Map<String, String> getExtensionData() {
		return extensionData;
	}

	public void setExtensionData(Map<String, String> extensionData) {
		this.extensionData = extensionData;
	}
}
