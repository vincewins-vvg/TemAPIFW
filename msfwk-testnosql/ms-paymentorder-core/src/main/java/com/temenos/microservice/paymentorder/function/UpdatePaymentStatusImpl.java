package com.temenos.microservice.paymentorder.function;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.data.Operator;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.security.Criteria;
import com.temenos.microservice.framework.core.security.CriteriaUpdate;
import com.temenos.microservice.framework.core.security.CriterionImpl;
import com.temenos.microservice.framework.core.security.CriterionUpdateImpl;
import com.temenos.microservice.framework.core.util.DataTypeConverter;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.paymentorder.entity.Card;
import com.temenos.microservice.paymentorder.entity.ExchangeRate;
import com.temenos.microservice.paymentorder.entity.PaymentMethod;
import com.temenos.microservice.paymentorder.entity.PaymentOrder;
import com.temenos.microservice.paymentorder.view.AllPaymentStatus;
import com.temenos.microservice.paymentorder.view.CriteriaDetails;
import com.temenos.microservice.paymentorder.view.PaymentStatus;

public class UpdatePaymentStatusImpl implements UpdateStatus{

	@Override
    public PaymentStatus invoke(Context ctx, UpdateStatusInput input) throws FunctionException {
        String paymentStatus = null;
        PaymentStatus paymentStatusObj = null;
        if(input.getBody() != null && input.getBody().get().getStatus() != null) {
            paymentStatus = input.getBody().get().getStatus();
        } else {
            throw new InvalidInputException(new FailureMessage("Invalid Status or Null Body in request",
                    MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
        }
        List<CriteriaDetails> updateCondition = null;
        if(input.getBody().get().getCriteriaDetails() != null) {
            updateCondition = input.getBody().get().getCriteriaDetails();
        } else {
            throw new InvalidInputException(new FailureMessage("Invalid Criteria or Null Body in request",
                    MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
        }
        NoSqlDbDao<com.temenos.microservice.paymentorder.entity.PaymentOrder> paymentOrderDao = DaoFactory
                .getNoSQLDao(com.temenos.microservice.paymentorder.entity.PaymentOrder.class);   
        Criteria criteria = new Criteria();
        for(CriteriaDetails details: updateCondition) {
            if(details.getNameOfCriteria() != null && details.getValueOfCriteria() != null) {
                if(details.getValueOfCriteria() instanceof String && details.getValueOfCriteria().matches("[0-9]{4}[-]{1}[0-9]{2}[-]{1}[0-9]{2}")) {
                    try {
                        criteria.add(new CriterionImpl(details.getNameOfCriteria(),DataTypeConverter.toDate(details.getValueOfCriteria(),"yyyy-MM-dd") , Operator.equal));
                    } catch (ParseException e) {
                        throw new InvalidInputException(new FailureMessage("Invalid or Null date values entered",
                                MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
                    }
                } else {
                criteria.add(new CriterionImpl(details.getNameOfCriteria(), details.getValueOfCriteria(), Operator.equal));
                }
            } else {
                throw new InvalidInputException(new FailureMessage("Invalid or Null Criteria values entered",
                        MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
            }
        }
        CriteriaUpdate updaeCriteria = new CriteriaUpdate();
        if(paymentStatus != null && paymentStatus.length() > 0){
            updaeCriteria.add(new CriterionUpdateImpl("status", paymentStatus));
        }      
        else {
            throw new InvalidInputException(new FailureMessage("Invalid or Null status value entered",
                    MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
        }
        if(input.getBody() != null && input.getBody().get().getPaymentStatus() != null) {
        	paymentStatusObj = input.getBody().get().getPaymentStatus();
	        if(paymentStatusObj.getDebitAccount() != null && paymentStatusObj.getDebitAccount().length() > 0){
	            updaeCriteria.add(new CriterionUpdateImpl("debitAccount", paymentStatusObj.getDebitAccount()));
	        }
	        if(paymentStatusObj.getPaymentId() != null && paymentStatusObj.getPaymentId().length() > 0){
	            updaeCriteria.add(new CriterionUpdateImpl("paymentId", paymentStatusObj.getPaymentId()));
	        }
	        if(paymentStatusObj.getFileReadWrite() != null){
	            updaeCriteria.add(new CriterionUpdateImpl("fileReadWrite", paymentStatusObj.getFileReadWrite()));
	        }
	        if(paymentStatusObj.getExtensionData() != null){
	            updaeCriteria.add(new CriterionUpdateImpl("extensionData", paymentStatusObj.getExtensionData()));
	        }
	        if(paymentStatusObj.getPaymentMethod() != null){
	            updaeCriteria.add(new CriterionUpdateImpl("paymentMethod", paymentStatusObj.getPaymentMethod()));
	        }
	        if(paymentStatusObj.getExchangeRates() != null){
	            updaeCriteria.add(new CriterionUpdateImpl("exchangeRates", paymentStatusObj.getExchangeRates()));
	        }
        }
        
        long updatedCount = paymentOrderDao.updateEntity(criteria, updaeCriteria, com.temenos.microservice.paymentorder.entity.PaymentOrder.class);   
        PaymentStatus payStatus = new PaymentStatus();
        payStatus.setStatus("Updated "+updatedCount +" PaymentIds which satisfy this Criteria");
        return payStatus;
    }
}