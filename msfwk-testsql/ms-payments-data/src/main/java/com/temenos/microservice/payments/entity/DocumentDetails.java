package com.temenos.microservice.payments.entity;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class DocumentDetails implements  com.temenos.microservice.framework.core.data.Entity{
	
	@Id
	private String id;
	private String documentId;
	private String documentName;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getDocumentId() {
		return documentId;
	}

	public void setDocumentId(String documentId) {
		this.documentId = documentId;
	}

	public String getDocumentName() {
		return documentName;
	}

	public void setDocumentName(String documentName) {
		this.documentName = documentName;
	}


}
