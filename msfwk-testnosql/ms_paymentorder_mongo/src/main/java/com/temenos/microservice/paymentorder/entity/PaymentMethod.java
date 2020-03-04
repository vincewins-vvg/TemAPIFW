//***AUTO GENERATED CODE. DO NOT EDIT***.
package com.temenos.microservice.paymentorder.entity;
import com.temenos.microservice.framework.core.data.annotations.CollectionAnnotation;
import com.temenos.microservice.framework.core.data.mongodb.MongoEntity;
import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.data.BaseEntity;
import com.temenos.microservice.framework.core.data.annotations.*;
import java.util.HashMap;
import java.util.Map;
import java.io.Serializable;
import org.bson.codecs.pojo.annotations.*;
import org.bson.types.ObjectId;

@CollectionAnnotation(partitionKey="id", tableName="paymentMethod")
public class PaymentMethod extends BaseEntity implements Serializable, MongoEntity {
    private static final long serialVersionUID = 1L;
	
	@BsonId
	private ObjectId objectId;
    
	private java.lang.Long id;
    
	private java.lang.String name;
    
	private Card card;
    public java.lang.Long getId() {
        return id;
    }

    public void setId(java.lang.Long id) {
        	this.id = id;
    }
    public java.lang.String getName() {
        return name;
    }

    public void setName(java.lang.String name) {
        	this.name = name;
    }
    public Card getCard() {
        return card;
    }

    public void setCard(Card card) {
        	this.card = card;
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
