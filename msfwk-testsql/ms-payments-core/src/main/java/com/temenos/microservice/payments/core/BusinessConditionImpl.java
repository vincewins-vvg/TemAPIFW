package com.temenos.microservice.payments.core;

import java.util.HashMap;
import java.util.Map;

import com.temenos.microservice.framework.core.function.camel.IBusinessCondition;
import com.temenos.microservice.framework.view.BusinessHealthCheck;
import com.temenos.microservice.framework.view.HealthCheck;
import com.temenos.microservice.framework.view.Status;
public class BusinessConditionImpl implements IBusinessCondition {
	public BusinessHealthCheck invoke() {
		//business logic
		BusinessHealthCheck businessHealthCheck = new BusinessHealthCheck();
		businessHealthCheck.setCheckName("BusinessCondition");
		businessHealthCheck.setStatus(Status.SUCCESS);
		Map<String,String> businessInfo = new HashMap<String,String>();
		businessInfo.put("BusinessInfo", "Default Business Info");
		businessHealthCheck.setMessage(businessInfo);
		return businessHealthCheck;
		//return true;
	}
}
