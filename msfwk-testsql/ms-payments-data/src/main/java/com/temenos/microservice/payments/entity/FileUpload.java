package com.temenos.microservice.payments.entity;

import java.lang.annotation.Annotation;
import java.sql.Blob;
import java.util.Map;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import com.temenos.microservice.framework.core.data.ExtendableEntity;

import javax.persistence.CascadeType;
import javax.persistence.Entity;


@Entity
@Table(name = "ms_file_upload")
public class FileUpload implements com.temenos.microservice.framework.core.data.Entity{

	@Id
	private String name;

	private String mimeType;

	private Blob data;
	
	@OneToOne(cascade = CascadeType.ALL)
	private DocumentDetails documentDetails;
	
	public DocumentDetails getDocumentDetails() {
		return documentDetails;
	}

	public void setDocumentDetails(DocumentDetails documentDetails) {
		this.documentDetails = documentDetails;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getMimeType() {
		return mimeType;
	}

	public void setMimeType(String mimeType) {
		this.mimeType = mimeType;
	}

	public Blob getData() {
		return data;
	}

	public void setData(Blob data) {
		this.data = data;
	}

}
