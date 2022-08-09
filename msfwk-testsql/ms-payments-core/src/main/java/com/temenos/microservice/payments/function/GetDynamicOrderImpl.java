/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
/**
======================
 Modification History 
======================

* 04/08/2022 - Story: MFW-2418 / Task: MFW-2485
*              Response headers and response code added in the exposed method. 
*  
*/
package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.core.GetPaymentOrdersProcessor;
import com.temenos.microservice.payments.function.GetDynamicOrder;
import com.temenos.microservice.payments.function.GetDynamicOrderInput;
import com.temenos.microservice.payments.view.GetDynamicOrderParams;
import com.temenos.microservice.framework.core.function.Context;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.json.simple.parser.JSONParser;

import com.temenos.microservice.framework.core.util.FrameworkConstants;
import com.temenos.microservice.framework.core.util.JsonUtil;
import java.lang.Object;
import java.lang.String;

public class GetDynamicOrderImpl implements GetDynamicOrder {

	@Override
	public JSONObject invoke(Context context, GetDynamicOrderInput input) throws FunctionException {

		java.util.Optional<GetDynamicOrderParams> params = input.getParams();
		GetDynamicOrderParams test = params.get();

		Map<String, Object> responseheaders = new HashMap<>(); // HashMap Object is created.
		responseheaders.put("ResponseAccept", "Accepted"); // key value pair added into map.

		context.setResponseCode("202"); // Setting response code
		context.setResponseHeaders(responseheaders); // Setting response header

		JSONParser parser = new JSONParser();
		List<Integer> list = test.getId();
		List<String> list1 = test.getOrder();
		Object obj = null;
		JSONObject json = new JSONObject();

		if (list1 != null && list1.get(0) != null) {

			switch (list1.get(0)) {
			case "order":
				json.put("id", 1000);
				json.put("name", "aaru");
				break;
			case "employee":
				json.put("emp_id", "101");
				json.put("salary", "15000");
				json.put("name", "emma watson");
				json.put("address", "new delhi");
				json.put("department", "IT");
				json.put("email", "Emmawatson123@gmail.com");
				break;
			case "customer":
				json.put("name", "Jany");
				json.put("age", "25");
				json.put("gender", "female");
				json.put("place", "mexico");
				break;
			default:
				json.put("not-match-found", list.get(0));

			}
		}
		
		return json;

	}
}
