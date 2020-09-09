package com.temenos.microservice.paymentorder.function;

import java.util.List;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.paymentorder.function.GetInputValidationInput;
import com.temenos.microservice.paymentorder.view.PaymentStatus;

public class GetInputValidationImpl implements GetInputValidation {

	@Override
	public PaymentStatus  invoke(Context ctx, GetInputValidationInput input) throws FunctionException {
		List<String> errorList= input.getParams().get().doValidate();
		if(errorList.size()>0) {
			throw new InvalidInputException(new FailureMessage(errorList.toString()));
		}
		PaymentStatus paymentStatus = new PaymentStatus();
		paymentStatus.setStatus("Success");
		paymentStatus.setDetails("Data using query param fetched successfully");
        return paymentStatus;
	}


}
