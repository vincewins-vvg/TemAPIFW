package com.temenos.microservice.payments.function;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.adapter.ServiceAdapterFactory;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.HttpClientRequest;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.function.Response;
import com.temenos.microservice.framework.core.util.StringUtil;
import com.temenos.microservice.payments.view.PaymentOrder;

// TODO: remove this class and input validation once the framework gen supports input validation based on mandatory/requires attributes fom swagger doc.
public class PaymentOrderFunctionHelper {

	public static void validateInput(CreateNewPaymentOrderInput input) throws InvalidInputException {
		if (!input.getBody().isPresent()) {
			throw new InvalidInputException(new FailureMessage("Input body is empty", "PAYM-PORD-A-2001"));
		}
	}

	public static void validatePaymentOrder(PaymentOrder paymentOrder, Context ctx) throws FunctionException {
		List<FailureMessage> failureMessages = new ArrayList<FailureMessage>();
		if (paymentOrder.getAmount() == null) {
			failureMessages.add(new FailureMessage("Amount is mandatory", "PAYM-PORD-A-2101"));
		}
		if (StringUtil.isNullOrEmpty(paymentOrder.getFromAccount())) {
			failureMessages.add(new FailureMessage("From Account is mandatory", "PAYM-PORD-A-2102"));
		} else {
			String irisApiResponse;
			if (Environment.getEnvironmentVariable("VALIDATE_PAYMENT_ORDER", "").equalsIgnoreCase("false")) {
				ClassLoader classLoader = PaymentOrderFunctionHelper.class.getClassLoader();
				InputStream is = classLoader.getResourceAsStream("IrisApiResponse.json");
				try {
					@SuppressWarnings("deprecation")
					String contents = org.apache.commons.io.IOUtils.toString(is);
					irisApiResponse = new JSONObject(contents).toString();
				} catch (JSONException | IOException e) {
					InvalidInputException invalidInputExp = new InvalidInputException(
							"Parse exception during RetailApiResponse json file");
					throw invalidInputExp;
				}
			} else {
				HttpClientRequest request = new HttpClientRequest.Builder()
						.basePath(Environment.getEnvironmentVariable("IRIS_BASE_URI",
								"http://10.92.17.106:9089/irf-provider-container/api/"))
						.resourcePath("v2.0.0/holdings/PSD2/accounts/" + paymentOrder.getFromAccount() + "/balances")
						.context(ctx).build();

				Response<String> response = ServiceAdapterFactory.getServiceAdapter().get(request);
				if (response.getStatus() != 200) {
					FunctionException exception = new FunctionException(response.getFailureMessages()) {
						private static final long serialVersionUID = 1L;

						@Override
						public int getStatusCode() {
							return response.getStatus();
						}
					};
					throw exception;
				}
				irisApiResponse = response.getBody();
			}

			JSONObject irisResponse = new JSONObject(irisApiResponse);
			System.out.println("IRIS Response:" + irisResponse);
			JSONArray responseBody = irisResponse.getJSONArray("body");
			JSONObject jsonBody = responseBody.getJSONObject(0);

			java.math.BigDecimal availableBalance;
			if (Environment.getEnvironmentVariable("VALIDATE_PAYMENT_ORDER", "").equalsIgnoreCase("false")) {
				availableBalance = new java.math.BigDecimal(jsonBody.get("availableBalance").toString());
			} else {
				availableBalance = new java.math.BigDecimal(jsonBody.get("balanceAmount").toString());
			}

			if (availableBalance.compareTo(paymentOrder.getAmount()) < 0) {
				failureMessages
						.add(new FailureMessage("From Account does not have sufficient balance", "PAYM-PORD-A-2103"));
			}
		}
		if (StringUtil.isNullOrEmpty(paymentOrder.getToAccount())) {
			failureMessages.add(new FailureMessage("To Account is mandatory", "PAYM-PORD-A-2104"));
		}
		if (StringUtil
				.isNullOrEmpty(paymentOrder.getCurrency() == null ? null : paymentOrder.getCurrency().toString())) {
			failureMessages.add(new FailureMessage("Currency is mandatory", "PAYM-PORD-A-2105"));
		}
		if (!failureMessages.isEmpty()) {
			throw new InvalidInputException(failureMessages);
		}
	}
}
