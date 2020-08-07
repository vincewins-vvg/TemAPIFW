package com.temenos.sample.entity;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import javax.persistence.CollectionTable;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.MapKeyColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;


@Entity
@Table(name="card")
public class Card {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE,generator="CARD_SEQ")
	@SequenceGenerator(sequenceName = "card_seq", allocationSize = 1, name = "CARD_SEQ")
	private long id;

	@Column
	private String cardname;

	@Column
	private BigDecimal cardlimit;

	@OneToOne(mappedBy="card")
	private Customer customer;
	
	// maps from attribute name to value
	@ElementCollection
	@MapKeyColumn(name = "name")
	@Column(name = "value")
	@CollectionTable(name = "Card_extension", joinColumns = @JoinColumn(name = "Card_cardid"))
	Map<String, String> extensionData = new HashMap<String, String>();

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
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
	
	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

}
