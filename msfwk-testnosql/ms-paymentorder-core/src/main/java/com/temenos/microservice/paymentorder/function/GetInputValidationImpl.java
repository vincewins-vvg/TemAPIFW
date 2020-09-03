package com.temenos.microservice.paymentorder.function;

import java.util.List;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.paymentorder.view.GetPaymentDetails;

public class GetInputValidationImpl implements GetInputValidation {

	@Override
	public GetPaymentDetails invoke(Context ctx, GetInputValidationInput input) throws FunctionException {
		GetPaymentDetails paymentDetails = new GetPaymentDetails();
		String paymentId = null;
		if(input.getParams().get().getPaymentId()!=null) {
			paymentId = input.getParams().get().getPaymentId().get(0);
		paymentDetails.setPaymentId(paymentId);
		}
		List<String> errorList= paymentDetails.doValidate();
		if(errorList.size()>0) {
			throw new InvalidInputException(new FailureMessage(errorList.toString()));
		}
			return paymentDetails;
	}

}
