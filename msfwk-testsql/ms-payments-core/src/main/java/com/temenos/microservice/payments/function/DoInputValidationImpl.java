package com.temenos.microservice.payments.function;


import java.util.List;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.payments.function.DoInputValidation;
import com.temenos.microservice.payments.function.DoInputValidationInput;
import com.temenos.microservice.payments.view.PaymentDetails;

/**
 * DoInputValidation class.
 * 
 * Performs all datatypes validation
 *
 */
public class DoInputValidationImpl implements DoInputValidation {
	
	
	@Override
	public PaymentDetails invoke(Context ctx, DoInputValidationInput input) throws FunctionException {

		PaymentDetails paymentDetails = input.getBody().get();
		
		//method does validation based on swagger input
		List<String> errorList= paymentDetails.doValidate();
		if(errorList.size()>0)
			throw new InvalidInputException(new FailureMessage(errorList.toString()));
		return paymentDetails;
	}

}