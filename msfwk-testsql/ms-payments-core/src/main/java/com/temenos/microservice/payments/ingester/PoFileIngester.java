package com.temenos.microservice.payments.ingester;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.json.simple.parser.JSONParser;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.ingester.FileIngestionFunction;
import com.temenos.microservice.framework.core.util.JsonUtil;
import com.temenos.microservice.payments.function.CreateNewPaymentOrderImpl;
import com.temenos.microservice.payments.function.CreateNewPaymentOrderInput;
import com.temenos.microservice.payments.view.PaymentOrder;

public class PoFileIngester extends FileIngestionFunction {

	@Override
	public InputStream invoke(Context ctx, InputStream input) throws FunctionException {

		BufferedReader br = new BufferedReader(new InputStreamReader(input));

		JSONParser jsonParser = new JSONParser();
		try {
			Object obj = jsonParser.parse(br);
			Object payloadObject = JsonUtil.readValue(obj.toString(), PaymentOrder.class);
			System.out.println(payloadObject);
			CreateNewPaymentOrderInput inp = new CreateNewPaymentOrderInput((PaymentOrder) payloadObject);
			CreateNewPaymentOrderImpl poImpl = new CreateNewPaymentOrderImpl();
			poImpl.invoke(ctx, inp);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return input;
	}

}
