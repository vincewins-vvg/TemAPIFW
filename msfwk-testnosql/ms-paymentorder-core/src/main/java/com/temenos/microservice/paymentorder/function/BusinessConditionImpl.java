package com.temenos.microservice.paymentorder.function;

import java.util.HashMap;
import java.util.Map;

import com.temenos.microservice.framework.core.health.BusinessHealthIndicator;
import com.temenos.microservice.framework.core.health.view.BusinessHealthCheck;
import com.temenos.microservice.framework.core.health.view.Status;


public class BusinessConditionImpl implements BusinessHealthIndicator {
	@Override
	public BusinessHealthCheck doHealthCheck() {
		BusinessHealthCheck businessHealthCheck = new BusinessHealthCheck();
		businessHealthCheck.setCheckName("BusinessCondition");
		businessHealthCheck.setStatus(Status.SUCCESS);
		Map<String,String> businessInfo = new HashMap<String,String>();
		businessInfo.put("BusinessInfo", "Default Business Info");
		businessHealthCheck.setMessage(businessInfo);
		return businessHealthCheck;
	}
}
