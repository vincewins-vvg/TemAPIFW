package com.temenos.microservice.payments.function;

import java.util.ArrayList;
import java.util.List;

import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.StringUtil;
import com.temenos.microservice.payments.function.CreateNewPaymentOrderInput;
import com.temenos.microservice.payments.view.PaymentOrder;

// TODO: remove this class and input validation once the framework gen supports input validation based on mandatory/requires attributes fom swagger doc.
public class PaymentOrderFunctionHelper {

    public static void validateInput(CreateNewPaymentOrderInput input) throws InvalidInputException {
        if (!input.getBody().isPresent()) {
            throw new InvalidInputException(new FailureMessage("Input body is empty", "PAYM-PORD-A-2001"));
        }
    }

    public static void validatePaymentOrder(PaymentOrder paymentOrder) throws InvalidInputException {
        List<FailureMessage> failureMessages = new ArrayList<FailureMessage>();
        if (paymentOrder.getAmount() == null) {
            failureMessages.add(new FailureMessage("Amount is mandatory", "PAYM-PORD-A-2101"));
        }
        if (StringUtil.isNullOrEmpty(paymentOrder.getFromAccount())) {
            failureMessages.add(new FailureMessage("From Account is mandatory", "PAYM-PORD-A-2102"));
        }
        if (StringUtil.isNullOrEmpty(paymentOrder.getToAccount())) {
            failureMessages.add(new FailureMessage("To Account is mandatory", "PAYM-PORD-A-2103"));
        }
        if (StringUtil.isNullOrEmpty(paymentOrder.getCurrency())) {
            failureMessages.add(new FailureMessage("Currency is mandatory", "PAYM-PORD-A-2104"));
        }
        if (!failureMessages.isEmpty()) {
            throw new InvalidInputException(failureMessages);
        }
    }
}
