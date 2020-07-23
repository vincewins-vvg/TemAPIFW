package com.temenos.microservice.paymentorder.exception;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.FailureMessage;

import java.util.List;

/**
 * Exception used to handle Input Data Validation conditions.
 *	The class {@code InvalidInputException} and its subclasses are a form of
 * 	{@code Throwable} that indicates conditions that a reasonable
 *  application might want to catch
 */
public class StorageException extends FunctionException {
    
    private static final int statusCode = 404;
    
    private static final long serialVersionUID = 1L;
    
    
    /**
     * Preferred method for raising a new  {@code InvalidInputException} 
     * @param message user defined message provides reason for failure
     * @param cause reference to the original exception which gets wrapped.
     */
    public StorageException(String message, Throwable cause) {
        super(message, cause);
    }
    /**
     * Used to handle invalid data input conditions in the Microservice Function layer
     * Since application loses the original exception it is a least preferred constructor for raising a new  {@code InvalidInputException}
     * @param message user defined message provides reason for failure
     * 
     */
    public StorageException(String message) {
        super(message);
    }
    /**
     * Used to handle invalid data input conditions in the Microservice Function layer
     * Since application loses the original exception it is a least preferred constructor. 
     * @param failureMessage
     */
    public StorageException(FailureMessage failureMessage) {
        super(failureMessage);
    }
    
    
    /**
     * Used to handle invalid data input conditions in the Microservice Function layer
     * Less Preferred InvalidInputException Construtor. 
     * Construct InvalidInputException without original exception references 
     * Preferred to use the another constructor which accepts original exception
     * @param failureMessage
     */
    public StorageException(List<FailureMessage> failureMessages) {
        super(failureMessages);
    }

    @Override
    public int getStatusCode() {
        return statusCode;
    }
}
