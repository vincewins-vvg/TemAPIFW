/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.core.GetPaymentOrdersProcessor;
import com.temenos.microservice.paymentsorder.function.GetDynamicOrder;
import com.temenos.microservice.paymentsorder.function.GetDynamicOrderInput;
import java.util.List;
import org.json.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.temenos.microservice.framework.core.util.JsonUtil;
import com.temenos.microservice.paymentsorder.view.*;
import java.lang.Object;

public class GetDynamicOrderImpl implements GetDynamicOrder {

	@Override
	public JSONObject invoke(Context context, GetDynamicOrderInput input) throws FunctionException {

		java.util.Optional<GetDynamicOrderParams> params = input.getParams();
		GetDynamicOrderParams test = params.get();
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
