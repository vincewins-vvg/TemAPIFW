//***AUTO GENERATED CODE. DO NOT EDIT***.
package com.temenos.microservice.paymentorder.entity;

import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.data.BaseEntity;
import com.temenos.microservice.framework.core.data.annotations.*;
import java.util.HashMap;
import java.util.Map;
import java.io.Serializable;
import com.temenos.microservice.framework.core.data.annotations.CollectionAnnotation;
import com.temenos.microservice.framework.core.data.mongodb.MongoEntity;

import org.bson.codecs.pojo.annotations.*;
import org.bson.types.ObjectId;

@CollectionAnnotation(partitionKey="cardid", tableName="Card")
public class Card extends BaseEntity implements Serializable, MongoEntity {
    private static final long serialVersionUID = 1L;
    @BsonId
	private ObjectId objectId;
    
	private java.lang.Long cardid;
    
	private java.lang.String cardname;
    
	private java.math.BigDecimal cardlimit;
    public java.lang.Long getCardid() {
        return cardid;
    }

    public void setCardid(java.lang.Long cardid) {
        	this.cardid = cardid;
    }
    public java.lang.String getCardname() {
        return cardname;
    }

    public void setCardname(java.lang.String cardname) {
        	this.cardname = cardname;
    }
    public java.math.BigDecimal getCardlimit() {
        return cardlimit;
    }

    public void setCardlimit(java.math.BigDecimal cardlimit) {
        	this.cardlimit = cardlimit;
    }
	Map<String, String> extensionData = new HashMap<String, String>();
	
	public Map<String, String> getExtensionData() {
		return extensionData;
	}

	public void setExtensionData(Map<String, String> extensionData) {
		this.extensionData = extensionData;
	}
	@Override
	public ObjectId getObjectId() {
	
	return objectId;
}
}
