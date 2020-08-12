package com.temenos.microservice.payments.entity;

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

@Entity
public class PayeeDetails implements com.temenos.microservice.framework.core.data.Entity {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE,generator="PAYEE_SEQ")
	@SequenceGenerator(sequenceName = "payee_seq", initialValue=100, name = "PAYEE_SEQ")
	private int payeeId;

	private String payeeName;

	private String payeeType;

	// maps from attribute name to value
	@ElementCollection
	@MapKeyColumn(name = "name")
	@Column(name = "value")
	@CollectionTable(name = "PayeeDetails_extension", joinColumns = @JoinColumn(name = "PayeeDetails_id"))
	Map<String, String> extensionData = new HashMap<String, String>();

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
	
	public Map<String, String> getExtensionData() {
		return extensionData;
	}

	public void setExtensionData(Map<String, String> extensionData) {
		this.extensionData = extensionData;
	}

}
