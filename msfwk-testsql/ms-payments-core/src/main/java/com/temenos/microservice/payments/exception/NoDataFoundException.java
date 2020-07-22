package com.temenos.microservice.payments.exception;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.FailureMessage;

/**
 * Exception used to Data Not Available conditions.
 *	The class {@code DataNotFoundException} and its subclasses are a form of
 * 	{@code Throwable} that indicates conditions that a reasonable
 *  application might want to catch
 */
public class NoDataFoundException extends FunctionException{

	public NoDataFoundException(FailureMessage failureMessage) {
		super(failureMessage);
	}

	@Override
	public int getStatusCode() {
		return 404;
	}

}
