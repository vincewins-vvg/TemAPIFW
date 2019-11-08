package com.temenos.microservice.payments.entity;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToOne;

import com.temenos.microservice.framework.core.data.JPAEntity;

@Entity
public class PaymentMethod extends JPAEntity {

	@Id
	private int id;

	private String name;

	@OneToOne(cascade = CascadeType.ALL)
	private Card card;

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

	public Card getCard() {
		return card;
	}

	public void setCard(Card card) {
		this.card = card;
	}
}
