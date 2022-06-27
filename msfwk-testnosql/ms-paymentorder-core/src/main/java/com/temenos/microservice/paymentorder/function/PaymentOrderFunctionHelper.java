/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.paymentorder.function;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.DataAccessException;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.data.Operator;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.security.Criteria;
import com.temenos.microservice.framework.core.security.CriterionImpl;
import com.temenos.microservice.framework.core.util.StringUtil;
import com.temenos.microservice.paymentorder.view.PaymentOrder;

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
            failureMessages.add(new FailureMessage("To Account is mandatory", "PAYM-PORD-A-2104"));
        }
        if (StringUtil.isNullOrEmpty(paymentOrder.getCurrency().toString())) {
            failureMessages.add(new FailureMessage("Currency is mandatory", "PAYM-PORD-A-2103"));
        }
        if (!failureMessages.isEmpty()) {
            throw new InvalidInputException(failureMessages);
        }
    }
    
    /**
     * Method to validate and update sequence for DynamoDB
     * 
     * @param businessKey
     * @param sourceId
     * @param sequenceNo 
     * @return expectedSequenceNumber
     * @throws DataAccessException
     */
    public static Long validateAndUpdateSequenceNumber(String businessKey, String sourceId, Long sequenceNo) throws DataAccessException {
		Long expectedSequenceNumber = 1l;
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.EventSequence> sequenceDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.EventSequence.class);
		CriterionImpl criterion1 = new CriterionImpl("eventSourceId", sourceId, Operator.equal);
		CriterionImpl criterion2 = new CriterionImpl("businessKey", businessKey, Operator.equal);
		Criteria criteria = new Criteria();
		criteria.add(criterion1);
		criteria.add(criterion2);
		List<com.temenos.microservice.paymentorder.entity.EventSequence> entityresponse = sequenceDao.getByIndexes(criteria);
		com.temenos.microservice.paymentorder.entity.EventSequence eventSequence = null;
		if(entityresponse != null && !entityresponse.isEmpty()) {
			eventSequence = entityresponse.get(0);
			expectedSequenceNumber = eventSequence.getSequenceNo() + 1;
			eventSequence.setSequenceNo(expectedSequenceNumber);
		} else {
			eventSequence = new com.temenos.microservice.paymentorder.entity.EventSequence();
			eventSequence.setBusinessKey(businessKey);
			eventSequence.setEventSourceId(sourceId);
			eventSequence.setSequenceNo(expectedSequenceNumber);
		}
		if (expectedSequenceNumber.equals(sequenceNo)) {
			sequenceDao.saveEntity(eventSequence);
		}
		return expectedSequenceNumber;
	}

}
