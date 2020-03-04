//***AUTO GENERATED CODE. DO NOT EDIT***.
package com.temenos.microservice.paymentorder.entity;
import com.temenos.microservice.framework.core.data.annotations.CollectionAnnotation;
import com.temenos.microservice.framework.core.data.mongodb.MongoEntity;
import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.data.BaseEntity;
import com.temenos.microservice.framework.core.data.annotations.*;
import java.util.HashMap;
import java.util.Map;

import org.bson.codecs.pojo.annotations.BsonId;
import org.bson.types.ObjectId;

import java.io.Serializable;
@CollectionAnnotation(partitionKey="payeeId", tableName="payeeDetails")
public class PayeeDetails extends BaseEntity implements Serializable, MongoEntity {
    private static final long serialVersionUID = 1L;
    
    @BsonId
    private ObjectId objectId;
	private java.lang.Long payeeId;
    
	private java.lang.String payeeName;
    
	private java.lang.String payeeType;
    public java.lang.Long getPayeeId() {
        return payeeId;
    }

    public void setPayeeId(java.lang.Long payeeId) {
        	this.payeeId = payeeId;
    }
    public java.lang.String getPayeeName() {
        return payeeName;
    }

    public void setPayeeName(java.lang.String payeeName) {
        	this.payeeName = payeeName;
    }
    public java.lang.String getPayeeType() {
        return payeeType;
    }

    public void setPayeeType(java.lang.String payeeType) {
        	this.payeeType = payeeType;
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
