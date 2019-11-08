package com.temenos.microservice.payments.entity;

import java.math.BigDecimal;

import javax.persistence.Entity;
import javax.persistence.Id;

import com.temenos.microservice.framework.core.data.JPAEntity;

@Entity
public class Card extends JPAEntity {

	@Id
	private int cardid;

	private String cardname;

	private BigDecimal cardlimit;

	public int getCardid() {
		return cardid;
	}

	public void setCardid(int cardid) {
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
}
